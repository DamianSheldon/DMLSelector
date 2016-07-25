//
//  DMLViewController.m
//  DMLSelector
//
//  Created by Meiliang Dong on 05/17/2016.
//  Copyright (c) 2016 Meiliang Dong. All rights reserved.
//

#import <DMLSelector/DMLSelector.h>

#import "DMLViewController.h"

@interface DMLViewController () <DMLSelectorDataSource, DMLSelectorDelegate>

@property (nonatomic) DMLSelector   *selector;
@property (nonatomic) NSArray       *selectorComponentDescriptors;

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

- (DMLSelectorComponentDescriptor *)selector:(DMLSelector *)selector componentDescriptorForComponentAtIndex:(NSUInteger)index
{
    return self.selectorComponentDescriptors[index];
}

#pragma mark - DMLSelectorDelegate

- (void)selector:(DMLSelector *)selector didSelectComponentAtIndexPath:(DMLSelectorIndexPath *)indexPath
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

        DMLSelectorSection *section1_0 = [[DMLSelectorSection alloc] initWithSectionText:@"附近" rowTexts:@[@"附近(智能范围)", @"500", @"1000", @"2000", @"5000"]];

        DMLSelectorSection *section1_1 = [[DMLSelectorSection alloc] initWithSectionText:@"热门商圈" rowTexts:@[@"全部商区", @"五一广场", @"黄兴路步行街", @"司门口", @"红星", @"坡子街", @"开福万达"]];

        DMLSelectorSection *section1_2 = [[DMLSelectorSection alloc] initWithSectionText:@"芙蓉区" rowTexts:@[@"全部芙蓉区", @"五一广场", @"司门口", @"袁家岭", @"火车站"]];

        DMLSelectorSection *section1_3 = [[DMLSelectorSection alloc] initWithSectionText:@"天心区" rowTexts:@[@"全部天心区", @"黄兴南路步行街", @"坡子街", @"解放西路", @"天心阁/白沙井"]];

        DMLSelectorSection *section1_4 = [[DMLSelectorSection alloc] initWithSectionText:@"雨花区" rowTexts:@[@"全部雨花区", @"红星"]];

        DMLSelectorSection *section1_5 = [[DMLSelectorSection alloc] initWithSectionText:@"开福区" rowTexts:@[@"全部开福区", @"开福万达"]];

        DMLSelectorSection *section1_6 = [[DMLSelectorSection alloc] initWithSectionText:@"岳麓区" rowTexts:@[@"全部岳麓区", @"河西大学城", @"银盆岭"]];

        DMLSelectorSection *section1_7 = [[DMLSelectorSection alloc] initWithSectionText:@"长沙县" rowTexts:@[@"全部长沙县", @"星沙经济开发区"]];

        DMLSelectorSection *section1_8 = [[DMLSelectorSection alloc] initWithSectionText:@"望城区" rowTexts:@[@"全部望城区", @"望城步行街", @"滨水新城"]];

        DMLSelectorSection *section1_9 = [[DMLSelectorSection alloc] initWithSectionText:@"浏阳" rowTexts:@[@"全部浏阳", @"大瑶镇", @"永安镇"]];

        component1.sections = @[section1_0, section1_1, section1_2, section1_3, section1_4, section1_5, section1_6, section1_7, section1_8, section1_9];

        DMLSelectorComponentDescriptor *component2 = [DMLSelectorComponentDescriptor selectorComponentDescriptorWithTitle:@"美食" componentType:DMLSelectorComponentTypeSingleTable];

        DMLSelectorSection *section2 = [[DMLSelectorSection alloc] initWithSectionText:@"美食" rowTexts:@[
                @"全部美食",
                @"湘菜",
                @"面包甜点",
                @"小吃快餐",
                @"自助餐"
            ]];

        component2.sections = @[section2];
        component2.updateComponentTitleEnable = YES;

        DMLSelectorComponentDescriptor *component3 = [DMLSelectorComponentDescriptor selectorComponentDescriptorWithTitle:@"智能排序" componentType:DMLSelectorComponentTypeSingleTable];

        DMLSelectorSection *section3 = [[DMLSelectorSection alloc] initWithSectionText:@"智能排序" rowTexts:@[
                @"智能排序",
                @"离我最近",
                @"人气最高",
                @"评价最好",
                @"品味最佳",
                @"环境最佳",
                @"服务最佳",
                @"人均最低",
                @"人均最高"
            ]];
        component3.sections = @[section3];
        component3.interactionStyle = DMLSelectorComponentInteractionStyleSelect;
        component3.selectedTextColor = [UIColor blackColor];
        component3.image = [UIImage imageNamed:@"Down"];
        component3.selectedImage = [UIImage imageNamed:@"Up"];

        DMLSelectorComponentDescriptor *component4 = [DMLSelectorComponentDescriptor selectorComponentDescriptorWithTitle:@"筛选" componentType:DMLSelectorComponentTypeCollection];
        component4.componentCellIdentifier = DMLSelectorBarCellIdentifier;

        DMLSelectorSection *section4_0 = [[DMLSelectorSection alloc] initWithSectionText:@"仅看可下单的大师" rowTexts:@[@"是", @"否"]];
        section4_0.exclusiveSelect = YES;

        DMLSelectorSection *section4_1 = [[DMLSelectorSection alloc] initWithSectionText:@"大师等级" rowTexts:@[@"资深", @"高级", @"中级", @"初级"]];
        section4_1.exclusiveSelect = YES;

        component4.sections = @[section4_0, section4_1];

        _selectorComponentDescriptors = @[component1, component2, component3, component4];
    }

    return _selectorComponentDescriptors;
}

@end
