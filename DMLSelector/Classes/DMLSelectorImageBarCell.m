//
//  DMLSelectorImageBarCell.m
//  Pods
//
//  Created by DongMeiliang on 7/21/16.
//
//

#import "DMLSelectorImageBarCell.h"

NSString *const DMLSelectorImageBarCellIdentifier = @"DMLSelectorImageBarCellIdentifier";


@interface DMLSelectorImageBarCell ()

@property (nonatomic) UIImageView *imageView;

@property (nonatomic) UIImage *image;
@property (nonatomic) UIImage *highlightedImage;

@end


@implementation DMLSelectorImageBarCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_imageView];

        [_imageView setTranslatesAutoresizingMaskIntoConstraints:NO];

        [_imageView setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];

        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.textLabel attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];

        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.textLabel attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];

        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        topConstraint.priority = UILayoutPriorityDefaultHigh - 1;

        [self.contentView addConstraint:topConstraint];

        NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
        bottomConstraint.priority = UILayoutPriorityDefaultHigh - 1;

        [self.contentView addConstraint:bottomConstraint];
    }

    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];

    self.imageView.image = nil;
}

- (void)configureWithComponentDescriptor:(DMLSelectorComponentDescriptor *)componentDescriptor
{
    [super configureWithComponentDescriptor:componentDescriptor];

    self.imageView.image = componentDescriptor.image;

    self.image = componentDescriptor.image;
    self.highlightedImage = componentDescriptor.selectedImage;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    self.imageView.image = selected ? self.highlightedImage : self.image;
}

/* Note:Workaround collection cell will auto change state by
 *    overriding a private method.
 */
// - (void)_setSelected:(BOOL)selected animated:(BOOL)animated
// {
//
// }

@end
