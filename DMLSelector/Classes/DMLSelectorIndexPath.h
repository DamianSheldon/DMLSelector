//
//  DMLSelectorIndexPath.h
//  Pods
//
//  Created by DongMeiliang on 5/17/16.
//
//

#import <Foundation/Foundation.h>


@interface DMLSelectorIndexPath : NSObject

+ (instancetype)indexPathWithComponentIndex:(NSInteger)index forRow:(NSInteger)row inSection:(NSInteger)section;

- (instancetype)initWithComponentIndex:(NSInteger)index section:(NSInteger)section row:(NSInteger)row;

@property (nonatomic, readonly) NSInteger componentIndex;
@property (nonatomic, readonly) NSInteger section;
@property (nonatomic, readonly) NSInteger row;

@end
