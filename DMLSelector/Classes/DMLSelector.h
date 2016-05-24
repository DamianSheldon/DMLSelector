//
//  DMLSelector.h
//  Pods
//
//  Created by DongMeiliang on 5/17/16.
//
//

#import <UIKit/UIKit.h>

#import "DMLSelectorComponentDescriptor.h"
#import "DMLSelectorComponentSingleTable.h"
#import "DMLSelectorComponentDoubleTable.h"
#import "DMLSelectorComponentCollection.h"
#import "DMLSelectorOption.h"
#import "DMLSelectorBarCell.h"
#import "DMLSelectorIndexPath.h"

extern NSString *const DMLSelectorComponentTypeSingleTable;
extern NSString *const DMLSelectorComponentTypeDoubleTable;
extern NSString *const DMLSelectorComponentTypeCollection;

@protocol DMLSelectorDataSource;
@protocol DMLSelectorDelegate;

@interface DMLSelector : UIView

+ (NSMutableDictionary *)classesForSelectorComponentTypes;

@property (nonatomic, weak) id<DMLSelectorDataSource> dataSource;
@property (nonatomic, weak) id<DMLSelectorDelegate> delegate;

@property (nonatomic) CGFloat maxComponentExpanedHeight;// Default is 272 = (480 - 128)

@property (nonatomic, readonly) NSDictionary *selectorValues;

- (void)updateComponentAtIndex:(NSUInteger)index withTitle:(NSString *)title indicatorDirection:(DMLSelectorComponentSelectionIndicatorDirection)direction;

- (void)collapseComponentWithSelectedIndexPath:(DMLSelectorIndexPath *)indexPath;

@end


@protocol DMLSelectorDataSource <NSObject>

@required

- (NSUInteger)numberOfComponentsInSelector:(DMLSelector *)selector;

- (DMLSelectorComponentDescriptor *)selector:(DMLSelector *)selector componentDescriptorForOptionAtIndex:(NSUInteger)index;

@end

@protocol DMLSelectorDelegate <NSObject>

@optional
- (void)selector:(DMLSelector *)selector didSelectOptionAtIndexPath:(DMLSelectorIndexPath *)indexPath;

@end