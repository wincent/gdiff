//
// gdiff.h
// gdiff
//
// Created by Wincent Colaiuta on 25 September 2007.
// Copyright 2007 Wincent Colaiuta.
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

//! \file gdiff.h
//! Project-wide macros

//! Width in pixels of separator borders drawn by WOGutterView and WOGlueView.
#define WO_BORDER_WIDTH     1.0

//! Width in pixels of the WOGutterView used for drawing line numbers.
#define WO_GUTTER_WIDTH     72.0

//! Width in pixels of the WOGlueView used for drawing bezier curves that link deletions on the left (the "from" file) with insertions on the right (the "to" file).
//! Note that this width is only advisory and may be rounded up if necessary in order to completely fill the window's horizontal space; this occurs when dividing up the space equally between the two file views results in an extra pixel of slack (whenever there are an odd number of pixels division by two will result in a remainder of one).
#define WO_GLUE_WIDTH       72.0

//! The absolute path to the <tt>ditto</tt> tool as a constant C string.
//! <tt>ditto</tt> is included in the base Mac OS X install.
#define WO_DITTO            "/usr/bin/ditto"

//! The path string used by Git to indicate a non-existent file (for example, the "from" version of a newly created file, or the "to" version of a deleted file).
#define WO_NONEXISTENT_FILE @"/dev/null"
