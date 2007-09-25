//
// WOChange.h
// gdiff
//
// Created by Wincent Colaiuta on 21 September 2007.
// Copyright 2007 Wincent Colaiuta.

//! Models a single change between the "from file" and the "to file".
//! A change may either be:
//!
//!     - a deletion of 1 or more contiguous lines
//!     - an insertion of 1 or more contiguous lines
//!     - both of the above
//!
@interface WOChange : NSObject {

    NSRange deletedRange;
    NSRange insertedRange;

}

//! Create a WOChange object which describes the deletion of a single line at \p Line.
+ (WOChange *)changeWithDeletionAtLine:(unsigned)aLine;

//! Create a WOChange object which describes the insertion of a single line at \p Line.
+ (WOChange *)changeWithInsertionAtLine:(unsigned)aLine;

//! Modify an existing WOChange instance, recording an additional deletion at \p aLine.
//! \exception NSInternalInconsistencyException thrown if the addition would result in a non-contiguous range.
- (void)addDeletionAtLine:(unsigned)aLine;

//! Modify an existing WOChange instance, recording an additional insertion at \p aLine.
//! \exception NSInternalInconsistencyException thrown if the addition would result in a non-contiguous range.
- (void)addInsertionAtLine:(unsigned)aLine;

#pragma mark -
#pragma mark Properties

//! Returns YES if the receiver has a deletion component.
@property(readonly) BOOL    hasDeletion;

//! Returns YES if the receiver has an insertion component.
@property(readonly) BOOL    hasInsertion;

@property(readonly) NSRange deletedRange;

@property(readonly) NSRange insertedRange;

@end
