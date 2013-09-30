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


/**
 * LionSettingsViewController
 */
@interface LionSettingsViewController : UIViewController<LlamaSettingsDelegate>
{
@private
    NSString *_bundleName;
    NSString *_fileName;
}

/**
 * A LlamaSettings object.
 */
@property (nonatomic, retain) LlamaSettings *ls;
/**
 Table view for present setting items.
 */
@property (nonatomic, retain) UITableView *tableView;

/**
 A multiple values choosing user interface.
 */
@property (nonatomic, retain) LionMultiValuesViewController *multiValuesView;

/**
 @param bundleName
 @return A LionSettingsViewController object.
 */
- (id)initWithSettingsBundleName:(NSString *)bundleName;

/**
 @param bundleName  Bundle name without extension.
 @param plistName   plist name without extension.
 @return A LionSettingsViewController object.
 */
- (id)initWithSettingsBundleName:(NSString *)bundleName andPlistName:(NSString *)plistName;

@end
