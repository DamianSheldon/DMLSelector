//
//  DMLSelectorCollectionCellDescriptor.m
//  Pods
//
//  Created by DongMeiliang on 8/7/16.
//
//

#import "UIColor+DMLSelector.h"

#import "DMLSelectorCollectionCellDescriptor.h"
#import "DMLSelectorComponentDefaultCell.h"
#import "DMLSelectorComponentSubtitleCell.h"
#import "DMLSelectorComponentCheckboxCell.h"

@implementation DMLSelectorCollectionCellDescriptor

+ (instancetype)descriptorForDefaultCell
{
    DMLSelectorCollectionCellDescriptor *descriptor = [[self class] new];

    descriptor.cellIdentifier = DMLSelectorComponentDefaultCellIdentifier;

    return descriptor;
}

+ (instancetype)descriptorForSubtitleCell
{
    DMLSelectorCollectionCellDescriptor *descriptor = [[self class] new];

    descriptor.cellIdentifier = DMLSelectorComponentSubtitleCellIdentifier;

    return descriptor;
}

+ (instancetype)descriptorForCheckboxCell
{
    DMLSelectorCollectionCellDescriptor *descriptor = [[self class] new];

    descriptor.cellIdentifier = DMLSelectorComponentCheckboxCellIdentifier;

    return descriptor;
}

- (instancetype)init
{
    self = [super init];

    if (self) {
        _textFont = [UIFont systemFontOfSize:14];
        _detailTextFont = [UIFont systemFontOfSize:12];

        _textColor = [UIColor blackColor];
        _selectedTextColor = [UIColor dml_orangleColor];

        _borderColor = [UIColor dml_lightGrayColor];
        _selectedBorderColor = [UIColor dml_orangleColor];
    }

    return self;
}

@end
