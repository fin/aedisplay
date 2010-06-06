//
//  aeController.h
//  aethertest3
//
//  Created by fin on 5/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>
#import "MyImage.h"

@interface aeController : NSWindowController {
	IBOutlet IKImageBrowserView * mImageBrowser;
	IBOutlet NSImageView * mImageView;
	NSMutableArray * mImages;
	NSMutableArray * mImportedImages;

}
- (IBAction) openDocument:(id) sender;

@end