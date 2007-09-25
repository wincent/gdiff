//
// MyDocument.m
// gdiff
//
// Created by Wincent Colaiuta on 25 September 2007.
// Copyright 2007 Wincent Colaiuta.

// class header
#import "WODocument.h"

// other project class headers
#import "WODiffView.h"
#import "WOFileView.h"
#import "WOGlueView.h"
#import "WOGutterView.h"

// other project headers
#import "gdiff.h"

@interface WODocument ()

// used to scroll up or down by lines or pages (called when clicking scroller arrows or in the blank space outside of the knob)
- (void)scrollByLines:(int)delta;

// used to scroll to a specific point (called when dragging the scroll knob)
- (void)scrollToValue:(float)aValue;

// returns the number of currently visible lines; used when scrolling "by page"
- (int)visibleLineCount;

@end

@implementation WODocument

#pragma mark -
#pragma mark NSObject overrides

- (id)init
{
    self = [super init];
    if (self) {
    
        // Add your subclass-specific initialization here.
        // If an error occurs here, send a [self release] message and return nil.
    
    }
    return self;
}

#pragma mark -
#pragma mark NSDocument overrides

- (NSString *)windowNibName
{
    return @"Document";
}

- (void)windowControllerDidLoadNib:(NSWindowController *) aController
{
    [super windowControllerDidLoadNib:aController];

    // build subviews from left (0.0) to right; all maximum height
    NSRect  bounds          = [diffView bounds];
    CGFloat x               = 0.0;
    CGFloat y               = 0.0;
    CGFloat height          = bounds.size.height;
    CGFloat scrollerWidth   = [NSScroller scrollerWidth];
    CGFloat fileViewWidth   = floorf((bounds.size.width - (2 * WO_GUTTER_WIDTH) - WO_GLUE_WIDTH - scrollerWidth) / 2);

    // on the left side we group together gutter and file views
    NSView *leftView = [[NSView alloc] initWithFrame:NSMakeRect(x, y, WO_GUTTER_WIDTH + fileViewWidth, height)];
    [diffView addSubview:leftView];

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

    // add WOGlueView (middle) for merge arrows
    glueView = [[WOGlueView alloc] initWithFrame:NSMakeRect(x, y, WO_GLUE_WIDTH, height)];
    [diffView addSubview:glueView];
    x += WO_GLUE_WIDTH;

    // will let right view pick up any slack (when width is an odd number, the division by 2 causes us to lose a pixel)
    CGFloat slack = bounds.size.width - (fileViewWidth * 2 + WO_GUTTER_WIDTH * 2 + WO_GLUE_WIDTH + scrollerWidth);

    // on the right side group together gutter, file and scroller views
    NSView *rightView = [[NSView alloc] initWithFrame:NSMakeRect(x, y, fileViewWidth + slack + WO_GUTTER_WIDTH + scrollerWidth, height)];
    [diffView addSubview:rightView];
    x = 0.0;

    // add another WOFileView (right) for "to" file
    rightFileView = [[WOFileView alloc] initWithFrame:NSMakeRect(x, y, fileViewWidth + slack, height)];
    [rightFileView setAutoresizingMask:NSViewWidthSizable | NSViewHeightSizable];
    [rightView addSubview:rightFileView];
    x += (fileViewWidth + slack);

    // add WOGutterView (farther right) for line numbers
    rightGutterView = [[WOGutterView alloc] initWithFrame:NSMakeRect(x, y, WO_GUTTER_WIDTH, height)];
    [rightGutterView setAutoresizingMask:NSViewHeightSizable | NSViewMinXMargin];
    [rightView addSubview:rightGutterView];
    x += WO_GUTTER_WIDTH;

    // add NSScroller (far right)
    scroller = [[NSScroller alloc] initWithFrame:NSMakeRect(x, y, scrollerWidth, height)];
    [scroller setAutoresizingMask:NSViewHeightSizable | NSViewMinXMargin];
    [scroller setTarget:self];
    [scroller setAction:@selector(scroll:)];
    [rightView addSubview:scroller];
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to write your document to data of the specified type. If the given outError != NULL, ensure that you set *outError when returning nil.

    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.

    // For applications targeted for Panther or earlier systems, you should use the deprecated API -dataRepresentationOfType:. In this case you can also choose to override -fileWrapperRepresentationOfType: or -writeToFile:ofType: instead.

    if ( outError != NULL ) {
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
	}
	return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to read your document from the given data of the specified type.  If the given outError != NULL, ensure that you set *outError when returning NO.

    // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead. 
    
    // For applications targeted for Panther or earlier systems, you should use the deprecated API -loadDataRepresentation:ofType. In this case you can also choose to override -readFromFile:ofType: or -loadFileWrapperRepresentation:ofType: instead.
    
    if ( outError != NULL ) {
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
	}
    return YES;
}

#pragma mark -
#pragma mark Scroller management

// called whenever use clicks in scroller
- (void)scroll:(id)sender
{
    NSScrollerPart hitPart = [sender hitPart];
    switch (hitPart)
    {
        case NSScrollerNoPart:
            break;
        case NSScrollerIncrementPage:
            [self scrollByLines:[self visibleLineCount]];   break;
        case NSScrollerDecrementPage:
            [self scrollByLines:-[self visibleLineCount]];  break;
        case NSScrollerDecrementLine:
            [self scrollByLines:-1];                        break;
        case NSScrollerIncrementLine:
            [self scrollByLines:1];                         break;
        case NSScrollerKnob:
        case NSScrollerKnobSlot:
            [self scrollToValue:[sender floatValue]];       break;
        default:
            // could get here in future version of operating system
            NSLog(@"warning: scroller %@ returned unknown hitPart %d", sender, hitPart);
    }
}

- (void)scrollByLines:(int)delta
{
    // check limits
}

- (void)scrollToValue:(float)aValue
{

}

- (int)visibleLineCount
{
    return 0;
}

@end