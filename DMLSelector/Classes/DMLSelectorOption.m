//
//  DMLSelectorOption.m
//  Pods
//
//  Created by DongMeiliang on 5/17/16.
//
//

#import "DMLSelectorOption.h"

@implementation DMLSelectorOption

- (instancetype)initWithMasterText:(NSString *)masterText detailTexts:(NSArray *)detailTexts
{
    self = [super init];
    if (self) {
        _masterText = [masterText copy];
        _detailTexts = [detailTexts copy];
    }
    return self;
}

@end
