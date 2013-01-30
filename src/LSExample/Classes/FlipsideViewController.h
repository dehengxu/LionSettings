//
//  FlipsideViewController.h
//  LSExample
//
//  Created by Scott Lawrence on 4/2/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LlamaSettings.h"

@interface FlipsideViewController : UIViewController 
	// LLAMASETTINGS 1:  Make your class the delegate
	<LlamaSettingsDelegate>
{
	IBOutlet UITableView * theTableView;
	
	// LLAMASETTINGS 2:  Add the LlamaSettings object into the class
	LlamaSettings * ls;
}

@end
