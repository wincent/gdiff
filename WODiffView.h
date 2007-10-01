//
// WODiffView.h
// gdiff
//
// Created by Wincent Colaiuta on 25 September 2007.
// Copyright 2007 Wincent Colaiuta.

@class WOFromFileView, WOGlueView, WOGutterView, WOToFileView;

//! Simple container class that sets up the subviews necessary for displaying side-by-side file comparisons.
//!
//! It also implements specialized resizing behaviour; Cocoa's built-in autoresizing behaviour can't provide what we're looking for here (gutter view, file view, glue view, file view, gutter view, scroller; where all horizontal pixels are utilized at all times and the two file views are the only horizontally-resizeable elements).
//!
@interface WODiffView : NSView {

    NSScrollView        *leftScrollView;
    WOGutterView        *leftGutterView;
    WOFromFileView      *leftFileView;
    WOGlueView          *glueView;
    NSScrollView        *rightScrollView;
    WOGutterView        *rightGutterView;
    WOToFileView        *rightFileView;
    NSScroller          *scroller;

}

@end
