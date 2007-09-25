//
// WODiffMachine.h
// gdiff
//
// Created by Wincent Colaiuta on 21 September 2007.
// Copyright 2007 Wincent Colaiuta.

@class WOChange, WODiff, WOFile;

//! Thin Objective-C wrapper for a Ragel-generated state machine that parses the output of "git diff".
//! Any single instance should only be called from one thread; concurrent access by multiple threads is not supported.
@interface WODiffMachine : NSObject {

    //! The WODiff object currently under construction.
    WODiff          *diff;

    //! The WOFile object currently under construction.
    WOFile          *file;

    //! The WOChange object currently under construction.
    WOChange        *change;

    //! Used to mark the start of substring within the input buffer.
    //! Used when capturing simple ASCII strings such as unquoted paths and blob ids.
    char            *mark;

    //! Buffer used for temporary strings when capturing blob ids and paths.
    NSString        *buffer;

    //! The start boundary (line number of "from file") for the chunk being scanned.
    unsigned        from_file_chunk_start;

    //! The start boundary (line number of "to file") for the chunk being scanned.
    unsigned        to_file_chunk_start;

    //! The current line number within the "from file".
    unsigned        from_cursor;

    //! The current line number within the "to file".
    unsigned        to_cursor;

}

//! Convenience method for returning a new WODiffMachine instance.
+ (WODiffMachine *)diffMachine;

//! Returns nil on failure.
- (WODiff *)parseDiffData:(NSData *)inData;

@end
