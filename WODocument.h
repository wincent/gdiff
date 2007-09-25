//
// MyDocument.h
// gdiff
//
// Created by Wincent Colaiuta on 25 September 2007.
// Copyright 2007 Wincent Colaiuta.

@class WODiffView, WOFileView, WOGlueView, WOGutterView;

//! Controller.
@interface WODocument : NSDocument {

    IBOutlet WODiffView *diffView;
    WOGutterView        *leftGutterView;
    WOFileView          *leftFileView;
    WOGlueView          *glueView;
    WOGutterView        *rightGutterView;
    WOFileView          *rightFileView;
    NSScroller          *scroller;

}

@end
