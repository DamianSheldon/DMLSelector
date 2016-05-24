//
//  DMLSelectorOption.h
//  Pods
//
//  Created by DongMeiliang on 5/17/16.
//
//

#import <Foundation/Foundation.h>

@interface DMLSelectorOption : NSObject

- (instancetype)initWithMasterText:(NSString *)masterText detailTexts:(NSArray *)detailTexts;

@property (nonatomic, copy) NSString *masterText;
@property (nonatomic, copy) NSArray *detailTexts;

@end
