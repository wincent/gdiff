//
// WODiffView.m
// gdiff
//
// Created by Wincent Colaiuta on 25 September 2007.
// Copyright 2007 Wincent Colaiuta.

// class header
#import "WODiffView.h"

// other project class headers
#import "WOFromFileView.h"
#import "WOGlueView.h"
#import "WOGutterView.h"
#import "WOToFileView.h"

// other project headers
#import "gdiff.h"

@implementation WODiffView

#pragma mark -
#pragma mark NSView overrides

- (id)initWithFrame:(NSRect)frameRect
{
    if ((self = [super initWithFrame:frameRect]))
    {
        // build subviews from left (0.0) to right; all maximum height (allowing room for top and bottom borders)
        NSRect  bounds          = [self bounds];
        CGFloat x               = 0.0;
        CGFloat y               = WO_BORDER_WIDTH;
        CGFloat height          = bounds.size.height - (2 * WO_BORDER_WIDTH);
        CGFloat scrollerWidth   = [NSScroller scrollerWidth];
        CGFloat fileViewWidth   = floorf((bounds.size.width - (2 * WO_GUTTER_WIDTH) - WO_GLUE_WIDTH - scrollerWidth) / 2);

        // on the left side we group together gutter and file views
        leftView = [[NSView alloc] initWithFrame:NSMakeRect(x, y, WO_GUTTER_WIDTH + fileViewWidth, height)];
        [leftView setAutoresizingMask:NSViewHeightSizable | NSViewWidthSizable];
        [self addSubview:leftView];

        // add WOGutterView (far left) for line numbers
        leftGutterView = [[WOGutterView alloc] initWithFrame:NSMakeRect(x, 0.0, WO_GUTTER_WIDTH, height)];
        [leftGutterView setAutoresizingMask:NSViewHeightSizable | NSViewMaxXMargin];
        [leftGutterView setBorderMask:WORightBorder];
        [leftView addSubview:leftGutterView];
        x += WO_GUTTER_WIDTH;

        // scroll view for left side
        leftScrollView = [[NSScrollView alloc] initWithFrame:NSMakeRect(x, 0.0, fileViewWidth, height)];
        [leftScrollView setHasHorizontalScroller:YES];
        [leftScrollView setAutohidesScrollers:YES];
        [leftScrollView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
        [leftView addSubview:leftScrollView];

        // add WOFileView (left) for "from" file
        leftFileView = [[WOFromFileView alloc] initWithFrame:NSMakeRect(x, 0.0, fileViewWidth, height)];
        [leftFileView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
        [leftScrollView setDocumentView:leftFileView];
        x += fileViewWidth;

        // will let glue view pick up any slack (when width is an odd number, the division by 2 causes us to lose a pixel)
        CGFloat slack = bounds.size.width - (fileViewWidth * 2 + WO_GUTTER_WIDTH * 2 + WO_GLUE_WIDTH + scrollerWidth);

        // add WOGlueView (middle) for merge arrows
        glueView = [[WOGlueView alloc] initWithFrame:NSMakeRect(x, y, WO_GLUE_WIDTH + slack, height)];
        [self addSubview:glueView];
        x += (WO_GLUE_WIDTH + slack);

        // on the right side group together file and gutter views
        rightView = [[NSView alloc] initWithFrame:NSMakeRect(x, y, fileViewWidth + WO_GUTTER_WIDTH, height)];
        [rightView setAutoresizingMask:NSViewHeightSizable | NSViewWidthSizable];
        [self addSubview:rightView];
        x = 0.0;

        // scroll view for right side
        rightScrollView = [[NSScrollView alloc] initWithFrame:NSMakeRect(x, 0.0, fileViewWidth, height)];
        [rightScrollView setHasHorizontalScroller:YES];
        [rightScrollView setAutohidesScrollers:YES];
        [rightScrollView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
        [rightView addSubview:rightScrollView];

        // add another WOFileView (right) for "to" file
        rightFileView = [[WOToFileView alloc] initWithFrame:NSMakeRect(x, 0.0, fileViewWidth, height)];
        [rightFileView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
        [rightScrollView setDocumentView:rightFileView];
        x += fileViewWidth;

        // add WOGutterView (farther right) for line numbers
        rightGutterView = [[WOGutterView alloc] initWithFrame:NSMakeRect(x, 0.0, WO_GUTTER_WIDTH, height)];
        [rightGutterView setAutoresizingMask:NSViewHeightSizable | NSViewMinXMargin];
        [rightGutterView setBorderMask:WOLeftBorder];
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

- (void)drawRect:(NSRect)aRect
{
    NSRect  bounds          = [self bounds];
    NSColor *borderColor    = nil;

    // draw top border
    NSRect border = NSMakeRect(0.0, bounds.size.height - WO_BORDER_WIDTH, bounds.size.width, WO_BORDER_WIDTH);
    NSRect draw = NSIntersectionRect(border, aRect);
    if (!NSIsEmptyRect(draw))
    {
        borderColor = [NSColor lightGrayColor];
        [borderColor set];
        NSRectFill(draw);
    }

    // draw bottom border
    border = NSMakeRect(0.0, 0.0, bounds.size.width, WO_BORDER_WIDTH);
    draw = NSIntersectionRect(border, aRect);
    if (!NSIsEmptyRect(draw))
    {
        // border color most likely is already set
        if (!borderColor)
            [[NSColor lightGrayColor] set];
        NSRectFill(draw);
    }

    // let super handle subviews
    [super drawRect:aRect];
}

- (void)resizeSubviewsWithOldSize:(NSSize)oldBoundsSize
{
    NSRect          leftFrame       = [leftView frame];
    NSRect          glueFrame       = [glueView frame];
    NSRect          rightFrame      = [rightView frame];
    NSRect          scrollerFrame   = [scroller frame];
    NSSize          newBoundsSize   = [self bounds].size;
    CGFloat         scrollerWidth   = [NSScroller scrollerWidth];
    CGFloat         fileViewWidth   = floorf((newBoundsSize.width - (2 * WO_GUTTER_WIDTH) - WO_GLUE_WIDTH - scrollerWidth) / 2);

    // pass through height changes unadjusted
    leftFrame.size.height       = newBoundsSize.height - (WO_BORDER_WIDTH * 2);
    leftFrame.origin.y          = WO_BORDER_WIDTH;
    glueFrame.size.height       = newBoundsSize.height - (WO_BORDER_WIDTH * 2);
    glueFrame.origin.y          = WO_BORDER_WIDTH;
    rightFrame.size.height      = newBoundsSize.height - (WO_BORDER_WIDTH * 2);
    rightFrame.origin.y         = WO_BORDER_WIDTH;
    scrollerFrame.size.height   = newBoundsSize.height - (WO_BORDER_WIDTH * 2);
    scrollerFrame.origin.y      = WO_BORDER_WIDTH;

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

#pragma mark -
#pragma mark Properties

@synthesize file;

@end
