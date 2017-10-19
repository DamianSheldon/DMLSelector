//
//  DMLExamplesViewController.m
//  DMLSelector
//
//  Created by DongMeiliang on 8/19/16.
//  Copyright © 2016 Meiliang Dong. All rights reserved.
//

#import "DMLExamplesViewController.h"
#import "DMLGeneralViewController.h"
#import "DMLSelectStyleViewController.h"
#import "DMLCheckboxViewController.h"

static NSString *const sExampleCellIdentifier = @"sExampleCellIdentifier";


@interface DMLExamplesViewController ()

@property (nonatomic) NSDictionary *examples;

@end


@implementation DMLExamplesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Examples";

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:sExampleCellIdentifier];
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.examples.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sExampleCellIdentifier forIndexPath:indexPath];

    NSArray *allKeys = self.examples.allKeys;

    cell.textLabel.text = allKeys[indexPath.row];

    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *allKeys = self.examples.allKeys;

    Class class = self.examples[allKeys[indexPath.row]];

    UIViewController *vc = [[class alloc] initWithNibName:nil bundle:nil];

    vc.title = allKeys[indexPath.row];

    [self.navigationController pushViewController:vc animated:YES];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Getter

- (NSDictionary *)examples
{
    if (!_examples) {
        _examples = @{
            @"General" : [DMLGeneralViewController class],
            @"Select style interaction" : [DMLSelectStyleViewController class],
            @"Checkbox exclusive select" : [DMLCheckboxViewController class],
        };
    }

    return _examples;
}

@end
