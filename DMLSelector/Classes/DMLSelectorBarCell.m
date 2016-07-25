//
//  DMLSelectorBarCell.m
//  Pods
//
//  Created by DongMeiliang on 5/18/16.
//
//

#import "DMLSelectorBarCell.h"

NSString *const DMLSelectorBarCellIdentifier = @"DMLSelectorBarCellIdentifier";

@interface DMLSelectorBarCell ()

@property (nonatomic) UILabel *textLabel;

@end

@implementation DMLSelectorBarCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        [self.contentView addSubview:_textLabel];

        _selectedTextColor = [UIColor orangeColor];

        // Constraints
        [_textLabel setTranslatesAutoresizingMaskIntoConstraints:NO];

        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_textLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_textLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    }

    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];

    self.textLabel.text = nil;
    self.textLabel.textColor = [UIColor blackColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (selected) {
        self.textLabel.textColor = self.selectedTextColor;
    }
    else {
        self.textLabel.textColor = [UIColor blackColor];
    }
}

#pragma mark - DMLSelectorBar

- (void)configureWithComponentDescriptor:(DMLSelectorComponentDescriptor *)componentDescriptor
{
    if (componentDescriptor.selectedTextColor) {
        self.selectedTextColor = componentDescriptor.selectedTextColor;
    }

    self.textLabel.text = componentDescriptor.title;
}

- (void)updateWithComponentDescriptor:(DMLSelectorComponentDescriptor *)componentDescriptor
{
    self.textLabel.text = componentDescriptor.displayTextForSelectedOption;
}

@end
