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

- (void) setPath:(NSString *) path
{
    if(mPath != path){
        [mPath release];
        mPath = [path retain];
    }
}

- (NSString *)  imageRepresentationType
{
    return IKImageBrowserPathRepresentationType;
}

- (id)  imageRepresentation
{
    return mPath;
}

- (NSString *) imageUID
{
    return mPath;
}

@end
