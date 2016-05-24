//
//  DMLSelectorBarCell.m
//  Pods
//
//  Created by DongMeiliang on 5/18/16.
//
//

#import "DMLSelectorBarCell.h"

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
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_textLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_textLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_textLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_textLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.textLabel.text = nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    self.selected = selected;
    
    if (selected) {
        self.textLabel.textColor = self.selectedTextColor;
    }
    else {
        self.textLabel.textColor = [UIColor blackColor];
    }
}

@end
