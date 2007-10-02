//
// WOSourceOutlineView.h
// gdiff
//
// Created by Wincent Colaiuta on 2 October 2007.
// Copyright 2007 Wincent Colaiuta.

// class header
#import "WOSourceOutlineView.h"

@implementation WOSourceOutlineView

#pragma mark NSCoding protocol

// as this class is only instantiated from the nib, no need to implement initWithFrame:, only initWithCoder:
- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super initWithCoder:decoder]))
        [self setSelectionHighlightStyle:NSTableViewSelectionHighlightStyleSourceList];
    return self;
}

#pragma mark -
#pragma mark NSView overrides

- (void)drawRect:(NSRect)rect
{
    // Drawing code here.
}

@end
