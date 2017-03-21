﻿#region header

// ========================================================================
// Copyright (c) 2017 - Julien Caillon (julien.caillon@gmail.com)
// This file (CommonMarkConverter.cs) is part of 3P.
// 
// 3P is a free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// 3P is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with 3P. If not, see <http://www.gnu.org/licenses/>.
// ========================================================================

#endregion

using System;
using System.IO;
using System.Reflection;
using System.Text;
using System.Threading;
using _3PA.Lib.CommonMark.Formatters;
using _3PA.Lib.CommonMark.Parser;
using _3PA.Lib.CommonMark.Syntax;

namespace _3PA.Lib.CommonMark {
    /// <summary>
    /// Contains methods for parsing and formatting CommonMark data.
    /// </summary>
    public static class CommonMarkConverter {
        private static Lazy<Assembly> _assembly = new Lazy<Assembly>(InitializeAssembly, LazyThreadSafetyMode.None);

        private static Assembly Assembly {
            get { return _assembly.Value; }
        }

        private static Assembly InitializeAssembly() {
#if NETCore || portable_259
            return typeof(CommonMarkConverter).GetTypeInfo().Assembly;
#else
            return typeof(CommonMarkConverter).Assembly;
#endif
        }

        private static Lazy<Version> _version = new Lazy<Version>(InitializeVersion, LazyThreadSafetyMode.None);

        /// <summary>
        /// Gets the CommonMark package version number.
        /// Note that this might differ from the actual assembly version which is updated less often to
        /// reduce problems when upgrading the nuget package.
        /// </summary>
        public static Version Version {
            get { return _version.Value; }
        }

        private static Version InitializeVersion() {
#if NETCore
            return new AssemblyName(Assembly.FullName).Version;
#else
            // System.Xml is not available so resort to string parsing.
            using (var stream = Assembly.GetManifestResourceStream("CommonMark.Properties.CommonMark.NET.nuspec"))
            using (var reader = new StreamReader(stream, Encoding.UTF8)) {
                string line;
                while ((line = reader.ReadLine()) != null) {
                    var i = line.IndexOf("<version>", StringComparison.Ordinal);
                    if (i == -1)
                        continue;

                    i += 9;
                    return new Version(line.Substring(i, line.IndexOf("</version>", StringComparison.Ordinal) - i));
                }
            }
            return null;
#endif
        }

        /// <summary>
        /// Gets the CommonMark assembly version number. Note that might differ from the actual release version
        /// since the assembly version is not always incremented to reduce possible reference errors when updating.
        /// </summary>
        [Obsolete("Use Version property instead.", false)]
        [System.Diagnostics.DebuggerBrowsable(System.Diagnostics.DebuggerBrowsableState.Never)]
        [System.ComponentModel.EditorBrowsable(System.ComponentModel.EditorBrowsableState.Never)]
        public static Version AssemblyVersion {
            get { return new AssemblyName(Assembly.FullName).Version; }
        }

        /// <summary>
        /// Performs the first stage of the conversion - parses block elements from the source and created the syntax tree.
        /// </summary>
        /// <param name="source">The reader that contains the source data.</param>
        /// <param name="settings">The object containing settings for the parsing process.</param>
        /// <returns>The block element that represents the document.</returns>
        /// <exception cref="ArgumentNullException">when <paramref name="source"/> is <see langword="null"/></exception>
        /// <exception cref="CommonMarkException">when errors occur during block parsing.</exception>
        /// <exception cref="IOException">when error occur while reading the data.</exception>
        [System.ComponentModel.EditorBrowsable(System.ComponentModel.EditorBrowsableState.Advanced)]
        public static Block ProcessStage1(TextReader source, CommonMarkSettings settings = null) {
            if (source == null)
                throw new ArgumentNullException("source");

            if (settings == null)
                settings = CommonMarkSettings.Default;

            var cur = Block.CreateDocument();
            var doc = cur;
            var line = new LineInfo(settings.TrackSourcePosition);

            try {
                var reader = new TabTextReader(source);
                reader.ReadLine(line);
                while (line.Line != null) {
                    BlockMethods.IncorporateLine(line, ref cur);
                    reader.ReadLine(line);
                }
            } catch (IOException) {
                throw;
            } catch (CommonMarkException) {
                throw;
            } catch (Exception ex) {
                throw new CommonMarkException("An error occurred while parsing line " + line, cur, ex);
            }

            try {
                do {
                    BlockMethods.Finalize(cur, line);
                    cur = cur.Parent;
                } while (cur != null);
            } catch (CommonMarkException) {
                throw;
            } catch (Exception ex) {
                throw new CommonMarkException("An error occurred while finalizing open containers.", cur, ex);
            }

            return doc;
        }

        /// <summary>
        /// Performs the second stage of the conversion - parses block element contents into inline elements.
        /// </summary>
        /// <param name="document">The top level document element.</param>
        /// <param name="settings">The object containing settings for the parsing process.</param>
        /// <exception cref="ArgumentException">when <paramref name="document"/> does not represent a top level document.</exception>
        /// <exception cref="ArgumentNullException">when <paramref name="document"/> is <see langword="null"/></exception>
        /// <exception cref="CommonMarkException">when errors occur during inline parsing.</exception>
        [System.ComponentModel.EditorBrowsable(System.ComponentModel.EditorBrowsableState.Advanced)]
        public static void ProcessStage2(Block document, CommonMarkSettings settings = null) {
            if (document == null)
                throw new ArgumentNullException("document");

            if (document.Tag != BlockTag.Document)
                throw new ArgumentException("The block element passed to this method must represent a top level document.", "document");

            if (settings == null)
                settings = CommonMarkSettings.Default;

            try {
                BlockMethods.ProcessInlines(document, document.Document, settings);
            } catch (CommonMarkException) {
                throw;
            } catch (Exception ex) {
                throw new CommonMarkException("An error occurred during inline parsing.", ex);
            }
        }

        /// <summary>
        /// Performs the last stage of the conversion - converts the syntax tree to HTML representation.
        /// </summary>
        /// <param name="document">The top level document element.</param>
        /// <param name="target">The target text writer where the result will be written to.</param>
        /// <param name="settings">The object containing settings for the formatting process.</param>
        /// <exception cref="ArgumentException">when <paramref name="document"/> does not represent a top level document.</exception>
        /// <exception cref="ArgumentNullException">when <paramref name="document"/> or <paramref name="target"/> is <see langword="null"/></exception>
        /// <exception cref="CommonMarkException">when errors occur during formatting.</exception>
        /// <exception cref="IOException">when error occur while writing the data to the target.</exception>
        [System.ComponentModel.EditorBrowsable(System.ComponentModel.EditorBrowsableState.Advanced)]
        public static void ProcessStage3(Block document, TextWriter target, CommonMarkSettings settings = null) {
            if (document == null)
                throw new ArgumentNullException("document");

            if (target == null)
                throw new ArgumentNullException("target");

            if (document.Tag != BlockTag.Document)
                throw new ArgumentException("The block element passed to this method must represent a top level document.");

            if (settings == null)
                settings = CommonMarkSettings.Default;

            try {
                switch (settings.OutputFormat) {
                    case OutputFormat.Html:
                        HtmlFormatterSlim.BlocksToHtml(target, document, settings);
                        break;
                    case OutputFormat.SyntaxTree:
                        Printer.PrintBlocks(target, document, settings);
                        break;
                    case OutputFormat.CustomDelegate:
                        if (settings.OutputDelegate == null)
                            throw new CommonMarkException("If `settings.OutputFormat` is set to `CustomDelegate`, the `settings.OutputDelegate` property must be populated.");
                        settings.OutputDelegate(document, target, settings);
                        break;
                    default:
                        throw new CommonMarkException("Unsupported value '" + settings.OutputFormat + "' in `settings.OutputFormat`.");
                }
            } catch (CommonMarkException) {
                throw;
            } catch (IOException) {
                throw;
            } catch (Exception ex) {
                throw new CommonMarkException("An error occurred during formatting of the document.", ex);
            }
        }

        /// <summary>
        /// Parses the given source data and returns the document syntax tree. Use <see cref="ProcessStage3"/> to
        /// convert the document to HTML using the built-in converter.
        /// </summary>
        /// <param name="source">The reader that contains the source data.</param>
        /// <param name="settings">The object containing settings for the parsing and formatting process.</param>
        /// <exception cref="ArgumentNullException">when <paramref name="source"/> is <see langword="null"/></exception>
        /// <exception cref="CommonMarkException">when errors occur during parsing.</exception>
        /// <exception cref="IOException">when error occur while reading or writing the data.</exception>
        public static Block Parse(TextReader source, CommonMarkSettings settings = null) {
            if (settings == null)
                settings = CommonMarkSettings.Default;

            var document = ProcessStage1(source, settings);
            ProcessStage2(document, settings);
            return document;
        }

        /// <summary>
        /// Parses the given source data and returns the document syntax tree. Use <see cref="ProcessStage3"/> to
        /// convert the document to HTML using the built-in converter.
        /// </summary>
        /// <param name="source">The source data.</param>
        /// <param name="settings">The object containing settings for the parsing and formatting process.</param>
        /// <exception cref="ArgumentNullException">when <paramref name="source"/> is <see langword="null"/></exception>
        /// <exception cref="CommonMarkException">when errors occur during parsing.</exception>
        /// <exception cref="IOException">when error occur while reading or writing the data.</exception>
        public static Block Parse(string source, CommonMarkSettings settings = null) {
            if (source == null)
                return null;

            using (var reader = new StringReader(source))
                return Parse(reader, settings);
        }

        /// <summary>
        /// Converts the given source data and writes the result directly to the target.
        /// </summary>
        /// <param name="source">The reader that contains the source data.</param>
        /// <param name="target">The target text writer where the result will be written to.</param>
        /// <param name="settings">The object containing settings for the parsing and formatting process.</param>
        /// <exception cref="ArgumentNullException">when <paramref name="source"/> or <paramref name="target"/> is <see langword="null"/></exception>
        /// <exception cref="CommonMarkException">when errors occur during parsing or formatting.</exception>
        /// <exception cref="IOException">when error occur while reading or writing the data.</exception>
        public static void Convert(TextReader source, TextWriter target, CommonMarkSettings settings = null) {
            if (settings == null)
                settings = CommonMarkSettings.Default;

            var document = ProcessStage1(source, settings);
            ProcessStage2(document, settings);
            ProcessStage3(document, target, settings);
        }

        /// <summary>
        /// Converts the given source data and returns the result as a string.
        /// </summary>
        /// <param name="source">The source data.</param>
        /// <param name="settings">The object containing settings for the parsing and formatting process.</param>
        /// <exception cref="CommonMarkException">when errors occur during parsing or formatting.</exception>
        /// <returns>The converted data.</returns>
        public static string Convert(string source, CommonMarkSettings settings = null) {
            if (source == null)
                return null;

            using (var reader = new StringReader(source))
            using (var writer = new StringWriter(System.Globalization.CultureInfo.CurrentCulture)) {
                Convert(reader, writer, settings);

                return writer.ToString();
            }
        }
    }
}