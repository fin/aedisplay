//
//  aethertest3AppDelegate.h
//  aethertest3
//
//  Created by fin on 5/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "aeController.h"

@interface aethertest3AppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
    IBOutlet aeController *controller;
}

@property (assign) IBOutlet NSWindow *window;

@end
