//
// MyDocument.h
// gdiff
//
// Created by Wincent Colaiuta on 25 September 2007.
// Copyright 2007 Wincent Colaiuta.

@class WODiffView;

//! Controller.
@interface WODocument : NSDocument {

    IBOutlet WODiffView *diffView;

}

@end
