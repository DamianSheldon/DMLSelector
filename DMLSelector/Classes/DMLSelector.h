//
//  DMLSelector.h
//  Pods
//
//  Created by DongMeiliang on 5/17/16.
//
//

#import <UIKit/UIKit.h>

#import "UIColor+DMLSelector.h"

#import "DMLSelectorComponentDescriptor.h"
#import "DMLSelectorComponentSingleTable.h"
#import "DMLSelectorComponentDoubleTable.h"
#import "DMLSelectorComponentCollection.h"
#import "DMLSelectorSection.h"
#import "DMLSelectorBarCell.h"
#import "DMLSelectorImageBarCell.h"
#import "DMLSelectorIndexPath.h"
#import "DMLSelectorCollectionCellDescriptor.h"

extern NSString *const DMLSelectorComponentTypeSingleTable;
extern NSString *const DMLSelectorComponentTypeDoubleTable;
extern NSString *const DMLSelectorComponentTypeCollection;

@protocol DMLSelectorDataSource;
@protocol DMLSelectorDelegate;

@interface DMLSelector : UIView

+ (NSMutableDictionary *)classesForSelectorComponentTypes;

@property (nonatomic, weak) id <DMLSelectorDataSource> dataSource;
@property (nonatomic, weak) id <DMLSelectorDelegate> delegate;

@property (nonatomic) CGFloat maxComponentExpanedHeight; // Default is  Screen.size.height - 128

@property (nonatomic, readonly) NSDictionary *selectorValues;

- (void)updateComponentAtIndex:(NSUInteger)componentIndex withComponentDescriptor:(DMLSelectorComponentDescriptor *)componentDescriptor;

- (void)collapseComponentWithSelectedIndexPath:(DMLSelectorIndexPath *)indexPath;

- (void)reloadData;

@end

@protocol DMLSelectorDataSource <NSObject>

@required

- (NSUInteger)numberOfComponentsInSelector:(DMLSelector *)selector;

- (DMLSelectorComponentDescriptor *)selector:(DMLSelector *)selector componentDescriptorForComponentAtIndex:(NSUInteger)index;

@end

@protocol DMLSelectorDelegate <NSObject>

@optional
- (void)selector:(DMLSelector *)selector didSelectComponentAtIndexPath:(DMLSelectorIndexPath *)indexPath;

@end
