//
//  DMLSelectorOptionDescriptor.m
//  Pods
//
//  Created by DongMeiliang on 5/17/16.
//
//

#import "UIColor+DMLSelector.h"

#import "DMLSelectorComponentDescriptor.h"
#import "DMLSelectorImageBarCell.h"

@implementation DMLSelectorComponentDescriptor

+ (instancetype)selectorComponentDescriptorWithTitle:(NSString *)title componentType:(NSString *)componentType
{
    DMLSelectorComponentDescriptor *componentDescriptor = [[DMLSelectorComponentDescriptor alloc] initWithTitle:title componentType:componentType];

    return componentDescriptor;
}

- (instancetype)initWithTitle:(NSString *)title componentType:(NSString *)componentType
{
    self = [super init];

    if (self) {
        _title = [title copy];
        _componentType = [componentType copy];

        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        _image = [UIImage imageNamed:@"DMLSelector.bundle/DownArrow" inBundle:bundle compatibleWithTraitCollection:nil];
        _selectedImage = [UIImage imageNamed:@"DMLSelector.bundle/UpArrow" inBundle:bundle compatibleWithTraitCollection:nil];

        _componentCellIdentifier = DMLSelectorImageBarCellIdentifier;
        _interactionStyle = DMLSelectorComponentInteractionStyleExpand;

        _textColor = [UIColor blackColor];
        _selectedTextColor = [UIColor dml_orangleColor];
    }

    return self;
}

@end
