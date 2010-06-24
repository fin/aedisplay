//
//  MyImage.h
//  aethertest3
//
//  Created by fin on 5/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>



@interface MyImage : NSObject {
    NSString * mPath;
    int state;
}
- (void) setPath:(NSString *) path;
- (MyImage *) copy;
@property(readwrite) int state;
@property(readwrite) NSString *mPath;


@end
