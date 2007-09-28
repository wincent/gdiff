//
// WODiffView.m
// gdiff
//
// Created by Wincent Colaiuta on 25 September 2007.
// Copyright 2007 Wincent Colaiuta.

// class header
#import "WODiffView.h"

// other project class headers
#import "WOFileView.h"
#import "WOGlueView.h"
#import "WOGutterView.h"

// other project headers
#import "gdiff.h"

@implementation WODiffView

#pragma mark -
#pragma mark NSView overrides

- (id)initWithFrame:(NSRect)frameRect
{
    if ((self = [super initWithFrame:frameRect]))
    {
        // build subviews from left (0.0) to right; all maximum height
        NSRect  bounds          = [self bounds];
        CGFloat x               = 0.0;
        CGFloat y               = 0.0;
        CGFloat height          = bounds.size.height;
        CGFloat scrollerWidth   = [NSScroller scrollerWidth];
        CGFloat fileViewWidth   = floorf((bounds.size.width - (2 * WO_GUTTER_WIDTH) - WO_GLUE_WIDTH - scrollerWidth) / 2);

        // scroll view for left side
        leftScrollView = [[NSScrollView alloc] initWithFrame:NSMakeRect(x, y, WO_GUTTER_WIDTH + fileViewWidth, height)];
        [leftScrollView setHasHorizontalScroller:YES];
        [leftScrollView setAutohidesScrollers:YES];
        [self addSubview:leftScrollView];

        // on the left side we group together gutter and file views
        NSView *leftView = [[NSView alloc] initWithFrame:NSMakeRect(x, y, WO_GUTTER_WIDTH + fileViewWidth, height)];
        [leftView setAutoresizingMask:NSViewHeightSizable | NSViewWidthSizable];
        [leftScrollView setDocumentView:leftView];

        // add WOGutterView (far left) for line numbers
        leftGutterView = [[WOGutterView alloc] initWithFrame:NSMakeRect(x, y, WO_GUTTER_WIDTH, height)];
        [leftGutterView setAutoresizingMask:NSViewHeightSizable | NSViewMaxXMargin];
        [leftView addSubview:leftGutterView];
        x += WO_GUTTER_WIDTH;

        // add WOFileView (left) for "from" file
        leftFileView = [[WOFileView alloc] initWithFrame:NSMakeRect(x, y, fileViewWidth, height)];
        [leftFileView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
        [leftView addSubview:leftFileView];
        x += fileViewWidth;

        // will let glue view pick up any slack (when width is an odd number, the division by 2 causes us to lose a pixel)
        CGFloat slack = bounds.size.width - (fileViewWidth * 2 + WO_GUTTER_WIDTH * 2 + WO_GLUE_WIDTH + scrollerWidth);

        // add WOGlueView (middle) for merge arrows
        glueView = [[WOGlueView alloc] initWithFrame:NSMakeRect(x, y, WO_GLUE_WIDTH + slack, height)];
        [self addSubview:glueView];
        x += (WO_GLUE_WIDTH + slack);

        // scroll view for right side
        rightScrollView = [[NSScrollView alloc] initWithFrame:NSMakeRect(x, y, fileViewWidth + WO_GUTTER_WIDTH, height)];
        [rightScrollView setHasHorizontalScroller:YES];
        [rightScrollView setAutohidesScrollers:YES];
        [self addSubview:rightScrollView];

        // on the right side group together file and gutter views
        NSView *rightView = [[NSView alloc] initWithFrame:NSMakeRect(x, y, fileViewWidth + WO_GUTTER_WIDTH, height)];
        [rightView setAutoresizingMask:NSViewHeightSizable | NSViewWidthSizable];
        [rightScrollView setDocumentView:rightView];
        x = 0.0;

        // add another WOFileView (right) for "to" file
        rightFileView = [[WOFileView alloc] initWithFrame:NSMakeRect(x, y, fileViewWidth, height)];
        [rightFileView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
        [rightView addSubview:rightFileView];
        x += fileViewWidth;

        // add WOGutterView (farther right) for line numbers
        rightGutterView = [[WOGutterView alloc] initWithFrame:NSMakeRect(x, y, WO_GUTTER_WIDTH, height)];
        [rightGutterView setAutoresizingMask:NSViewHeightSizable | NSViewMinXMargin];
        [rightView addSubview:rightGutterView];
        x += WO_GUTTER_WIDTH;

        // add NSScroller (far right)
        NSRect scrollerRect = NSMakeRect(WO_GUTTER_WIDTH + fileViewWidth + WO_GLUE_WIDTH + slack + x , y, scrollerWidth, height);
        scroller = [[NSScroller alloc] initWithFrame:scrollerRect];
        [scroller setAutoresizingMask:NSViewHeightSizable | NSViewMinXMargin];
        [scroller setTarget:self];
        [scroller setAction:@selector(scroll:)];
        [self addSubview:scroller];
    }
    return self;
}

- (void)resizeSubviewsWithOldSize:(NSSize)oldBoundsSize
{
    NSRect          leftFrame       = [leftScrollView frame];
    NSRect          glueFrame       = [glueView frame];
    NSRect          rightFrame      = [rightScrollView frame];
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
    [leftScrollView setFrame:leftFrame];
    [glueView setFrame:glueFrame];
    [rightScrollView setFrame:rightFrame];
    [scroller setFrame:scrollerFrame];
}

@end
