//
// WOFileView.m
// gdiff
//
// Created by Wincent Colaiuta on 25 September 2007.
// Copyright 2007 Wincent Colaiuta.

// class header
#import "WOFileView.h"

@implementation WOFileView

#pragma mark -
#pragma mark NSTextView overrides

- (id)initWithFrame:(NSRect)frameRect textContainer:(NSTextContainer *)aTextContainer
{
    if ((self = [super initWithFrame:frameRect textContainer:aTextContainer]))
    {
        // setting a really big container disables wrapping
        [aTextContainer setContainerSize:NSMakeSize(FLT_MAX, FLT_MAX)];
        [aTextContainer setWidthTracksTextView:NO];
        [aTextContainer setHeightTracksTextView:NO];

        // view setup
        [self setFont:[NSFont userFixedPitchFontOfSize:0.0]];
        [self setEditable:NO];
        [self setHorizontallyResizable:YES];
        [self setVerticallyResizable:YES];
        [self setAutoresizingMask:NSViewNotSizable];
    }
    return self;
}

- (void)drawViewBackgroundInRect:(NSRect)rect
{
    // TODO: still to decide whether to perform highlighting here or in drawRect:
    [super drawViewBackgroundInRect:rect];
}


#pragma mark -
#pragma mark NSView overrides

- (void)drawRect:(NSRect)rect
{
    // TODO: still to decide whether to perform highlighting here or in drawViewBackgroundInRect:
    [super drawRect:rect];
}

#pragma mark -
#pragma mark Properties

- (void)setText:(NSString *)aText
{
    if (aText != text)
    {
        text = aText;
        if (text)
            // temporary: for demo purposes only
            [[self textStorage] setAttributedString:[[NSAttributedString alloc] initWithString:text]];
    }
}

@synthesize text;
@synthesize changes;

@end
