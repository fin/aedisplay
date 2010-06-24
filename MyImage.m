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
    [mPath release];
    [super dealloc];
}

@synthesize state;
@synthesize mPath;


- (void) setPath:(NSString *) path
{
    state = 1;
    if(mPath != path){
        [mPath release];
        mPath = [path retain];
    }
}


- (MyImage *) copy {
    MyImage *mi =[[MyImage alloc] init];
    [mi setPath:mPath];
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
        return [[NSImage alloc] initWithContentsOfFile:mPath];        
    } else {
        float resizeWidth = 13.0;
        float resizeHeight = 13.0;
        
        
        NSImage *sourceImage =  [[NSImage alloc] initWithContentsOfFile:mPath];
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
    return [[NSImage alloc] initWithContentsOfFile:mPath];
}

- (NSString *) imageUID
{
    NSString *s = [NSString stringWithFormat:@"%@-%d", mPath, state];
    return s;
}

@end
