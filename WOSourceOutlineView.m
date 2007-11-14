//
// WOSourceOutlineView.h
// gdiff
//
// Created by Wincent Colaiuta on 2 October 2007.
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
#import "WOSourceOutlineView.h"

// other project headers
#import "gdiff.h"

@implementation WOSourceOutlineView

#pragma mark NSCoding protocol

// as this class is only instantiated from the nib, no need to implement initWithFrame:, only initWithCoder:
- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super initWithCoder:decoder]))
        [self setSelectionHighlightStyle:NSTableViewSelectionHighlightStyleSourceList];
    return self;
}

#pragma mark -
#pragma mark NSView overrides

- (void)drawRect:(NSRect)rect
{
    [super drawRect:rect];

    // draw top border
    NSRect  bounds          = [self bounds];
    NSColor *borderColor    = nil;
    NSRect  border          = NSMakeRect(0.0, bounds.size.height - WO_BORDER_WIDTH, bounds.size.width, WO_BORDER_WIDTH);
    NSRect  draw            = NSIntersectionRect(border, rect);
    if (!NSIsEmptyRect(draw))
    {
        borderColor = [NSColor lightGrayColor];
        [borderColor set];
        NSRectFill(draw);
    }

    // draw bottom border
    border  = NSMakeRect(0.0, 0.0, bounds.size.width, WO_BORDER_WIDTH);
    draw    = NSIntersectionRect(border, rect);
    if (!NSIsEmptyRect(draw))
    {
        // border color is most likely already set
        if (!borderColor)
            [[NSColor lightGrayColor] set];
        NSRectFill(draw);
    }
}

@end
