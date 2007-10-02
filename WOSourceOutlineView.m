//
// WOSourceOutlineView.h
// gdiff
//
// Created by Wincent Colaiuta on 2 October 2007.
// Copyright 2007 Wincent Colaiuta.

// class header
#import "WOSourceOutlineView.h"

// other project headers
#import "gdiff.h"

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
    [super drawRect:rect];

    // draw top border
    NSRect  bounds          = [self bounds];
    NSColor *borderColor    = nil;
    NSRect  border          = NSMakeRect(0.0, bounds.size.height - WO_BORDER_WIDTH, bounds.size.width, WO_BORDER_WIDTH);
    NSRect  draw            = NSIntersectionRect(border, rect);
    if (!NSIsEmptyRect(draw))
    {
        borderColor = [NSColor lightGrayColor];
        [borderColor set];
        NSRectFill(draw);
    }

    // draw bottom border
    border  = NSMakeRect(0.0, 0.0, bounds.size.width, WO_BORDER_WIDTH);
    draw    = NSIntersectionRect(border, rect);
    if (!NSIsEmptyRect(draw))
    {
        // border color is most likely already set
        if (!borderColor)
            [[NSColor lightGrayColor] set];
        NSRectFill(draw);
    }
}

@end
