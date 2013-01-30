//
//  LSExampleAppDelegate.h
//  LSExample
//
//  Created by Scott Lawrence on 4/2/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface LSExampleAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    RootViewController *rootViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet RootViewController *rootViewController;

@end

