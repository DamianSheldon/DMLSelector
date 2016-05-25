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
@property (nonatomic) CAShapeLayer *indicatorLayer;
@property (nonatomic) DMLSelectorBarCellIndicatorDirection direction;

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
        _direction = DMLSelectorBarCellIndicatorDirectionDown;
        
        // Constraints
        [_textLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_textLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_textLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
        
        CAShapeLayer *layer = [CAShapeLayer new];
        
        UIBezierPath *path = [UIBezierPath new];
        [path moveToPoint:CGPointMake(0, 0)];
        [path addLineToPoint:CGPointMake(8, 0)];
        [path addLineToPoint:CGPointMake(4, 5)];
        [path closePath];
        
        layer.path = path.CGPath;
        layer.lineWidth = 0.8;
        layer.fillColor = [UIColor lightGrayColor].CGColor;
        [self.layer addSublayer:layer];
        
        _indicatorLayer = layer;
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.textLabel.text = nil;
    self.textLabel.textColor = [UIColor blackColor];
    
    self.indicatorLayer.fillColor = [UIColor lightGrayColor].CGColor;
}

- (void)layoutSubviews
{
    CGRect stringRect = [self.textLabel.text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.textLabel.font} context:nil];
    stringRect = CGRectIntegral(stringRect);
    
    CGPoint indicatorPosition;
    
    switch (self.direction) {
        case DMLSelectorBarCellIndicatorDirectionUp: {
            self.indicatorLayer.transform = CATransform3DRotate(self.indicatorLayer.transform, M_PI, 0, 0, 1);
            
            indicatorPosition = CGPointMake(0.5 * (CGRectGetWidth(self.frame) + CGRectGetWidth(stringRect)) + 10, 0.5 * CGRectGetHeight(self.frame));
            
            break;
        }
            
        case DMLSelectorBarCellIndicatorDirectionDown: {
            self.indicatorLayer.transform = CATransform3DIdentity;
            indicatorPosition = CGPointMake(0.5 * (CGRectGetWidth(self.frame) + CGRectGetWidth(stringRect)) + 2, 0.5 * CGRectGetHeight(self.frame) - 2.5);

            break;
        }
    }
    
    self.indicatorLayer.position = indicatorPosition;
    
    /*
     struct CATransform3D
     {
     CGFloat m11, m12, m13, m14;
     CGFloat m21, m22, m23, m24;
     CGFloat m31, m32, m33, m34;
     CGFloat m41, m42, m43, m44;
     };
     
     typedef struct CATransform3D CATransform3D;
     */
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    self.selected = selected;
    
    if (selected) {
        self.textLabel.textColor = self.selectedTextColor;
        self.indicatorLayer.fillColor = self.selectedTextColor.CGColor;
    }
    else {
        self.textLabel.textColor = [UIColor blackColor];
        self.indicatorLayer.fillColor = [UIColor lightGrayColor].CGColor;
    }
}

- (void)updateIndicatorDirection:(DMLSelectorBarCellIndicatorDirection)direction
{
    if (direction != self.direction) {
        self.direction = direction;
    }
}

@end
