//
//  DMLSelectorOptionDescriptor.m
//  Pods
//
//  Created by DongMeiliang on 5/17/16.
//
//

#import "DMLSelectorComponentDescriptor.h"

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
    }
    return self;
}

@end
