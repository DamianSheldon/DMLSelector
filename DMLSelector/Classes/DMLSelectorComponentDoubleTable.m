//
//  DMLSelectorDoubleTable.m
//  Pods
//
//  Created by DongMeiliang on 5/17/16.
//
//

#import "DMLSelectorComponentDoubleTable.h"
#import "DMLSelectorComponentDescriptor.h"
#import "DMLSelector.h"

static NSString *const sLeftTableCellIdentifier = @"sLeftTableCellIdentifier";
static NSString *const sRightTableCellIdentifier = @"sRightTableCellIdentifier";

@interface DMLSelectorComponentDoubleTable ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) UITableView *leftTableView;
@property (nonatomic) UITableView *rightTableView;
@property (nonatomic) NSInteger leftSelectedIndex;
@property (nonatomic) NSInteger rightSelectedIndex;

@end

@implementation DMLSelectorComponentDoubleTable

@synthesize componentDescriptor = _componentDescriptor;
@synthesize selector = _selector;
@synthesize componentIndex = _componentIndex;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _leftSelectedIndex = 0;
        _rightSelectedIndex = -1;
        
        // View hiearchy
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _leftTableView.backgroundColor = [UIColor lightGrayColor];
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _leftTableView.tableFooterView = [UIView new];
        _leftTableView.showsVerticalScrollIndicator = NO;
        [_leftTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:sLeftTableCellIdentifier];
        _leftTableView.dataSource = self;
        _leftTableView.delegate = self;
        [self addSubview:_leftTableView];
        
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _rightTableView.tableFooterView = [UIView new];
        [_rightTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:sRightTableCellIdentifier];
        _rightTableView.dataSource = self;
        _rightTableView.delegate = self;
        [self addSubview:_rightTableView];
        
        // Configure constraints
        [_leftTableView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_leftTableView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_leftTableView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_rightTableView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_leftTableView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_rightTableView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_leftTableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_leftTableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
        
        [_rightTableView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_rightTableView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_rightTableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_leftTableView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_rightTableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_leftTableView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    }
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.leftTableView) {
        return self.componentDescriptor.options.count;
    }
    else {
        // Left table view select cell at index
        if (self.leftSelectedIndex < self.componentDescriptor.options.count) {
            DMLSelectorOption *option = self.componentDescriptor.options[self.leftSelectedIndex];
            
            return option.detailTexts.count;
        }
        else {
            return 0;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.leftTableView) {
        UITableViewCell *leftCell = [tableView dequeueReusableCellWithIdentifier:sLeftTableCellIdentifier forIndexPath:indexPath];
        
        // Configure cell ...
        DMLSelectorOption *option = self.componentDescriptor.options[indexPath.row];
        leftCell.textLabel.text = option.masterText;
        
        if ([option.masterText isEqualToString:self.componentDescriptor.displayTextForSelectedOption]) {
            leftCell.backgroundColor = [UIColor whiteColor];
        }
        else {
            leftCell.backgroundColor = [UIColor lightGrayColor];
        }
        
        return leftCell;
    }
    else {
        
        UITableViewCell *rightCell = [tableView dequeueReusableCellWithIdentifier:sRightTableCellIdentifier forIndexPath:indexPath];

        DMLSelectorOption *option = self.componentDescriptor.options[self.leftSelectedIndex];
        
        rightCell.textLabel.text = option.detailTexts[indexPath.row];
        
        return rightCell;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.leftTableView) {
        DMLSelectorOption *option = self.componentDescriptor.options[indexPath.row];
        self.componentDescriptor.displayTextForSelectedOption = option.masterText;

        self.leftSelectedIndex = indexPath.row;
        self.rightSelectedIndex = -1;
        
        [self.leftTableView reloadData];

        [self.rightTableView reloadData];
    }
    else {
        DMLSelectorIndexPath *selectorIndexPath = [DMLSelectorIndexPath indexPathWithComponentIndex:self.componentIndex forRow:indexPath.row inSection:self.leftSelectedIndex];
        
        self.rightSelectedIndex = indexPath.row;
        
        [self.selector collapseComponentWithSelectedIndexPath:selectorIndexPath];
    }
}

#pragma mark - DMLSelectorComponent

- (CGFloat)componentHeight
{
    return self.componentDescriptor.options.count * 44.0f;
}

#pragma mark - Getter

- (NSDictionary *)componentValues
{
    NSDictionary *dict;
    if (self.rightSelectedIndex != -1) {
        DMLSelectorOption *option = self.componentDescriptor.options[self.leftSelectedIndex];

        dict = @{option.masterText : option.detailTexts[self.rightSelectedIndex]};
    }
    return dict;
}

@end
