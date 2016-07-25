//
//  DMLSelectorOptionDescriptor.h
//  Pods
//
//  Created by DongMeiliang on 5/17/16.
//
//

#import <Foundation/Foundation.h>

#import "DMLSelectorSection.h"

typedef NS_ENUM (NSUInteger, DMLSelectorComponentInteractionStyle) {
    DMLSelectorComponentInteractionStyleExpand,
    DMLSelectorComponentInteractionStyleSelect
};

@interface DMLSelectorComponentDescriptor : NSObject

@property (nonatomic, readonly, copy) NSString *componentType;

@property (nonatomic, copy) NSString    *title;
@property (nonatomic) UIImage           *image;                                                 // Default  is DownArrow
@property (nonatomic) UIImage           *selectedImage;                                         // Default is UpArrow

@property (nonatomic, copy) NSString                        *componentCellIdentifier;           // Default value is DMLSelectorImageBarCellIdentifier
@property (nonatomic) DMLSelectorComponentInteractionStyle  interactionStyle;                   // Default value is DMLSelectorComponentInteractionStyleExpand

@property (nonatomic) UIColor   *textColor;                                                     // Default is blackColor
@property (nonatomic) UIColor   *selectedTextColor;                                             // Default is dml_orangleColor

@property (nonatomic, getter = isUpdateComponentTitleEnable) BOOL updateComponentTitleEnable;   // Default is NO

/// When there is requirement to update component's title, use value of this property.
@property (nonatomic, copy) NSString *displayTextForSelectedOption;

/// Track component's select state, coporate with DMLSelectorComponentInteractionStyleSelect interaction
@property (nonatomic, getter = isSelected) BOOL selected;

@property (nonatomic) NSArray <DMLSelectorSection *> *sections;

+ (instancetype)selectorComponentDescriptorWithTitle:(NSString *)title componentType:(NSString *)componentType;

- (instancetype)initWithTitle:(NSString *)title componentType:(NSString *)componentType;

@end
