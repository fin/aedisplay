//
//  MyDocumentController.m
//  nsdocumenttest
//
//  Created by fin del kind on 2/2/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyDocumentController.h"


@implementation MyDocumentController

- (IBAction) openDocument: (id)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    [panel setCanChooseDirectories:YES];
    [panel setFloatingPanel:YES];
    [panel setCanChooseDirectories:YES];
    [panel setCanChooseFiles:NO];
	[panel setAllowsMultipleSelection:false];
    int i = [panel runModalForTypes:nil];
    if(i == NSOKButton){
        [super openDocumentWithContentsOfURL:[[panel URLs] objectAtIndex:0] display:true error:nil];
    }

}


@end
