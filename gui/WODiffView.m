//
// WODiffView.m
// gdiff
//
// Created by Wincent Colaiuta on 25 September 2007.
// Copyright 2007 Wincent Colaiuta.

// class header
#import "WODiffView.h"

// other project headers
#import "WOGlueView.h"

@implementation WODiffView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)drawRect:(NSRect)rect {
    // Drawing code here.
}

- (void)resizeSubviewsWithOldSize:(NSSize)oldBoundsSize
{
    NSArray     *subviews       = [self subviews];
    NSView      *leftView       = [subviews objectAtIndex:0];
    NSRect      leftFrame       = [leftView frame];
    WOGlueView  *glueView       = [subviews objectAtIndex:1];
    NSRect      glueFrame       = [glueView frame];
    NSView      *rightView      = [subviews objectAtIndex:2];
    NSRect      rightFrame      = [rightView frame];
    NSSize      newBoundsSize   = [self bounds].size;
    CGFloat     scrollerWidth   = [NSScroller scrollerWidth];
    CGFloat     fileViewWidth   = floorf((newBoundsSize.width - (2 * WO_GUTTER_WIDTH) - WO_GLUE_WIDTH - scrollerWidth) / 2);

    // pass through height changes unadjusted
    leftFrame.size.height       = newBoundsSize.height;
    glueFrame.size.height       = newBoundsSize.height;
    rightFrame.size.height      = newBoundsSize.height;

    // to ensure correct pixel layout recalculate the horizontal placement every time
    leftFrame.origin.x          = 0.0;
    leftFrame.size.width        = WO_GUTTER_WIDTH + fileViewWidth;
    glueFrame.origin.x          = WO_GUTTER_WIDTH + fileViewWidth;
    glueFrame.size.width        = WO_GLUE_WIDTH;
    rightFrame.origin.x         = WO_GUTTER_WIDTH + fileViewWidth + WO_GLUE_WIDTH;
    rightFrame.size.width       = fileViewWidth + WO_GUTTER_WIDTH + scrollerWidth;

    // let right view pick up slack (when width is an odd number, the division by 2 above causes us to lose a pixel)
    CGFloat slack               = newBoundsSize.width - (leftFrame.size.width + WO_GLUE_WIDTH + rightFrame.size.width);
    rightFrame.size.width       += slack;

    // apply changes
    [leftView setFrame:leftFrame];
    [glueView setFrame:glueFrame];
    [rightView setFrame:rightFrame];
}

@end
