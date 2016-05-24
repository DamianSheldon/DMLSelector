//
//  DMLSelectorBarCell.h
//  Pods
//
//  Created by DongMeiliang on 5/18/16.
//
//

#import <UIKit/UIKit.h>

@interface DMLSelectorBarCell : UICollectionViewCell

@property (nonatomic, readonly) UILabel *textLabel;
@property (nonatomic) UIColor *selectedTextColor;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated;

@end
