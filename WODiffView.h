//
// WODiffView.h
// gdiff
//
// Created by Wincent Colaiuta on 25 September 2007.
// Copyright 2007 Wincent Colaiuta.

//! Simple container class that implements the desired resizing behaviour for subviews. Cocoa's built-in autoresizing behaviour can't provide what we're looking for here (gutter view, file view, glue view, file view, gutter view, scroller; where all horizontal pixels are utilized at all times and the two file views are the only horizontally-resizeable elements).
@interface WODiffView : NSView {

}

@end
