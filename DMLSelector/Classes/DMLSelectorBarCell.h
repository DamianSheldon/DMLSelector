//
//  DMLSelectorBarCell.h
//  Pods
//
//  Created by DongMeiliang on 5/18/16.
//
//

#import <UIKit/UIKit.h>

#import "DMLSelectorBar.h"

extern NSString *const DMLSelectorBarCellIdentifier;


@interface DMLSelectorBarCell : UICollectionViewCell <DMLSelectorBar>

@property (nonatomic, readonly) UILabel *textLabel;
@property (nonatomic) UIColor *selectedTextColor;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated;

@end
