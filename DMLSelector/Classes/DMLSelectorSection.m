//
//  DMLSelectorSection.m
//  Pods
//
//  Created by DongMeiliang on 5/17/16.
//
//

#import "DMLSelectorSection.h"


@interface DMLSelectorSection ()

@property (nonatomic, copy) NSString *sectionText;
@property (nonatomic, copy) NSArray *rowTexts;

@end


@implementation DMLSelectorSection

- (instancetype)initWithSectionText:(NSString *)sectionText rowTexts:(NSArray *)rowTexts
{
    self = [super init];

    if (self) {
        _sectionText = [sectionText copy];
        _rowTexts = [rowTexts copy];
    }

    return self;
}

@end
