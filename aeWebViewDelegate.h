//
//  aeWebViewDelegate.h
//  aethertest3
//
//  Created by fin on 6/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "NSString+NSStringHalpers.h"


@interface aeWebViewDelegate : NSObject {
    NSArrayController * data;
    IBOutlet WebView *webView;
}

- (void)setDataSource:(NSArrayController *) data_;


- (void)observeValueForArrangedObjects:(id)object
                                change:(NSDictionary *)change
                               context:(void *)context;

@end
