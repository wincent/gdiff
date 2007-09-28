//
// WODiffView.m
// gdiff
//
// Created by Wincent Colaiuta on 25 September 2007.
// Copyright 2007 Wincent Colaiuta.

// class header
#import "WODiffView.h"

// other project class headers
#import "WOGlueView.h"

// other project headers
#import "gdiff.h"

@implementation WODiffView

#pragma mark -
#pragma mark NSView overrides

- (id)initWithFrame:(NSRect)frameRect
{
    if ((self = [super initWithFrame:frameRect]))
        NSLog(@"called");
    return self;
}

- (void)resizeSubviewsWithOldSize:(NSSize)oldBoundsSize
{
    NSArray         *subviews       = [self subviews];
    NSScrollView    *leftView       = [subviews objectAtIndex:0];
    NSRect          leftFrame       = [leftView frame];
    WOGlueView      *glueView       = [subviews objectAtIndex:1];
    NSRect          glueFrame       = [glueView frame];
    NSScrollView    *rightView      = [subviews objectAtIndex:2];
    NSRect          rightFrame      = [rightView frame];
    NSScroller      *scroller       = [subviews objectAtIndex:3];
    NSRect          scrollerFrame   = [scroller frame];
    NSSize          newBoundsSize   = [self bounds].size;
    CGFloat         scrollerWidth   = [NSScroller scrollerWidth];
    CGFloat         fileViewWidth   = floorf((newBoundsSize.width - (2 * WO_GUTTER_WIDTH) - WO_GLUE_WIDTH - scrollerWidth) / 2);

    // pass through height changes unadjusted
    leftFrame.size.height       = newBoundsSize.height;
    glueFrame.size.height       = newBoundsSize.height;
    rightFrame.size.height      = newBoundsSize.height;
    scrollerFrame.size.height   = newBoundsSize.height;

    // to ensure correct pixel layout recalculate the horizontal placement every time
    leftFrame.origin.x          = 0.0;
    leftFrame.size.width        = WO_GUTTER_WIDTH + fileViewWidth;
    rightFrame.size.width       = fileViewWidth + WO_GUTTER_WIDTH;

    // let glue view pick up slack (when width is an odd number, the division by 2 above causes us to lose a pixel)
    CGFloat slack = newBoundsSize.width - (leftFrame.size.width + WO_GLUE_WIDTH + rightFrame.size.width + scrollerWidth);
    glueFrame.origin.x          = leftFrame.size.width;
    glueFrame.size.width        = WO_GLUE_WIDTH + slack;
    rightFrame.origin.x         = glueFrame.origin.x + glueFrame.size.width;
    scrollerFrame.origin.x      = rightFrame.origin.x + rightFrame.size.width;

    // apply changes
    [leftView setFrame:leftFrame];
    [glueView setFrame:glueFrame];
    [rightView setFrame:rightFrame];
    [scroller setFrame:scrollerFrame];
}

@end
