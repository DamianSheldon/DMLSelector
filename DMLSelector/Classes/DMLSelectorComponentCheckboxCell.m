//
//  DMLSelectorComponentCollectionCell.m
//  Pods
//
//  Created by DongMeiliang on 5/24/16.
//
//

#import "NSString+DMLSelector.h"

#import "DMLSelectorComponentCheckboxCell.h"

NSString *const DMLSelectorComponentCheckboxCellIdentifier = @"DMLSelectorComponentCheckboxCellIdentifier";

static CGFloat const sImageViewSideLength = 26.0;
static CGFloat const sPadding = 4.0;


@interface DMLSelectorComponentCheckboxCell ()

@property (nonatomic) UIImageView *imageView;

@end


@implementation DMLSelectorComponentCheckboxCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        self.contentView.layer.borderWidth = 1.0;
        self.contentView.layer.cornerRadius = 2.0f;

        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.contentView addSubview:_imageView];

        // Constraints for image view
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:sPadding * 0.5]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:sImageViewSideLength]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:sImageViewSideLength]];

        // Constraints for label
        [self.contentView removeConstraint:self.leftConstraint];
        [self.contentView removeConstraint:self.rightConstraint];

        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_imageView attribute:NSLayoutAttributeRight multiplier:1.0 constant:sPadding]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-sPadding * 0.5]];
    }

    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];

    self.imageView.image = nil;
}

- (CGSize)intrinsicContentSize
{
    CGSize size = CGSizeMake(sImageViewSideLength + 2 * sPadding, sImageViewSideLength);

    if (self.textLabel.text) {
        CGSize stringSize = [self.textLabel.text dml_sizeWithAttributes:@{NSFontAttributeName : self.textLabel.font}];
        stringSize.height += self.topConstraint.constant + self.bottomConstraint.constant; // Text Label's height

        size.width += stringSize.width;
        size.height = MAX(size.height, stringSize.height);
    }

    return size;
}

- (void)setChecked:(BOOL)checked animated:(BOOL)animated
{
    self.checked = checked;

    if (checked) {
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        self.imageView.image = [UIImage imageNamed:@"DMLSelector.bundle/Checked" inBundle:bundle compatibleWithTraitCollection:nil];
    } else {
        self.imageView.image = nil;
    }

    self.contentView.layer.borderColor = checked ? self.cellDescriptor.selectedBorderColor.CGColor : self.cellDescriptor.borderColor.CGColor;

    self.textLabel.textColor = checked ? self.cellDescriptor.selectedTextColor : self.cellDescriptor.textColor;
}

@end
