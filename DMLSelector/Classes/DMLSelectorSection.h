//
//  DMLSelectorSection.h
//  Pods
//
//  Created by DongMeiliang on 5/17/16.
//
//

#import <Foundation/Foundation.h>

@interface DMLSelectorSection : NSObject

- (instancetype)initWithSectionText:(NSString *)sectionText rowTexts:(NSArray *)rowTexts;

@property(nonatomic, getter = isExclusiveSelect) BOOL exclusiveSelect; // Default is NO

@property (nonatomic, copy) NSString    *sectionText;
@property (nonatomic, copy) NSArray     *rowTexts;

// Configure item for collection view
@property(nonatomic) CGSize itemSize;                                                       // Default is 70, 30

@property (nonatomic, getter = isSplitSectionText) BOOL splitSectionText;                   // Default is NO
@property (nonatomic, copy) NSString                    *separatorCharacter;                // Default is #

@property (nonatomic, getter = isShowSectionFooterHairLine) BOOL showSectionFooterHairLine; // Default is NO

@end
