//
//  DMLSelectorSingleTable.m
//  Pods
//
//  Created by DongMeiliang on 5/17/16.
//
//

#import "DMLSelectorComponentSingleTable.h"
#import "DMLSelectorComponentDescriptor.h"
#import "DMLSelectorOption.h"
#import "DMLSelector.h"

static NSString *const sSingleTableCellIdentifier = @"sSingleTableCellIdentifier";

@interface DMLSelectorComponentSingleTable ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) UITableView *tableView;
@property (nonatomic) DMLSelectorOption *option;

@end

@implementation DMLSelectorComponentSingleTable

@synthesize componentDescriptor = _componentDescriptor;
@synthesize selector = _selector;
@synthesize componentIndex = _componentIndex;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:sSingleTableCellIdentifier];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self addSubview:_tableView];
        
        [_tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_tableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    }
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.option && self.componentDescriptor.options.count > 0) {
         self.option = self.componentDescriptor.options[0];
    }
    
    return self.option.detailTexts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sSingleTableCellIdentifier forIndexPath:indexPath];
    
    NSString *optionText = self.option.detailTexts[indexPath.row];
    if ([optionText isEqualToString:self.componentDescriptor.displayTextForSelectedOption]) {
        cell.textLabel.textColor = self.componentDescriptor.selectedTextColor;
    }
    else {
        cell.textLabel.textColor = self.componentDescriptor.textColor ? : [UIColor blackColor];
    }
    
    cell.textLabel.text = self.option.detailTexts[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%s", __func__);
    
    NSString *optionText = self.option.detailTexts[indexPath.row];
    
    self.componentDescriptor.displayTextForSelectedOption = optionText;
    
    [tableView reloadData];
    
    // Update component title, indicator direction
    [self.selector updateComponentAtIndex:self.componentIndex withTitle:optionText indicatorDirection:DMLSelectorComponentSelectionIndicatorDirectionDirectionUp];
    
    // Collapse component
    DMLSelectorIndexPath *selectorIndexPath = [DMLSelectorIndexPath indexPathWithComponentIndex:self.componentIndex forRow:indexPath.row inSection:indexPath.section];
    [self.selector collapseComponentWithSelectedIndexPath:selectorIndexPath];
}

#pragma mark - DMLSelectorComponent

- (CGFloat)componentHeight
{
    if (!self.option && self.componentDescriptor.options.count > 0) {
        self.option = self.componentDescriptor.options[0];
    }
    
    return self.option.detailTexts.count * 44.0f;
}

#pragma mark - Getter

- (NSDictionary *)componentValues
{
    NSDictionary *dict;
    if (self.componentDescriptor.displayTextForSelectedOption) {
        dict = @{self.option.masterText : self.componentDescriptor.displayTextForSelectedOption};
    }
    return dict;
}

@end
