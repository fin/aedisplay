//
//  MyImage.m
//  aethertest3
//
//  Created by fin on 5/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MyImage.h"
#import <Quartz/Quartz.h>


@implementation MyImage

- (void) dealloc
{
    [super dealloc];
}

@synthesize state;
@synthesize imgPath;
@synthesize element;
@synthesize uuid;




- (void) setImgPath:(NSString *) path
{
    state = 1;
    if(imgPath != path){
        [imgPath release];
        imgPath = [path retain];
    }
}

- (MyImage *) init {
    [super init];

    CFUUIDRef	uuidObj = CFUUIDCreate(nil);//create a new UUID
    //get the string representation of the UUID
    NSString	*uuidString = (NSString*)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    [self setUuid:uuidString];
    return self;
}


- (MyImage *) copy {
    MyImage *mi =[[MyImage alloc] init];
    [mi setImgPath:imgPath];
    [mi setState: state];
    return mi;
}

- (NSString *)  imageRepresentationType
{
    return IKImageBrowserNSImageRepresentationType;
}

- (id) imageRepresentation
{
    if (state==1) {
        return [[NSImage alloc] initWithContentsOfFile:imgPath];        
    } else {
        float resizeWidth = 13.0;
        float resizeHeight = 13.0;
        
        
        NSImage *sourceImage =  [[NSImage alloc] initWithContentsOfFile:imgPath];
        NSImage *resizedImage = [[NSImage alloc] initWithSize: NSMakeSize(resizeWidth, resizeHeight)];
        
        NSSize originalSize = [sourceImage size];
        
        [resizedImage lockFocus];
        [sourceImage drawInRect: NSMakeRect(0, 0, resizeWidth, resizeHeight) fromRect: NSMakeRect(0, 0, originalSize.width, originalSize.height) operation: NSCompositeSourceOver fraction: 1.0];
        [resizedImage unlockFocus];
        
        return resizedImage;
    }
}

- (id) actualImage
{
    NSLog(@"actualImage %@", imgPath);
    if (imgPath==NULL||imgPath==nil) {
        NSLog(@"path is nil");
    }
    return [[NSImage alloc] initWithContentsOfFile:imgPath];
}

- (NSString *) imageUID
{
    NSString *s = [NSString stringWithFormat:@"%@-%d", imgPath, state];
    return s;
}

@end
