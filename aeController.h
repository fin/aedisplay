//
//  aeController.h
//  aethertest3
//
//  Created by fin on 5/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>
#import <WebKit/WebKit.h>
#import "MyImage.h"
#import "aeWebViewDelegate.h"

@interface aeController : NSWindowController {
	IBOutlet WebView * webView;
	IBOutlet NSImageView * mImageView;
    IBOutlet aeWebViewDelegate * webViewDelegate;
    IBOutlet NSArrayController * images;
    
    
	NSMutableArray * mImportedImages;
    FSEventStreamRef stream;
    NSNumber* lastEventId;
}

- (void) initializeEventStream;
- (void) addAnImageWithPath:(NSString *) path;
- (IBAction) openDocument:(id) sender;
@property(readwrite,retain) NSNumber *lastEventId;

@end
