//
//  DMLSelectorBarCell.h
//  Pods
//
//  Created by DongMeiliang on 5/18/16.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DMLSelectorBarCellIndicatorDirection) {
    DMLSelectorBarCellIndicatorDirectionUp,
    DMLSelectorBarCellIndicatorDirectionDown
};

@interface DMLSelectorBarCell : UICollectionViewCell

@property (nonatomic, readonly) UILabel *textLabel;
@property (nonatomic) UIColor *selectedTextColor;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated;

- (void)updateIndicatorDirection:(DMLSelectorBarCellIndicatorDirection)direction;

@end
