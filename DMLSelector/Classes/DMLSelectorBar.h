//
//  DMLSelectorBar.h
//  Pods
//
//  Created by DongMeiliang on 7/22/16.
//
//

#import <Foundation/Foundation.h>

#import "DMLSelectorComponentDescriptor.h"

@protocol DMLSelectorBar <NSObject>

- (void)configureWithComponentDescriptor:(DMLSelectorComponentDescriptor *)componentDescriptor;

- (void)updateWithComponentDescriptor:(DMLSelectorComponentDescriptor *)componentDescriptor;

@end
