//
//  LionMultiValuesViewController.m
//
//
//  Created by Deheng.Xu on 13-8-21.
//  Copyright (c) 2013年 Deheng.Xu. All rights reserved.
//

#import "LionMultiValuesViewController.h"

@interface LionMultiValuesViewController ()

@end

@implementation LionMultiValuesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.frame = self.view.bounds;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.tableView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    }
    return _tableView;
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.settingsElement valueForKey:@"Titles"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"_table_view_cell_identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier] autorelease];
    }
    
    if (cell) {
        //Todo:Config cell object.
        cell.textLabel.text = [[self.settingsElement valueForKey:@"Titles"] objectAtIndex:indexPath.row];
        NSLog(@"value :%@, all :%@", self.value, [self.settingsElement valueForKey:@"Values"]);
        NSArray *values = [self.settingsElement valueForKey:@"Values"];
        for (NSString *_value in values) {
            if ([self.value isEqualToString:_value]) {
                [cell setAccessibilityTraits:UIAccessibilityTraitAllowsDirectInteraction];
                break;
            }
        }
    }
    
    return cell;
}

#pragma mark - LlamaSettingsDelegate

- (void)buttonPressed:(NSString *)buttonKey inSettings:(LlamaSettings *)ls
{
    
}

- (void)userDefaultDidChanged
{
    
}

- (void)settingsChanged:(LlamaSettings *)ls
{
    
}

@end
