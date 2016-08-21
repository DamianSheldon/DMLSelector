//
//  DMLSelectorComponentSubtitleCell.m
//  Pods
//
//  Created by DongMeiliang on 8/7/16.
//
//

#import "NSString+DMLSelector.h"

#import "DMLSelectorComponentSubtitleCell.h"

NSString *const DMLSelectorComponentSubtitleCellIdentifier = @"DMLSelectorComponentSubtitleCellIdentifier";

static CGFloat const sPadding = 4.0f;

@interface DMLSelectorComponentSubtitleCell ()

@property (nonatomic) UILabel *detailTextLabel;

@end

@implementation DMLSelectorComponentSubtitleCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        _detailTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_detailTextLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        _detailTextLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_detailTextLabel];

        // Remove bottom constraint of textLabel of super class
        [self.contentView removeConstraint:self.bottomConstraint];

        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.textLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_detailTextLabel attribute:NSLayoutAttributeTop multiplier:1.0 constant:-sPadding * 0.5]];

        [_detailTextLabel setTranslatesAutoresizingMaskIntoConstraints:NO];

        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.detailTextLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:sPadding * 2]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.detailTextLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-sPadding * 2]];

        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.detailTextLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-sPadding]];
    }

    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];

    self.detailTextLabel.text = nil;
}

- (CGSize)intrinsicContentSize
{
    CGSize size = [super intrinsicContentSize];

    size.height += sPadding; // Added detail text label's bottom padding

    if (self.detailTextLabel.text) {
        CGSize stringSize = [self.detailTextLabel.text dml_sizeWithAttributes:@{NSFontAttributeName : self.detailTextLabel.font}];
        stringSize.width += sPadding * 4;

        size.width = MAX(size.width, stringSize.width);
        size.height += stringSize.height;
    }

    return size;
}

- (void)configureWithCellDescriptor:(DMLSelectorCollectionCellDescriptor *)descriptor
{
    [super configureWithCellDescriptor:descriptor];

    self.detailTextLabel.font = descriptor.detailTextFont;
    self.detailTextLabel.text = descriptor.detailText;
}

- (void)setChecked:(BOOL)checked animated:(BOOL)animated
{
    [super setChecked:checked animated:animated];

    self.detailTextLabel.textColor = checked ? self.cellDescriptor.selectedTextColor : self.cellDescriptor.textColor;
}

@end
