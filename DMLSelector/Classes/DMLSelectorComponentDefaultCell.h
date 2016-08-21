//
//  DMLSelectorComponentDefaultCell.h
//  Pods
//
//  Created by DongMeiliang on 8/7/16.
//
//

#import <UIKit/UIKit.h>

#import "DMLSelectorCollectionCellDescriptor.h"

extern NSString *const DMLSelectorComponentDefaultCellIdentifier;

@interface DMLSelectorComponentDefaultCell : UICollectionViewCell

@property (nonatomic, readonly) UILabel *textLabel;

@property (nonatomic, readonly) NSLayoutConstraint *leftConstraint;
@property (nonatomic, readonly) NSLayoutConstraint *rightConstraint;
@property (nonatomic, readonly) NSLayoutConstraint *topConstraint;
@property (nonatomic, readonly) NSLayoutConstraint *bottomConstraint;

@property (nonatomic, readonly) DMLSelectorCollectionCellDescriptor *cellDescriptor;

@property (nonatomic, getter = isChecked) BOOL checked;

- (void)configureWithCellDescriptor:(DMLSelectorCollectionCellDescriptor *)descriptor;

- (void)setChecked:(BOOL)checked animated:(BOOL)animated;

@end
