﻿#region header
// ========================================================================
// Copyright (c) 2015 - Julien Caillon (julien.caillon@gmail.com)
// This file (SettingAppearance.cs) is part of 3P.
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
using System.Drawing;
using System.Linq;
using System.Windows.Forms;
using YamuiFramework.Controls;
using YamuiFramework.Themes;
using _3PA.Html;
using _3PA.MainFeatures.AutoCompletion;
using _3PA.MainFeatures.FilesInfoNs;

namespace _3PA.MainFeatures.Appli.Pages.Options {
    internal partial class SettingAppearance : YamuiPage {

        private static YamuiColorRadioButton _checkButton;

        public SettingAppearance() {
            InitializeComponent();

            // AccentColors picker
            int x = 0;
            int y = 0;
            foreach (var accentColor in YamuiThemeManager.GetAccentColors) {
                var newColorPicker = new YamuiColorRadioButton();
                PanelAccentColor.Controls.Add(newColorPicker);
                newColorPicker.CheckedChanged += NewColorPickerOnCheckedChanged;
                newColorPicker.BackColor = accentColor;
                newColorPicker.Bounds = new Rectangle(x, y, 50, 50);
                if (y + 2*newColorPicker.Height > PanelAccentColor.Height) {
                    x += newColorPicker.Width;
                    y = 0;
                } else
                    y += newColorPicker.Height;
                if (YamuiThemeManager.AccentColor == accentColor) {
                    _checkButton = newColorPicker;
                    newColorPicker.Checked = true;
                }
            }

            // themes combo box
            comboTheme.DataSource = ThemeManager.GetThemesList().Select(theme => theme.ThemeName).ToList();
            comboTheme.SelectedIndex = ThemeManager.GetThemesList().FindIndex(theme => theme.UniqueId == Config.Instance.ThemeId);

            comboTheme.SelectedIndexChanged += ComboThemeOnSelectedIndexChanged;

            // syntax combo
            cbSyntax.DataSource = Style.GetThemesList().Select(theme => theme.Name).ToList();
            cbSyntax.SelectedIndex = Config.Instance.SyntaxHighlightThemeId;

            cbSyntax.SelectedIndexChanged += CbSyntaxSelectedIndexChanged;
        }

        /// <summary>
        /// Changing theme
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="eventArgs"></param>
        private void ComboThemeOnSelectedIndexChanged(object sender, EventArgs eventArgs) {
            try {
                ThemeManager.Current = ThemeManager.GetThemesList()[comboTheme.SelectedIndex];
                if (!ThemeManager.Current.UseCurrentAccentColor)
                    _checkButton.Checked = false;
            } catch (Exception x) {
                ErrorHandler.DirtyLog(x);
            } finally {
                Config.Instance.ThemeId = ThemeManager.Current.UniqueId;
                PlsRefresh();
            }
            
        }

        /// <summary>
        /// Changing syntax theme
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="eventArgs"></param>
        private void CbSyntaxSelectedIndexChanged(object sender, EventArgs eventArgs) {
            try {
                Style.CurrentTheme = Style.GetThemesList()[cbSyntax.SelectedIndex];
            } catch (Exception x) {
                ErrorHandler.DirtyLog(x);
            } finally {
                Config.Instance.SyntaxHighlightThemeId = cbSyntax.SelectedIndex;
                if (Plug.IsCurrentFileProgress)
                    Style.SetSyntaxStyles();
            }
        }

        /// <summary>
        /// Changing accent Color
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="eventArgs"></param>
        private void NewColorPickerOnCheckedChanged(object sender, EventArgs eventArgs) {
            YamuiColorRadioButton rb = sender as YamuiColorRadioButton;
            if (rb != null && rb.Checked) {
                YamuiThemeManager.AccentColor = rb.BackColor;
                _checkButton = rb;
                Config.Instance.AccentColor = YamuiThemeManager.AccentColor;
                PlsRefresh();
            }
        }

        /// <summary>
        /// force all the html panel/label to refresh and try to refresh the main window
        /// </summary>
        private void PlsRefresh() {
            var thisForm = FindForm();
            if (thisForm == null || Appli.Form == null)
                return;

            Style.SetSyntaxStyles();
            Style.SetGeneralStyles();

            // Refresh panels and labels (html)
            LocalHtmlHandler.ProvideCssSheet();

            // force the autocomplete to redraw
            AutoComplete.ForceClose();

            // force the dockable to redraw
            CodeExplorer.CodeExplorer.ApplyColorSettings();
            FileExplorer.FileExplorer.ApplyColorSettings();

            Application.DoEvents();
            thisForm.Invalidate();
            Application.DoEvents();
            thisForm.Update();
            Application.DoEvents();
            thisForm.Refresh();

            Appli.Form.UpdateTitle();

            // file tags
            FileTag.ForceClose();

        }
    }
}
