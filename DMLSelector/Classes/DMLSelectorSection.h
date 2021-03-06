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

@property (nonatomic, getter=isExclusiveSelect) BOOL exclusiveSelect; // Default is NO

@property (nonatomic, readonly) NSString *sectionText;
@property (nonatomic, readonly) NSArray *rowTexts;

@property (nonatomic) UIImage *sectionImage;

@property (nonatomic, getter=isShowSectionFooterHairLine) BOOL showSectionFooterHairLine; // Default is NO

@end
