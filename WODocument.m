//
// MyDocument.m
// gdiff
//
// Created by Wincent Colaiuta on 25 September 2007.
// Copyright 2007 Wincent Colaiuta.
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

// class header
#import "WODocument.h"

// other project class headers
#import "WODiff.h"
#import "WODiffMachine.h"
#import "WODiffView.h"
#import "WOFile.h"

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
    if ((self= [super init]))
    {
    }
    return self;
}

#pragma mark -
#pragma mark NSDocument overrides

- (NSString *)windowNibName
{
    return @"Document";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];

    // for testing only: load sample files
    NSString *tmp = [NSHomeDirectory() stringByAppendingPathComponent:@"tmp"];
    NSData *diffData = [NSData dataWithContentsOfFile:[tmp stringByAppendingPathComponent:@"sample.diff"]];
    NSAssert(diffData != nil, @"failed to read sample.diff");
    NSString *from = [NSString stringWithContentsOfFile:[tmp stringByAppendingPathComponent:@"sample.from"]
                                               encoding:NSUTF8StringEncoding
                                                  error:NULL];
    NSAssert(from != nil, @"failed to read sample.from");
    NSString *to = [NSString stringWithContentsOfFile:[tmp stringByAppendingPathComponent:@"sample.to"]
                                             encoding:NSUTF8StringEncoding
                                                error:NULL];
    NSAssert(to != nil, @"failed to read sample.to");

    // initialize models with contents of sample files
    WODiffMachine *machine = [WODiffMachine diffMachine];
    WODiff *diff = [machine parseDiffData:diffData];
    NSAssert(diff != nil, @"failed to parse sample data");

    // initialize view with content: final code will use bindings for this
    WOFile *file    = [[diff files] objectAtIndex:0];
    file.fromBlob   = from;
    file.toBlob     = to;
    diffView.file   = file;
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
