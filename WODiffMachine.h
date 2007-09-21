//
// WODiffMachine.h
// gdiff
//
// Created by Wincent Colaiuta on 21 September 2007.
// Copyright 2007 Wincent Colaiuta.

#import <Cocoa/Cocoa.h>

@class WODiff;

//! Thin Objective-C wrapper for a Ragel-generated state machine that parses the output of "git diff".
@interface WODiffMachine : NSObject {
    
    char *location_pointer;
    char *length_pointer;
    
    unsigned from_file_chunk_start;
    unsigned from_file_chunk_end;
    unsigned to_file_chunk_start;
    unsigned to_file_chunk_end;

}

//! Convenience method for returning a new WODiffMachine instance.
+ (WODiffMachine *)diffMachine;

//! Returns nil on failure.
- (WODiff *)parseDiffData:(NSData *)inData;

@end
