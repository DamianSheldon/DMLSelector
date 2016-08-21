//
//  DMLSelectorCollectionCellDescriptor.h
//  Pods
//
//  Created by DongMeiliang on 8/7/16.
//
//

#import <Foundation/Foundation.h>

@interface DMLSelectorCollectionCellDescriptor : NSObject

@property (nonatomic, copy) NSString *cellIdentifier;

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *detailText;

@property (nonatomic) UIFont *textFont;             // Default is [UIFont systemFontOfSize:14]
@property (nonatomic) UIFont *detailTextFont;       // Default is [UIFont systemFontOfSize:12]

@property (nonatomic) UIColor *textColor;           // Default is blackColor
@property (nonatomic) UIColor *selectedTextColor;   // Default is dml_orangleColor

@property (nonatomic) UIColor *borderColor;         // Default is [UIColor dml_lightGrayColor]
@property (nonatomic) UIColor *selectedBorderColor; // Default is [UIColor dml_orangleColor]

+ (instancetype)descriptorForDefaultCell;
+ (instancetype)descriptorForSubtitleCell;
+ (instancetype)descriptorForCheckboxCell;

@end
