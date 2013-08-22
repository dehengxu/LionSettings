//
//  LionViewController.h
//  
//
//  Created by Deheng.Xu on 13-8-21.
//  Copyright (c) 2013年 Deheng.Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LlamaSettings.h"
//@class LlamaSettings;
//@protocol LlamaSettingsDelegate;
@class LionMultiValuesViewController;

@interface LionSettingsViewController : UIViewController<LlamaSettingsDelegate>
{
@private
    NSString *_bundleName;
    NSString *_fileName;
}

@property (nonatomic, retain) LlamaSettings *ls;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) LionMultiValuesViewController *multiValuesView;

- (id)initWithSettingsBundleName:(NSString *)bundleName;
- (id)initWithSettingsBundleName:(NSString *)bundleName andPlistName:(NSString *)plistName;

@end
