//
// WOChange.h
// gdiff
//
// Created by Wincent Colaiuta on 21 September 2007.
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
