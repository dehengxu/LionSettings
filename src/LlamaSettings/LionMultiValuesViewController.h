//
//  LionMultiValuesViewController.h
//  
//
//  Created by Deheng.Xu on 13-8-21.
//  Copyright (c) 2013年 Deheng.Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LlamaSettings.h"

@interface LionMultiValuesViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, retain) NSDictionary *settingsElement;
@property (nonatomic, retain) LlamaSettings *ls;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSString *PSKey;
@property (nonatomic, retain) id value;

@end
