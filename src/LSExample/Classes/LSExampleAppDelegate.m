//
//  LSExampleAppDelegate.m
//  LSExample
//
//  Created by Scott Lawrence on 4/2/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "LSExampleAppDelegate.h"
#import "RootViewController.h"

@implementation LSExampleAppDelegate


@synthesize window;
@synthesize rootViewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {
    
    [window addSubview:[rootViewController view]];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [rootViewController release];
    [window release];
    [super dealloc];
}

@end
