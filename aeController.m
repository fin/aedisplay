//
//  aeController.m
//  aethertest3
//
//  Created by fin on 5/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "aeController.h"

static BOOL isfile(NSString *path) {
    const char *mypath = [path UTF8String];
    FILE *testfile = fopen(mypath, "r");
    if (testfile) { fclose(testfile); return YES; } else { return NO; }
}

static NSArray *openFiles()
{
    NSOpenPanel *panel;
	
    panel = [NSOpenPanel openPanel];
    [panel setFloatingPanel:YES];
    [panel setCanChooseDirectories:YES];
    [panel setCanChooseFiles:YES];
	[panel setAllowsMultipleSelection:true];
    int i = [panel runModalForTypes:nil];
    if(i == NSOKButton){
        return [panel filenames];
    }
	
    return nil;
}


void fsevents_callback(ConstFSEventStreamRef streamRef,
                       void *userData,
                       size_t numEvents,
                       void *eventPaths,
                       const FSEventStreamEventFlags eventFlags[],
                       const FSEventStreamEventId eventIds[])
{
    aeController *ac = (aeController *)userData;
    size_t i;
    for(i=0; i < numEvents; i++){
        int found = 0;
        NSString *filename = [(NSArray *)eventPaths objectAtIndex:i];
        NSLog(filename);

        for(size_t j=0;j<[[ac mImages] count]; j++) {
            if([[[[ac mImages] objectAtIndex:j] mPath] isEqual:filename]){
                found=1;
                NSLog(@"FOUND");
            }
        }
        BOOL isDir;
        if(found==0 && [[NSFileManager defaultManager] fileExistsAtPath:filename isDirectory:&isDir] && !isDir) {
            NSLog(@"NOTFOUND");
            [ac addAnImageWithPath:filename];
            [ac setLastEventId:[NSNumber numberWithInt:eventIds[i]]];
        }
    }
}


@implementation aeController

- (void) awakeFromNib {
	mImages = [[NSMutableArray alloc] init];
	mImportedImages = [[NSMutableArray alloc] init];
		
	[mImageBrowser setAnimates:YES];
	[mImageBrowser setContentResizingMask:NSViewWidthSizable];
	
	[mImageView setImage:[[NSImage alloc] init]];
    [self initializeEventStream];
}

- (void) dealloc {
	[mImages release];
	[mImportedImages release];
	[mImageBrowser reloadData];
	
	[super dealloc];
}

- (void) updateDatasource
{
    [mImages addObjectsFromArray:mImportedImages];
    [mImportedImages removeAllObjects];
    [mImageBrowser reloadData];
}


- (NSUInteger) numberOfItemsInImageBrowser:(IKImageBrowserView *) view
{
    return [mImages count];
}

- (id) imageBrowser:(IKImageBrowserView *) view itemAtIndex:(NSUInteger) index
{
    return [mImages objectAtIndex:index];
}


- (void) imageBrowserSelectionDidChange:(IKImageBrowserView *)aBrowser {
	int index = [[mImageBrowser selectionIndexes] firstIndex];
	
	[mImageView setImage:[[mImages objectAtIndex:index] actualImage]];
	[mImageView setNeedsDisplay:YES];
}


- (void) addAnImageWithPath:(NSString *) path
{
    MyImage *p;
	
    p = [[MyImage alloc] init];
    [p setPath:path];
    [mImportedImages addObject:p];
    [p release];
}

- (void) addImagesWithPath:(NSString *) path recursive:(BOOL) recursive
{
    int i, n;
    BOOL dir;
	
    [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&dir];
    if(dir){
        NSArray *content = [[NSFileManager defaultManager]
							contentsOfDirectoryAtPath:path error:nil];
        n = [content count];
		for(i=0; i<n; i++){
            if(recursive)
				[self addImagesWithPath:
				 [path stringByAppendingPathComponent:
				  [content objectAtIndex:i]]
							  recursive:NO];
            else
				[self addAnImageWithPath:
				 [path stringByAppendingPathComponent:
				  [content objectAtIndex:i]]];
        }
    }
    else
        [self addAnImageWithPath:path];
}



- (void) addImagesWithPaths:(NSArray *) paths
{
    int i, n;
	
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [paths retain];
	
    n = [paths count];
    for(i=0; i<n; i++){
        NSString *path = [paths objectAtIndex:i];

        [self addImagesWithPath:path recursive:NO];
    }
	
    [self performSelectorOnMainThread:@selector(updateDatasource)
                           withObject:nil
                        waitUntilDone:YES];
	
    [paths release];
    [pool release];
}


- (IBAction) openDocument:(id)sender
{
    NSArray *path = openFiles();
	
    if(!path){
        NSLog(@"No path selected, return...");
        return;
    }
	[NSThread detachNewThreadSelector:@selector(addImagesWithPaths:) toTarget:self withObject:path];
}


- (void) initializeEventStream
{
    NSString *myPath =  [[[[NSFileManager defaultManager] URLsForDirectory:NSDesktopDirectory inDomains:NSUserDomainMask] objectAtIndex:0] path];
    NSArray *pathsToWatch = [NSArray arrayWithObject:myPath];
    void *appPointer = (void *)self;
    FSEventStreamContext context = {0, appPointer, NULL, NULL, NULL};
    NSTimeInterval latency = 3.0;
    stream = FSEventStreamCreate(NULL,
                                 &fsevents_callback,
                                 &context,
                                 (CFArrayRef) pathsToWatch,
                                 [lastEventId unsignedLongLongValue],
                                 (CFAbsoluteTime) latency,
                                 kFSEventStreamCreateFlagUseCFTypes
                                 );
    
    FSEventStreamScheduleWithRunLoop(stream,
                                     CFRunLoopGetCurrent(),
                                     kCFRunLoopDefaultMode);
    FSEventStreamStart(stream);
}




@synthesize mImages;
@synthesize lastEventId;

@end
