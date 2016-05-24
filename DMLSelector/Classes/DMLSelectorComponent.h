//
//  DMLSelectorComponent.h
//  Pods
//
//  Created by DongMeiliang on 5/17/16.
//
//

#import <Foundation/Foundation.h>

@class DMLSelector;
@class DMLSelectorComponentDescriptor;

@protocol DMLSelectorComponent <NSObject>

@property (nonatomic, weak) DMLSelector *selector;
@property (nonatomic) DMLSelectorComponentDescriptor *componentDescriptor;
@property (nonatomic) NSInteger componentIndex;
@property (nonatomic, readonly) NSDictionary *componentValues;

- (CGFloat)componentHeight;

@optional
- (void)willAppear;
- (void)willDisappear;

@end
