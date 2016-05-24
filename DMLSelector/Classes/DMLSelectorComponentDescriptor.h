//
//  DMLSelectorOptionDescriptor.h
//  Pods
//
//  Created by DongMeiliang on 5/17/16.
//
//

#import <Foundation/Foundation.h>

#import "DMLSelectorOption.h"

typedef NS_ENUM(NSUInteger, DMLSelectorComponentSelectionIndicatorDirection) {
    DMLSelectorComponentSelectionIndicatorDirectionDirectionUp,
    DMLSelectorComponentSelectionIndicatorDirectionDown
};

@interface DMLSelectorComponentDescriptor : NSObject

@property (nonatomic, readonly, copy) NSString *componentType;
@property (nonatomic, copy) NSString *title;
@property (nonatomic) DMLSelectorComponentSelectionIndicatorDirection direction;

@property (nonatomic) UIColor *textColor;
@property (nonatomic) UIColor *selectedTextColor;

@property (nonatomic, copy) NSString *displayTextForSelectedOption;

@property (nonatomic) NSArray<DMLSelectorOption *> *options;

+ (instancetype)selectorComponentDescriptorWithTitle:(NSString *)title componentType:(NSString *)componentType;
- (instancetype)initWithTitle:(NSString *)title componentType:(NSString *)componentType;

@end
