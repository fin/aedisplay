//
//  MyImage.h
//  aethertest3
//
//  Created by fin on 5/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>


@interface MyImage : NSObject {
    NSString * imgPath;
    NSInteger state;
    DOMHTMLElement *element;
    NSString *uuid;

}
- (MyImage *) copy;
- (NSImage *) actualImage;
@property(readwrite) NSInteger state;
@property(readonly) NSString *imgPath;
@property(readwrite,assign) DOMHTMLElement *element;
@property(readwrite,assign) NSString *uuid;


@end
