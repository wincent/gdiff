//
// WOGlueView.m
// gdiff
//
// Created by Wincent Colaiuta on 25 September 2007.
// Copyright 2007 Wincent Colaiuta.

// class header
#import "WOGlueView.h"

// other headers
#import "gdiff.h"

@implementation WOGlueView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)rect
{
    NSRect  bounds          = [self bounds];
    NSColor *borderColor    = nil;

    // draw left border
    NSRect border = NSMakeRect(0.0, 0.0, WO_BORDER_WIDTH, bounds.size.height);
    NSRect draw = NSIntersectionRect(border, rect);
    if (!NSIsEmptyRect(draw))
    {
        borderColor = [NSColor lightGrayColor];
        [borderColor set];
        NSRectFill(draw);
    }

    // draw right border
    border = NSMakeRect(bounds.size.width - WO_BORDER_WIDTH, 0.0, WO_BORDER_WIDTH, bounds.size.height);
    draw = NSIntersectionRect(border, rect);
    if (!NSIsEmptyRect(draw))
    {
        // border color most likely is already set
        if (!borderColor)
            [[NSColor lightGrayColor] set];
        NSRectFill(draw);
    }
}

@end
