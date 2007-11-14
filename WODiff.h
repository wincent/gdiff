//
// WODiff.h
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

@class WOFile;

@interface WODiff : NSObject {

    //! An array of WOFile objects.
    NSMutableArray *files;

}

//! Convenience method which returns a new WODiff instance.
+ (WODiff *)diff;

//! \exception NSInternalInconsistencyException thrown if \p aFile is nil.
- (void)appendFile:(WOFile *)aFile;

#pragma mark -
#pragma mark Properties

@property(readonly) NSArray *files;

@end
