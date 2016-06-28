//
//  DMLViewController.m
//  DMLSelector
//
//  Created by Meiliang Dong on 05/17/2016.
//  Copyright (c) 2016 Meiliang Dong. All rights reserved.
//

#import <DMLSelector/DMLSelector.h>

#import "DMLViewController.h"

@interface DMLViewController ()<DMLSelectorDataSource, DMLSelectorDelegate>

@property (nonatomic) DMLSelector *selector;
@property (nonatomic) NSArray *selectorComponentDescriptors;

@end

@implementation DMLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.selector];
    
    [self configureConstraintsForSelector];
}

#pragma mark - Auto Layout

- (void)configureConstraintsForSelector
{
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.selector attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.selector attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.selector attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
}

#pragma mark - DMLSelectorDataSource

- (NSUInteger)numberOfComponentsInSelector:(DMLSelector *)selector
{
    return self.selectorComponentDescriptors.count;
}

- (DMLSelectorComponentDescriptor *)selector:(DMLSelector *)selector componentDescriptorForOptionAtIndex:(NSUInteger)index
{
    return self.selectorComponentDescriptors[index];
}

#pragma mark - DMLSelectorDelegate

- (void)selector:(DMLSelector *)selector didSelectOptionAtIndexPath:(DMLSelectorIndexPath *)indexPath
{
    NSLog(@"%s\n values:%@", __func__, selector.selectorValues);
}

#pragma mark - Getters

- (DMLSelector *)selector
{
    if (!_selector) {
        _selector = [[DMLSelector alloc] initWithFrame:CGRectZero];
        _selector.dataSource = self;
        _selector.delegate = self;
        [_selector setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return _selector;
}

- (NSArray *)selectorComponentDescriptors
{
    if (!_selectorComponentDescriptors) {
        DMLSelectorComponentDescriptor *component1 = [DMLSelectorComponentDescriptor selectorComponentDescriptorWithTitle:@"附近" componentType:DMLSelectorComponentTypeDoubleTable];
        component1.selectedTextColor = [UIColor purpleColor];

        DMLSelectorOption *option1_0 = [[DMLSelectorOption alloc] initWithMasterText:@"附近" detailTexts:@[@"附近(智能范围)", @"500", @"1000", @"2000", @"5000"]];
        
        DMLSelectorOption *option1_1 = [[DMLSelectorOption alloc] initWithMasterText:@"热门商圈" detailTexts:@[@"全部商区", @"五一广场", @"黄兴路步行街", @"司门口", @"红星", @"坡子街", @"开福万达"]];

        DMLSelectorOption *option1_2 = [[DMLSelectorOption alloc] initWithMasterText:@"芙蓉区" detailTexts:@[@"全部芙蓉区", @"五一广场", @"司门口", @"袁家岭", @"火车站"]];

        DMLSelectorOption *option1_3 = [[DMLSelectorOption alloc] initWithMasterText:@"天心区" detailTexts:@[@"全部天心区", @"黄兴南路步行街", @"坡子街", @"解放西路", @"天心阁/白沙井"]];

        DMLSelectorOption *option1_4 = [[DMLSelectorOption alloc] initWithMasterText:@"雨花区" detailTexts:@[@"全部雨花区", @"红星"]];

        DMLSelectorOption *option1_5 = [[DMLSelectorOption alloc] initWithMasterText:@"开福区" detailTexts:@[@"全部开福区", @"开福万达"]];

        DMLSelectorOption *option1_6 = [[DMLSelectorOption alloc] initWithMasterText:@"岳麓区" detailTexts:@[@"全部岳麓区", @"河西大学城", @"银盆岭"]];

        DMLSelectorOption *option1_7 = [[DMLSelectorOption alloc] initWithMasterText:@"长沙县" detailTexts:@[@"全部长沙县", @"星沙经济开发区"]];

        DMLSelectorOption *option1_8 = [[DMLSelectorOption alloc] initWithMasterText:@"望城区" detailTexts:@[@"全部望城区", @"望城步行街", @"滨水新城"]];

        DMLSelectorOption *option1_9 = [[DMLSelectorOption alloc] initWithMasterText:@"浏阳" detailTexts:@[@"全部浏阳", @"大瑶镇", @"永安镇"]];
        
        component1.options = @[option1_0, option1_1, option1_2, option1_3, option1_4, option1_5, option1_6, option1_7, option1_8, option1_9];
        
        DMLSelectorComponentDescriptor *component2 = [DMLSelectorComponentDescriptor selectorComponentDescriptorWithTitle:@"美食" componentType:DMLSelectorComponentTypeSingleTable];
        component2.selectedTextColor = [UIColor purpleColor];
        
        DMLSelectorOption *option2 = [[DMLSelectorOption alloc] initWithMasterText:@"美食" detailTexts:@[
                                                                                                      @"全部美食",
                                                                                                      @"湘菜",
                                                                                                      @"面包甜点",
                                                                                                      @"小吃快餐",
                                                                                                      @"自助餐"
                                                                                                      ]];
        
        component2.options = @[option2];
        
        DMLSelectorComponentDescriptor *component3 = [DMLSelectorComponentDescriptor selectorComponentDescriptorWithTitle:@"智能排序" componentType:DMLSelectorComponentTypeCollection];
        component3.selectedTextColor = [UIColor purpleColor];
        component3.notDisplayArrow = YES;
        
        DMLSelectorOption *option3_0 = [[DMLSelectorOption alloc] initWithMasterText:@"仅看可下单的大师" detailTexts:@[@"是", @"否"]];
        
        DMLSelectorOption *option3_1 = [[DMLSelectorOption alloc] initWithMasterText:@"大师等级" detailTexts:@[@"资深", @"高级", @"中级"]];
        
        component3.options = @[option3_0, option3_1];

        _selectorComponentDescriptors = @[component1, component2, component3];
    }
    return _selectorComponentDescriptors;
}

@end
