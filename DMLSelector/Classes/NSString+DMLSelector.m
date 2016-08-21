//
//  NSString+DMLSelector.m
//  Pods
//
//  Created by DongMeiliang on 8/19/16.
//
//

#import "NSString+DMLSelector.h"

@implementation NSString (DMLSelector)

- (CGSize)dml_sizeWithAttributes:(NSDictionary <NSString *, id> *)attrs
{
    CGRect fullRect = [UIScreen mainScreen].bounds;

    CGRect stringRect = [self boundingRectWithSize:CGSizeMake(CGRectGetWidth(fullRect), CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil];

    stringRect = CGRectIntegral(stringRect);

    return stringRect.size;
}

@end
