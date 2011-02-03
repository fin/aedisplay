//
//  MyDocument.m
//  nsdocumenttest
//
//  Created by fin del kind on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyDocument.h"


static BOOL isfile(NSString *path) {
    const char *mypath = [path UTF8String];
    FILE *testfile = fopen(mypath, "r");
    if (testfile) { fclose(testfile); return YES; } else { return NO; }
}


void fsevents_callback(ConstFSEventStreamRef streamRef,
                       void *userData,
                       size_t numEvents,
                       void *eventPaths,
                       const FSEventStreamEventFlags eventFlags[],
                       const FSEventStreamEventId eventIds[])
{
    MyDocument *ac = (MyDocument *)userData;
    size_t i;
    for(i=0; i < numEvents; i++){
        NSString *filename = [(NSArray *)eventPaths objectAtIndex:i];
        NSLog(@"%@", filename);
        [ac addImagesWithPath:filename recursive:NO];

 /*       for(size_t j=0;j<[[[ac images] arrangedObjects] count]; j++) {
            if([[[[[ac images] arrangedObjects] objectAtIndex:j] imgPath] isEqual:filename]){
                found=1;
                NSLog(@"FOUND");
            }
        }
        BOOL isDir;
        if(found==0 && [[NSFileManager defaultManager] fileExistsAtPath:filename isDirectory:&isDir] && !isDir) {
            NSLog(@"NOTFOUND");
            [ac addAnImageWithPath:filename];
            [ac setLastEventId:[NSNumber numberWithInt:eventIds[i]]];
        }*/
    }
    [ac updateDatasource];
}





@implementation MyDocument

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"MyDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *) aController
{
    NSLog(@"DID LOAD NIB");
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
    
     NSLog(@"/DID LOAD NIB");
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to write your document to data of the specified type. If the given outError != NULL, ensure that you set *outError when returning nil.

    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.

    // For applications targeted for Panther or earlier systems, you should use the deprecated API -dataRepresentationOfType:. In this case you can also choose to override -fileWrapperRepresentationOfType: or -writeToFile:ofType: instead.

    if ( outError != NULL ) {
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
	}
	return nil;
}
/*
- (BOOL) readFromFileWrapper: (NSFileWrapper*)wrapper ofType: (NSString*)type error: (NSError**)error {

 */
- (BOOL) readFromURL: (NSURL*)url ofType: (NSString*)type error: (NSError**)error {
    NSString *filename_ = [url path];
    NSLog(@"readFromUrl! %@", filename_);
    [self setFilename:filename_];
    
    return YES;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    NSLog(@"readFromData!");
    // Insert code here to read your document from the given data of the specified type.  If the given outError != NULL, ensure that you set *outError when returning NO.

    // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead. 
    
    // For applications targeted for Panther or earlier systems, you should use the deprecated API -loadDataRepresentation:ofType. In this case you can also choose to override -readFromFile:ofType: or -loadFileWrapperRepresentation:ofType: instead.
    
    if ( outError != NULL ) {
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
	}
    return YES;
}

@synthesize filename;


/* --------------------------------------------------------------- */


- (void) awakeFromNib {
    NSLog(@"awake from nib");
   
	mImportedImages = [[NSMutableArray alloc] init];
	
	[mImageView setImage:[[NSImage alloc] init]];

    NSString *resourcePath = [[[[NSBundle mainBundle] resourcePath]
                               stringByReplacingOccurrencesOfString:@"/" withString:@"//"]
                              stringByReplacingOccurrencesOfString:@" " withString:@"%20"];

    
    [webView setUIDelegate:webViewDelegate];
    [webView setEditingDelegate:webViewDelegate];
    [webView setResourceLoadDelegate:webViewDelegate];

    
    [[webView mainFrame] loadHTMLString:[NSString stringWithContentsOfFile:
                                         [[NSBundle mainBundle] pathForResource:@"webview"
                                                                         ofType:@"html"]
                                                                  encoding:NSUTF8StringEncoding
                                                                     error:NULL]
                                baseURL:[NSURL URLWithString:[NSString stringWithFormat:@"file:/%@//", resourcePath]]];

    [webViewDelegate setDataSource:images];
    
    [images addObserver:self forKeyPath:@"selectionIndexes" options:0 context:nil];

     NSArray *paths = [NSArray arrayWithObject:filename];
	[NSThread detachNewThreadSelector:@selector(addImagesWithPaths:) toTarget:self withObject:paths];
    [self initializeEventStream];
    [window setTitle:[self filename]];

    NSLog(@"window: %@", window);
    NSLog(@"webViewDelegate: %@", webViewDelegate);
    
    NSLog(@"window: %@", window);
    NSLog(@"webViewDelegate: %@", webViewDelegate);

    
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    [[[images arrangedObjects] objectAtIndex:[images selectionIndex]] actualImage];
    [mImageView setImage:[[[images arrangedObjects] objectAtIndex:[images selectionIndex]] actualImage]];
    [mImageView setNeedsDisplay:YES];
}


- (void) dealloc {
	[mImportedImages release];
	
	[super dealloc];
}

- (void) updateDatasource
{
    NSLog(@"updating datasource");
    [images addObjects:mImportedImages];
    [mImportedImages removeAllObjects];
}
- (void) imageBrowserSelectionDidChange:(IKImageBrowserView *)aBrowser {
}


- (void) addAnImageWithPath:(NSString *) path
{
    NSLog(@"add an image with path: %@", path);
    
    for(size_t i=0; i<[mImportedImages count]; i++) {
        if ([path isEqual:[[mImportedImages objectAtIndex:i] imgPath]]) {
            return;
        }
    }
    for(size_t i=0; i<[[images arrangedObjects] count]; i++) {
        if ([path isEqual:[[[images arrangedObjects] objectAtIndex:i] imgPath]]) {
            return;
        }
    }
    
    MyImage *p;
	
    p = [[MyImage alloc] init];
    [p setImgPath:path];
    [mImportedImages addObject:p];
}

- (void) addImagesWithPath:(NSString *)path recursive:(BOOL) recursive
{
    int i, n;
    BOOL dir;
	
    [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&dir];
    if(dir){
        NSArray *content = [[NSFileManager defaultManager]
							contentsOfDirectoryAtPath:path error:nil];
        n = [content count];
		for(i=0; i<n; i++){
            //NSLog(@"adding image: %@", [content objectAtIndex:i]);
            if([[content objectAtIndex:i] hasPrefix:@"."])
                continue;
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
    else if([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [self addAnImageWithPath:path];
    }
}



- (void) addImagesWithPaths:(NSArray *) paths
{
    int i, n;
	
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [paths retain];
	
    n = [paths count];
    for(i=0; i<n; i++){
        NSString *path = [paths objectAtIndex:i];
        NSLog(@"adding images from: %@", path);

        [self addImagesWithPath:path recursive:NO];
    }
	
    [self performSelectorOnMainThread:@selector(updateDatasource)
                           withObject:nil
                        waitUntilDone:YES];
    
    NSLog(@"done adding images");
    
    [paths release];
    [pool release];
}


- (void) initializeEventStream
{
    NSString *myPath =  [self filename];
    NSLog(@"initializing event stream for %@", myPath);
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




@synthesize lastEventId;
@synthesize images;



@end
