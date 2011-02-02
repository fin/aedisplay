//
//  MyDocument.h
//  nsdocumenttest
//
//  Created by fin del kind on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import <Quartz/Quartz.h>
#import "aeWebViewDelegate.h"
#import "MyImage.h"

@interface MyDocument : NSDocument
{
    NSString *filename;
    
    
	IBOutlet WebView * webView;
	IBOutlet NSImageView * mImageView;
    IBOutlet aeWebViewDelegate * webViewDelegate;
    IBOutlet NSArrayController * images;
    IBOutlet NSWindow *window;
    
    
	NSMutableArray * mImportedImages;
    FSEventStreamRef stream;
    NSNumber* lastEventId;
}


@property(readwrite, retain) NSString *filename;


- (void) initializeEventStream;
- (void) addAnImageWithPath:(NSString *) path;
- (void) updateDatasource;
- (void) addImagesWithPath:(NSString *)path recursive:(BOOL) recursive;

@property(readwrite,retain) NSNumber *lastEventId;
@property(readonly,retain) NSArrayController *images;


@end
