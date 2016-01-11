﻿#region Header
// // ========================================================================
// // Copyright (c) 2015 - Julien Caillon (julien.caillon@gmail.com)
// // This file (ImageGetter.cs) is part of YamuiFramework.
// 
// // YamuiFramework is a free software: you can redistribute it and/or modify
// // it under the terms of the GNU General Public License as published by
// // the Free Software Foundation, either version 3 of the License, or
// // (at your option) any later version.
// 
// // YamuiFramework is distributed in the hope that it will be useful,
// // but WITHOUT ANY WARRANTY; without even the implied warranty of
// // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// // GNU General Public License for more details.
// 
// // You should have received a copy of the GNU General Public License
// // along with YamuiFramework. If not, see <http://www.gnu.org/licenses/>.
// // ========================================================================
#endregion
using System.Drawing;

namespace YamuiFramework.Resources {

    internal class ImageGetter {

        private static ImageGetter _instance;

        public static ImageGetter GetInstance() {
            return _instance ?? (_instance = new ImageGetter());
        }

        public Image Get(string filename) {
            return (Image)Resources.ResourceManager.GetObject(filename);
        }
    }
}
