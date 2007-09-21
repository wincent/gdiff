//
// WOChange.h
// gdiff
//
// Created by Wincent Colaiuta on 21/9/2007.
// Copyright 2007 Wincent Colaiuta.
// $Id$

#import <Cocoa/Cocoa.h>

@interface WOChange : NSObject {

    NSIndexSet *insertion;
    NSIndexSet *deletion;

}

//! Create a WOChange object which describes the insertion of a single line.
+ (WOChange *)changeWithInsertionAtLine:(unsigned)aLine;

//! Create a WOChange object which describes the insertion of 1 or more lines.
+ (WOChange *)changeWithInsertionAtLine:(unsigned)aLine withLength:(unsigned)aLength;

//! Create a WOChange object which describes the deletion of a single line.
+ (WOChange *)changeWithDeletionAtLine:(unsigned)aLine;

//! Create a WOChange object which describes the deletion of 1 or more lines.
+ (WOChange *)changeWithDeletionAtLine:(unsigned)aLine withLength:(unsigned)aLength;

//! Create a WOChange object which describes the deletion of one line and the insertion of another.
+ (WOChange *)changeWithDeletionAtLine:(unsigned)deletionLine andInsertionAtLine:(unsigned)otherLine;

//! Create a WOChange object which describes the deletion of 1 or more lines and the insertion of another.
+ (WOChange *)changeWithDeletionAtLine:(unsigned)deletionLine
                            withLength:(unsigned)deletionLength
                    andInsertionAtLine:(unsigned)insertionLine;

//! Create a WOChange object which describes the deletion of a single line and the insertion of 1 or more others.
+ (WOChange *)changeWithDeletionAtLine:(unsigned)deletionLine
                    andInsertionAtLine:(unsigned)insertionLine
                            withLength:(unsigned)insertionLength;

//! Create a WOChange object which describes the deletion of 1 or more lines and the insertion of 1 or more others.
+ (WOChange *)changeWithDeletionAtLine:(unsigned)deletionLine
                            withLength:(unsigned)insertionLength
                    andInsertionAtLine:(unsigned)insertionLine
                            withLength:(unsigned)insertionLength;

// TODO: some of these methods probably don't need to exist... will see which ones survive pruning

@end
