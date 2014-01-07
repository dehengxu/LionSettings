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
        _fileName = [@"Root" copy];
    }
    return self;
}

- (id)initWithSettingsBundleName:(NSString *)bundleName andPlistName:(NSString *)plistName
{
    self = [self initWithNibName:nil bundle:nil];
    if (self) {
        _bundleName = [bundleName copy];
        if (!plistName) {
            _fileName = [@"Root" copy];
        }else {
            _fileName = [plistName copy];
        }
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _bundleName = [@"Settings" copy];
        _fileName = [@"Root" copy];
    }
    return self;
}

- (void)dealloc
{
    [_bundleName release];
    [_fileName release];
    [_ls release];
    [_tableView release];
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
            _ls = [[LlamaSettings alloc] initWithSettingsBundle:[NSString stringWithFormat:@"%@.bundle", _bundleName] andPlistName:[NSString stringWithFormat:@"%@.plist", _fileName]];
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
    [self.ls loadSettingsFromSystem];
    [self.ls startListening];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.ls stopListening];
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
    NSLog(@"button key:%@", buttonKey);
    NSDictionary *element = [ls preferenceSpecifiersElementForKey:buttonKey];
    NSString *PSType = [ls PSTypeOfSettingsElement:element];
    
    if ([PSType isEqualToString:@"PSMultiValueSpecifier"]) {
        //Push to multi values view.
        LionMultiValuesViewController *lmvvc = [[[LionMultiValuesViewController alloc] init] autorelease];
        lmvvc.settingsElement = element;
        lmvvc.ls = self.ls;
        lmvvc.PSKey = buttonKey;
        lmvvc.value = [self.ls settingsValueForKey:buttonKey];
        self.multiValuesView = lmvvc;
        self.multiValuesView.title = [element valueForKey:@"Title"];
        
        if (!self.navigationController) {
            NSLog(@"You need a UINavigationController container!");
        }
        
        [self.navigationController pushViewController:self.multiValuesView animated:YES];
    }
    
}

- (void)childPanelPressed:(NSDictionary *)aSpecifiers inSettings:(LlamaSettings *)ls
{
    //Only load plist in the same bundle.
    LionSettingsViewController *lsvc = [[[LionSettingsViewController alloc] initWithSettingsBundleName:_bundleName andPlistName:[aSpecifiers valueForKey:@"File"]] autorelease];
    
    [lsvc setTitle:NSLocalizedStringFromTableInBundle([aSpecifiers valueForKey:@"Title"], ls.stringsTableName, ls.settingsBundle, nil)];
    [self.navigationController pushViewController:lsvc animated:YES];
}

- (void)userDefaultDidChanged
{
    if (self.multiValuesView) {
        self.multiValuesView.value = [self.ls settingsValueForKey:self.multiValuesView.PSKey];
        [self.multiValuesView.tableView reloadData];
    }
}

- (void)settingsChanged:(LlamaSettings *)ls
{
    
}

@end
