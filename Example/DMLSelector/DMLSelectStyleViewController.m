//
//  DMLSelectStyleViewController.m
//  DMLSelector
//
//  Created by DongMeiliang on 8/19/16.
//  Copyright © 2016 Meiliang Dong. All rights reserved.
//

#import <DMLSelector/DMLSelector.h>

#import "DMLSelectStyleViewController.h"

@interface DMLSelectStyleViewController () <DMLSelectorDataSource, DMLSelectorDelegate>

@property (nonatomic) DMLSelector *selector;
@property (nonatomic) NSArray *selectorComponentDescriptors;

@end

@implementation DMLSelectStyleViewController

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
        DMLSelectorComponentDescriptor *component1 = [DMLSelectorComponentDescriptor selectorComponentDescriptorWithTitle:@"价格" componentType:DMLSelectorComponentTypeDoubleTable];
        component1.interactionStyle = DMLSelectorComponentInteractionStyleSelect;

        DMLSelectorComponentDescriptor *component2 = [DMLSelectorComponentDescriptor selectorComponentDescriptorWithTitle:@"人气" componentType:DMLSelectorComponentTypeSingleTable];
        component2.interactionStyle = DMLSelectorComponentInteractionStyleSelect;

        DMLSelectorComponentDescriptor *component3 = [DMLSelectorComponentDescriptor selectorComponentDescriptorWithTitle:@"评分" componentType:DMLSelectorComponentTypeSingleTable];
        component3.interactionStyle = DMLSelectorComponentInteractionStyleSelect;

        DMLSelectorComponentDescriptor *component4 = [DMLSelectorComponentDescriptor selectorComponentDescriptorWithTitle:@"距离" componentType:DMLSelectorComponentTypeCollection];
        component4.interactionStyle = DMLSelectorComponentInteractionStyleSelect;

        _selectorComponentDescriptors = @[component1, component2, component3, component4];
    }

    return _selectorComponentDescriptors;
}

@end
