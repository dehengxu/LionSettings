//
//  FlipsideViewController.m
//  LSExample
//
//  Created by Scott Lawrence on 4/2/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "FlipsideViewController.h"


@implementation FlipsideViewController

#pragma mark -
#pragma mark basic flipside stuff

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];
    
	// LLAMASETTINGS 3:  Make the connections to and from it
	ls = [[LlamaSettings alloc] initWithPlist:@"mySettings.plist"];
	[ls setDelegate:self];
	[theTableView setDataSource:ls];
	[theTableView setDelegate:ls];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
    [super dealloc];
}


#pragma mark -
#pragma mark LlamaSettingsDelegate methods and support
// LLAMASETTINGS 4:  implement the delegate methods

- (void) settingsChanged:(LlamaSettings *)theSettings
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSLog( @"Delegate received 'settingsChanged' message" );
	[pool release];
}

- (void) buttonPressed:(NSString *)buttonKey inSettings:(LlamaSettings *)ls
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSLog( @"Button Pressed: %@", buttonKey );
	[pool release];
}


@end
