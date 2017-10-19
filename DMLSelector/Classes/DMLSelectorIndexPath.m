//
//  DMLSelectorIndexPath.m
//  Pods
//
//  Created by DongMeiliang on 5/17/16.
//
//

#import "DMLSelectorIndexPath.h"


@interface DMLSelectorIndexPath ()

@property (nonatomic) NSInteger componentIndex;
@property (nonatomic) NSInteger section;
@property (nonatomic) NSInteger row;

@end


@implementation DMLSelectorIndexPath

+ (instancetype)indexPathWithComponentIndex:(NSInteger)index forRow:(NSInteger)row inSection:(NSInteger)section
{
    DMLSelectorIndexPath *indexPath = [[DMLSelectorIndexPath alloc] initWithComponentIndex:index section:section row:row];

    return indexPath;
}

- (instancetype)initWithComponentIndex:(NSInteger)index section:(NSInteger)section row:(NSInteger)row
{
    self = [super init];

    if (self) {
        _componentIndex = index;
        _section = section;
        _row = row;
    }

    return self;
}

@end
