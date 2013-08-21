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

@interface LionSettingsViewController : UIViewController<LlamaSettingsDelegate>
{
@private
    NSString *_bundleName;
    
}

@property (nonatomic, retain) LlamaSettings *ls;
@property (nonatomic, retain) UITableView *tableView;

- (id)initWithSettingsBundleName:(NSString *)bundleName;

@end
