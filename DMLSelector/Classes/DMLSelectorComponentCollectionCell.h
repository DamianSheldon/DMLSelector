//
//  DMLSelectorComponentCollectionCell.h
//  Pods
//
//  Created by DongMeiliang on 5/24/16.
//
//

#import <UIKit/UIKit.h>

@interface DMLSelectorComponentCollectionCell : UICollectionViewCell

@property (nonatomic, readonly) UIImageView *imageView;
@property (nonatomic, readonly) UILabel *textLabel;
@property (nonatomic, getter=isChecked) BOOL checked;

- (void)setChecked:(BOOL)checked animated:(BOOL)animated;

@end
