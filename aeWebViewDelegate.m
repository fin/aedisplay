//
//  aeWebViewDelegate.m
//  aethertest3
//
//  Created by fin on 6/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NSString+NSStringHalpers.h"
#import "aeWebViewDelegate.h"
#import "MyImage.h"

@implementation aeWebViewDelegate
- (void)setDataSource:(NSArrayController *) data_ {
    data = data_;
    NSLog(@"adding observer");
    [data addObserver:self forKeyPath:@"arrangedObjects" options:0 context:nil];    
    [data addObserver:self forKeyPath:@"selectionIndexes" options:0 context:nil];

    [[webView windowScriptObject] setValue:self forKeyPath:@"objc"];
}

- (void)selectObject:(NSString *) uuid
{
    NSLog(@"select: %@", uuid);
    MyImage *i;
    for(i in [data arrangedObjects]) {
        if ([[i uuid] isEqual:uuid]) {
            [data setSelectionIndex:[[data arrangedObjects] indexOfObject:i]];
            break;
        }
    }
}

- (void)enableObject:(NSString *) uuid
{
    NSLog(@"enable: %@", uuid);
    for(MyImage *i in [data arrangedObjects]) {
        if([[i uuid] isEqual:uuid])
            [i setState:1];
    }
}

- (void)disableObject:(NSString *) uuid
{
    NSLog(@"disable: %@", uuid);
    for(MyImage *i in [data arrangedObjects]) {
        if([[i uuid] isEqual:uuid])
            [i setState:0];
    }
}

//+ (

+ (BOOL)isSelectorExcludedFromWebScript:(SEL)aSelector { return NO; }

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    NSLog(@"message: %@", keyPath);
    if ([keyPath isEqual:@"arrangedObjects"]) {
        [self observeValueForArrangedObjects:object change:change context:context];
    }
    if ([keyPath isEqual:@"selectionIndexes"]) {
        MyImage *i;
        for(i in [data arrangedObjects]) {
            [[webView windowScriptObject] callWebScriptMethod:@"unselect" withArguments:[NSArray arrayWithObject:[i uuid]]];
        }
        i = [[data arrangedObjects] objectAtIndex:[data selectionIndex]];
        [[webView windowScriptObject] callWebScriptMethod:@"select" withArguments:[NSArray arrayWithObject:[i uuid]]];
    }
    if ([keyPath isEqual:@"state"]) {
        MyImage *i = object;
        if([i state]) {
            [[webView windowScriptObject] callWebScriptMethod:@"enable" withArguments:[NSArray arrayWithObject:[i uuid]]];
        } else {
            [[webView windowScriptObject] callWebScriptMethod:@"disable" withArguments:[NSArray arrayWithObject:[i uuid]]];
        }
    }
}
         
- (void)observeValueForArrangedObjects:(id)object
                                change:(NSDictionary *)change
                               context:(void *)context
{
    MyImage *i;
    for(i in [data arrangedObjects]) {
        if ([i element]==NULL) {
            DOMHTMLElement *li = (DOMHTMLElement *)[[[webView mainFrame] DOMDocument] createElement:@"li"];
            DOMHTMLElement *e = (DOMHTMLElement *)[[[webView mainFrame] DOMDocument] createElement:@"img"];
            DOMAttr *a = [[[webView mainFrame] DOMDocument] createAttribute:@"src"];
            DOMAttr *a2 = [[[webView mainFrame] DOMDocument] createAttribute:@"class"];
            DOMAttr *aid = [[[webView mainFrame] DOMDocument] createAttribute:@"id"];
            [a setValue:[i imgPath]];
            [e setAttributeNode:a];
            [i setElement:e];
            [i addObserver:self forKeyPath:@"state" options:0 context:i];

            [li appendChild:e];
            [li setAttributeNode:a2];
            [aid setValue:[i uuid]];
            [li setAttributeNode:aid];
            [[[[webView mainFrame] DOMDocument] getElementById:@"items"] appendChild:li];
            [[webView windowScriptObject] callWebScriptMethod:@"listenToClick" withArguments:[NSArray arrayWithObject:[i uuid]]];
        }
    }
}


- (void)keyDown:(NSEvent *)theEvent
{
    NSLog(@"keydown");
}




- (NSArray *)webView:(WebView *)sender contextMenuItemsForElement:(NSDictionary *)element 
    defaultMenuItems:(NSArray *)defaultMenuItems
{
    // disable right-click context menu
    return NO;
}

- (BOOL)webView:(WebView *)webView shouldChangeSelectedDOMRange:(DOMRange *)currentRange 
     toDOMRange:(DOMRange *)proposedRange 
       affinity:(NSSelectionAffinity)selectionAffinity 
 stillSelecting:(BOOL)flag
{
    // disable text selection
    return NO;
}

@end
