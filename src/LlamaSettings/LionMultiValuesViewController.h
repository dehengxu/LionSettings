//
//  LionMultiValuesViewController.h
//  
//
//  Created by Deheng.Xu on 13-8-21.
//  Copyright (c) 2013年 Deheng.Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LlamaSettings.h"

/**
 LionMultiValuesViewController  Present a multi values user interface , you can choose some specified one value among them.
 */
@interface LionMultiValuesViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

/**
 A NSDictionary object which stored settings root element.
 */
@property (nonatomic, retain) NSDictionary *settingsElement;

/**
 LlamaSettings object.
 */
@property (nonatomic, retain) LlamaSettings *ls;

/**
 A table view.
 */
@property (nonatomic, retain) UITableView *tableView;
/**
 PSKey fot system settings.
 */
@property (nonatomic, retain) NSString *PSKey;
/**
 Selected value.
 */
@property (nonatomic, retain) id value;

@end
