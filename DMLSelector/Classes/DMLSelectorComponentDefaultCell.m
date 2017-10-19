//
//  DMLSelectorComponentDefaultCell.m
//  Pods
//
//  Created by DongMeiliang on 8/7/16.
//
//

#import "NSString+DMLSelector.h"

#import "DMLSelectorComponentDefaultCell.h"

NSString *const DMLSelectorComponentDefaultCellIdentifier = @"DMLSelectorComponentDefaultCellIdentifier";

static CGFloat const sPadding = 8.0f;


@interface DMLSelectorComponentDefaultCell ()

@property (nonatomic) UILabel *textLabel;

@property (nonatomic) NSLayoutConstraint *leftConstraint;
@property (nonatomic) NSLayoutConstraint *rightConstraint;
@property (nonatomic) NSLayoutConstraint *topConstraint;
@property (nonatomic) NSLayoutConstraint *bottomConstraint;

@property (nonatomic) DMLSelectorCollectionCellDescriptor *cellDescriptor;

@end


@implementation DMLSelectorComponentDefaultCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        self.contentView.layer.borderWidth = 0.4;
        self.contentView.layer.cornerRadius = 2.0f;

        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_textLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_textLabel];

        // Configure constraints for text label
        [_textLabel setTranslatesAutoresizingMaskIntoConstraints:NO];

        _leftConstraint = [NSLayoutConstraint constraintWithItem:_textLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:sPadding];
        _rightConstraint = [NSLayoutConstraint constraintWithItem:_textLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-sPadding];

        _topConstraint = [NSLayoutConstraint constraintWithItem:_textLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:sPadding * 0.5];
        _bottomConstraint = [NSLayoutConstraint constraintWithItem:_textLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-sPadding * 0.5];

        [self.contentView addConstraints:@[ _leftConstraint, _rightConstraint, _topConstraint, _bottomConstraint ]];
    }

    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];

    self.textLabel.text = nil;
}

- (CGSize)intrinsicContentSize
{
    CGSize size = CGSizeMake(sPadding * 2, sPadding);

    if (self.textLabel.text) {
        CGSize stringSize = [self.textLabel.text dml_sizeWithAttributes:@{NSFontAttributeName : self.textLabel.font}];

        size.width += stringSize.width;
        size.height += stringSize.height;
    }

    return size;
}

- (void)configureWithCellDescriptor:(DMLSelectorCollectionCellDescriptor *)descriptor
{
    self.textLabel.font = descriptor.textFont;
    self.textLabel.textColor = descriptor.textColor;
    self.textLabel.text = descriptor.text;

    self.contentView.layer.borderColor = descriptor.borderColor.CGColor;

    self.cellDescriptor = descriptor;
}

- (void)setChecked:(BOOL)checked animated:(BOOL)animated
{
    self.checked = checked;

    self.contentView.layer.borderColor = checked ? self.cellDescriptor.selectedBorderColor.CGColor : self.cellDescriptor.borderColor.CGColor;

    self.textLabel.textColor = checked ? self.cellDescriptor.selectedTextColor : self.cellDescriptor.textColor;
}

@end
