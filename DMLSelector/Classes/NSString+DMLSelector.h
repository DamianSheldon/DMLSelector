//
//  NSString+DMLSelector.h
//  Pods
//
//  Created by DongMeiliang on 8/19/16.
//
//

#import <Foundation/Foundation.h>

@interface NSString (DMLSelector)

/// Returns the bounding box size the receiver occupies when drawn in area which max width is screen' width with the given attributes.
- (CGSize)dml_sizeWithAttributes:(NSDictionary <NSString *, id> *)attrs;

@end
