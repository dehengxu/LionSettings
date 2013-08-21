//
//  LionViewController.h
//  
//
//  Created by Deheng.Xu on 13-8-21.
//  Copyright (c) 2013年 Deheng.Xu. All rights reserved.
//

#import "LionSettingsViewController.h"

#import "LionMultiValuesViewController.h"
#import "LlamaSettings.h"

@interface LionSettingsViewController ()

@end

@implementation LionSettingsViewController

- (id)initWithSettingsBundleName:(NSString *)bundleName
{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        _bundleName = [bundleName copy];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [_bundleName release];
    [super dealloc];
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    }
    return _tableView;
}

- (LlamaSettings *)ls
{
    if (_ls == nil) {
        if (_bundleName) {
            _ls = [[LlamaSettings alloc] initWithSettingsBundle:_bundleName];
        }else {
            _ls = [[LlamaSettings alloc] init];
        }
    }
    return _ls;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.ls.delegate = self;
    self.tableView.delegate = self.ls;
    self.tableView.dataSource = self.ls;
    self.tableView.frame = self.view.bounds;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - LlamaSettingsDelegate

- (void)buttonPressed:(NSString *)buttonKey inSettings:(LlamaSettings *)ls
{
    //
    NSDictionary *element = [ls preferenceSpecifiersElementForKey:buttonKey];

    if ([[ls PSTypeOfSettingsElement:element] isEqualToString:@"PSMultiValueSpecifier"]) {
        //Push to multi values view.
        LionMultiValuesViewController *lmvvc = [[LionMultiValuesViewController alloc] init];
        lmvvc.settingsElement = element;
        [self.navigationController pushViewController:lmvvc animated:YES];
    }
}

- (void)userDefaultDidChanged
{
    
}

- (void)settingsChanged:(LlamaSettings *)ls
{
    
}

@end
