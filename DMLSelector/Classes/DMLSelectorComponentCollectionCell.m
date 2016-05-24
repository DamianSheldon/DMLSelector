//
//  DMLSelectorComponentCollectionCell.m
//  Pods
//
//  Created by DongMeiliang on 5/24/16.
//
//

#import "DMLSelectorComponentCollectionCell.h"

static CGFloat sImageViewSideLength = 26.0;

@interface DMLSelectorComponentCollectionCell ()

@property (nonatomic) UIImageView *imageView;
@property (nonatomic) UILabel *textLabel;

@end

@implementation DMLSelectorComponentCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.layer.borderWidth = 1.0;
        self.contentView.layer.borderColor = [UIColor colorWithRed:33.0/255.0 green:169.0/255.0 blue:174.0/255.0 alpha:1.0].CGColor;
        self.contentView.layer.cornerRadius = 2.0f;
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.contentView addSubview:_imageView];
        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_textLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        _textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_textLabel];
        
        // Constraints for image view
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:2]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:sImageViewSideLength]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:sImageViewSideLength]];
        
        // Constraints for label
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_textLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:_imageView attribute:NSLayoutAttributeRight multiplier:1.0 constant:4]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_textLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeRight multiplier:1.0 constant:-2]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_textLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:2]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_textLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_imageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-2]];
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.imageView.image = nil;
    self.textLabel.text = nil;
}

- (void)setChecked:(BOOL)checked animated:(BOOL)animated
{
    self.checked = checked;
    if (checked) {
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        self.imageView.image = [UIImage imageNamed:@"DMLSelector.bundle/Checked" inBundle:bundle compatibleWithTraitCollection:nil];
    }
    else {
        self.imageView.image = nil;
    }
}

@end
