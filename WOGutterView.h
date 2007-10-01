//
// WOGutterView.h
// gdiff
//
// Created by Wincent Colaiuta on 25 September 2007.
// Copyright 2007 Wincent Colaiuta.

enum {
    WOLeftBorderMask    = 0,
    WORightBorderMask   = 1
};
enum {
    WONoBorder    = 0,
    WOLeftBorder  = 1 << WOLeftBorderMask,
    WORightBorder = 1 << WORightBorderMask
};
typedef NSInteger WOBorderType;

@interface WOGutterView : NSView {

    WOBorderType    borderMask;

}

#pragma mark -
#pragma mark Properties

@property WOBorderType borderMask;

@end
