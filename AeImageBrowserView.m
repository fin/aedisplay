//
//  AeImageBrowser.m
//  aethertest3
//
//  Created by fin on 6/21/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "AeImageBrowserView.h"
#import "MyImage.h"


@implementation AeImageBrowserView

- (void)keyDown:(NSEvent *)theEvent {
    NSString *theArrow = [theEvent charactersIgnoringModifiers];
    if ([theEvent modifierFlags] & (NSShiftKeyMask)) {
        [super keyDown:theEvent];
        return;
    }
    if ( [theArrow length] == 1 ) {
        if ( [theArrow characterAtIndex:0] == NSDownArrowFunctionKey ) {
            int index = [[self selectionIndexes] firstIndex];
            if(index<0)
                return;
            MyImage *m = [[[self dataSource] mImages] objectAtIndex: index];
            MyImage *m2 = [m copy];
            [m2 setState:0];
            [[[self dataSource] mImages] removeObject: m];
            [[[self dataSource] mImages] insertObject: m2 atIndex:index];
            [self setSelectionIndexes:[[NSIndexSet alloc] initWithIndex:index] byExtendingSelection:FALSE];

            [self reloadData];
            return;
        }
        if ( [theArrow characterAtIndex:0] == NSUpArrowFunctionKey ) {
            int index = [[self selectionIndexes] firstIndex];
            if(index<0)
                return;
            MyImage *m = [[[self dataSource] mImages] objectAtIndex: index];
            MyImage *m2 = [m copy];
            [m2 setState:1];
            [[[self dataSource] mImages] removeObject: m];
            [[[self dataSource] mImages] insertObject: m2 atIndex:index];
            [self setSelectionIndexes:[[NSIndexSet alloc] initWithIndex:index] byExtendingSelection:FALSE];
            [[self dataSource] imageBrowserSelectionDidChange:self];
            [self reloadData];

            return;
        }
        if( [theArrow characterAtIndex:0] == NSLeftArrowFunctionKey) {
            int index = [[self selectionIndexes] firstIndex];
            for(int i=index-1;i>=0;i--) {
                if([[[[self dataSource] mImages] objectAtIndex:i] state]==1) {
                    [self setSelectionIndexes:[[NSIndexSet alloc] initWithIndex:i] byExtendingSelection:FALSE];
                    return;
                }
            }
        }
        
        if( [theArrow characterAtIndex:0] == NSRightArrowFunctionKey) {
            int index = [[self selectionIndexes] firstIndex];
            for(int i=index+1;i<[[self dataSource] numberOfItemsInImageBrowser:self];i++) {
                if([[[[self dataSource] mImages] objectAtIndex:i] state]==1) {
                    [self setSelectionIndexes:[[NSIndexSet alloc] initWithIndex:i] byExtendingSelection:FALSE];
                    return;
                }
            }
        }
    }
    [super keyDown: theEvent];

}


@end
