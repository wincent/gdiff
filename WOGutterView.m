//
// WOGutterView.m
// gdiff
//
// Created by Wincent Colaiuta on 25 September 2007.
// Copyright 2007 Wincent Colaiuta.

// class header
#import "WOGutterView.h"

#define WO_BORDER_WIDTH 1.0

@implementation WOGutterView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)rect
{
    NSRect bounds   = [self bounds];

    // draw left border if required
    if (borderMask & WOLeftBorder)
    {
        NSRect leftBorder = NSMakeRect(0.0, 0.0, WO_BORDER_WIDTH, bounds.size.height);
        NSRect draw = NSIntersectionRect(leftBorder, rect);
        if (!NSIsEmptyRect(draw))
        {
            [[NSColor lightGrayColor] set];
            NSRectFill(draw);
        }
    }

    // draw right border if required
    if (borderMask & WORightBorder)
    {
        NSRect rightBorder = NSMakeRect(bounds.size.width - WO_BORDER_WIDTH, 0.0, WO_BORDER_WIDTH, bounds.size.height);
        NSRect draw = NSIntersectionRect(rightBorder, rect);
        if (!NSIsEmptyRect(draw))
        {
            [[NSColor lightGrayColor] set];
            NSRectFill(draw);
        }
    }

    // draw line numbers
}

#pragma mark -
#pragma mark Properties

@synthesize borderMask;

@end
