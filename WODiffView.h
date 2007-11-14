//
// WODiffView.h
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

@class WOFile, WOFromFileView, WOGlueView, WOGutterView, WOToFileView;

//! Simple container class that sets up the subviews necessary for displaying side-by-side file comparisons.
//!
//! It also implements specialized resizing behaviour; Cocoa's built-in autoresizing behaviour can't provide what we're looking for here (gutter view, file view, glue view, file view, gutter view, scroller; where all horizontal pixels are utilized at all times and the two file views are the only horizontally-resizeable elements).
//!
@interface WODiffView : NSView {

    NSView              *leftView;
    WOGutterView        *leftGutterView;
    NSScrollView        *leftScrollView;
    WOFromFileView      *leftFileView;
    WOGlueView          *glueView;
    NSView              *rightView;
    NSScrollView        *rightScrollView;
    WOToFileView        *rightFileView;
    WOGutterView        *rightGutterView;
    NSScroller          *scroller;
    WOFile              *file;
}

#pragma mark -
#pragma mark Properties

//! The file represented by the receiver.
@property WOFile *file;

@end
