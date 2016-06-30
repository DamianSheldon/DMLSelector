//
//  DMLSelector.m
//  Pods
//
//  Created by DongMeiliang on 5/17/16.
//
//

#import "DMLSelector.h"

NSString *const DMLSelectorComponentTypeSingleTable = @"DMLSelectorComponentTypeSingleTable";
NSString *const DMLSelectorComponentTypeDoubleTable = @"DMLSelectorComponentTypeDoubleTable";
NSString *const DMLSelectorComponentTypeCollection = @"DMLSelectorComponentTypeCollection";

static CGFloat sIntrinsicContentSizeCollapseHeight = 44.0f;

static CGFloat sComponentMinHeight = 88.0f;

static NSString *const sSelectorBarCellIdentifier = @"sSelectorBarCellIdentifier";

@interface DMLSelector ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, getter=isExpanded) BOOL expanded;
@property (nonatomic) UICollectionView *selectorBarView;
@property (nonatomic) UIView *wrapper;
@property (nonatomic) NSLayoutConstraint *wrapperHeightConstraint;

@property (nonatomic) NSMutableDictionary *components;
@property (nonatomic) NSMutableDictionary *componentConstraints;
@property (nonatomic) UIView<DMLSelectorComponent> *currentComponent;
@property (nonatomic) CGFloat previousComponentHeight;
@property (nonatomic) NSMutableDictionary *componentHeightConstraints;
@property (nonatomic, copy) NSIndexPath *lastSelectedIndexPath;
@end

@implementation DMLSelector

#pragma mark - Class Methods

+ (NSMutableDictionary *)classesForSelectorComponentTypes
{
    static NSMutableDictionary *dml_classesForSelectorComponentTypes;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dml_classesForSelectorComponentTypes = [@{
                                         DMLSelectorComponentTypeSingleTable : [DMLSelectorComponentSingleTable class],
                                         DMLSelectorComponentTypeDoubleTable : [DMLSelectorComponentDoubleTable class],
                                         DMLSelectorComponentTypeCollection : [DMLSelectorComponentCollection class]}
                                       mutableCopy];
    });
    return dml_classesForSelectorComponentTypes;
}

#pragma mark - Initialization

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.backgroundColor = [[UIColor alloc] initWithWhite:1 alpha:0.5];
        
        _components = [NSMutableDictionary dictionaryWithCapacity:8];
        _componentConstraints = [NSMutableDictionary dictionaryWithCapacity:8];
        _componentHeightConstraints = [NSMutableDictionary dictionaryWithCapacity:8];
        
        _maxComponentExpanedHeight = 272.0f;
        
        _currentComponent = nil;
        
        UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 0;
        
        _selectorBarView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _selectorBarView.dataSource = self;
        _selectorBarView.delegate = self;
        _selectorBarView.scrollEnabled = NO;
        _selectorBarView.showsHorizontalScrollIndicator = NO;
        _selectorBarView.showsVerticalScrollIndicator = NO;
        _selectorBarView.backgroundColor = [UIColor whiteColor];
        [_selectorBarView registerClass:[DMLSelectorBarCell class] forCellWithReuseIdentifier:sSelectorBarCellIdentifier];
        [self addSubview:_selectorBarView];
        
        _wrapper = [UIView new];
        _wrapper.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_wrapper];
        
        // Configure constraint
        [_selectorBarView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_selectorBarView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_selectorBarView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_selectorBarView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_selectorBarView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:sIntrinsicContentSizeCollapseHeight]];
        
        [_wrapper setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_wrapper attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_wrapper attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_wrapper attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_selectorBarView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
        
        _wrapperHeightConstraint = [NSLayoutConstraint constraintWithItem:_wrapper attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:0];
        
        [self addConstraint:_wrapperHeightConstraint];
    }
    return self;
}

#pragma mark - Override

- (CGSize)intrinsicContentSize
{
    if (self.expanded) {
        CGFloat height = CGRectGetMaxY(self.superview.frame) - CGRectGetMinY(self.frame);
        height = MAX(sIntrinsicContentSizeCollapseHeight, height);
        
        return CGSizeMake(UIViewNoIntrinsicMetric, height);
    }
    else {
        return CGSizeMake(UIViewNoIntrinsicMetric, sIntrinsicContentSizeCollapseHeight);
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataSource numberOfComponentsInSelector:self];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DMLSelectorBarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:sSelectorBarCellIdentifier forIndexPath:indexPath];
    
    DMLSelectorComponentDescriptor *componentDescriptor = [self.dataSource selector:self componentDescriptorForOptionAtIndex:indexPath.row];
    
    cell.notDisplayArrow = componentDescriptor.notDisplayArrow;
    
    if (componentDescriptor.selectedTextColor) {
        cell.selectedTextColor = componentDescriptor.selectedTextColor;
    }
    
    cell.textLabel.text = componentDescriptor.title;
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DMLSelectorBarCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [cell setSelected:YES animated:YES];
    
    // Reset previous selected cell's state
    NSArray *visibleCells = [collectionView visibleCells];
    [visibleCells enumerateObjectsUsingBlock:^(DMLSelectorBarCell *  _Nonnull barCell, NSUInteger idx, BOOL * _Nonnull stop) {
        if (barCell != cell) {
            [barCell setSelected:NO animated:YES];
        }
    }];
    
    self.lastSelectedIndexPath = indexPath;
    
    DMLSelectorComponentDescriptor *componentDescriptor = [self.dataSource selector:self componentDescriptorForOptionAtIndex:indexPath.row];

    UIView<DMLSelectorComponent> *component = self.components[indexPath];
    if (!component) {
        NSMutableDictionary *classes = [[self class] classesForSelectorComponentTypes];
        
        Class class = classes[componentDescriptor.componentType];
        component = [[class alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 0)];
        [component setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        component.selector = self;
        component.componentDescriptor = componentDescriptor;
        component.componentIndex = indexPath.row;
        
        [self.components setObject:component forKey:indexPath];
    }
    
    CGFloat height = [component componentHeight];
    height = MAX(sComponentMinHeight, height);
    height = MIN(height, self.maxComponentExpanedHeight);
    
    // Trigger invaild intrinsic content size
    BOOL trigger;

    if (self.currentComponent == component) {
        trigger = YES;
    }
    else if (!self.currentComponent) {
        trigger = YES;
    }
    
    // Collapse previous component if need
    void (^collapasePreviousComponent)(BOOL deselected) = ^(BOOL deselected) {
        NSLayoutConstraint *componentHeightConstraint = self.componentHeightConstraints[indexPath];
        self.previousComponentHeight = componentHeightConstraint.constant;
        componentHeightConstraint.constant = 0;
        
        if ([self.currentComponent respondsToSelector:@selector(willDisappear)]) {
            
            [self.currentComponent willDisappear];
        }
        
        self.currentComponent = nil;
        
        self.wrapperHeightConstraint.constant = 0;
        
        [self layoutIfNeeded];
        
        if (deselected) {
            [cell setSelected:NO animated:NO];
        }
        
        self.expanded = NO;
        if (trigger) {
            [self invalidateIntrinsicContentSize];
        }
    };
    
    if (self.currentComponent == component) {
        // Collapse already selected component
        collapasePreviousComponent(YES);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.12 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSArray *previousCompentConstraints = self.componentConstraints[indexPath];
            
            [self.currentComponent removeFromSuperview];
            [self.wrapper removeConstraints:previousCompentConstraints];
            
            // Restore component's height
            NSLayoutConstraint *previousComponentHeightConstraint = self.componentHeightConstraints[indexPath];
            previousComponentHeightConstraint.constant = self.previousComponentHeight;
            
            self.currentComponent = nil;
        });
    }
    else {
        // Collapase previous component
        if (self.currentComponent) {
            collapasePreviousComponent(NO);
        }
        
        // Expand current select component
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.12 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            self.expanded = YES;
            if (trigger) {
                [self invalidateIntrinsicContentSize];
            }

            NSArray *previousCompentConstraints = self.componentConstraints[indexPath];

            [self.currentComponent removeFromSuperview];
            [self.wrapper removeConstraints:previousCompentConstraints];
            
            // Restore component's height
            NSLayoutConstraint *previousComponentHeightConstraint = self.componentHeightConstraints[indexPath];
            previousComponentHeightConstraint.constant = self.previousComponentHeight;
            
            self.currentComponent = component;
    
            [self.wrapper addSubview:component];
    
            // Constraint
            NSArray *constraints = self.componentConstraints[indexPath];
            if (!constraints) {
                NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:component attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.wrapper attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
                NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:component attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.wrapper attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
                NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:component attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.wrapper attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
                NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:component attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.wrapper attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
    
                constraints = @[leftConstraint, rightConstraint, topConstraint, heightConstraint];
                
                [self.componentConstraints setObject:constraints forKey:indexPath];
                [self.componentHeightConstraints setObject:heightConstraint forKey:indexPath];
            }
    
            [self.wrapper addConstraints:constraints];
            
            
            [UIView animateWithDuration:0.2 animations:^{
                [self layoutIfNeeded];
            } completion:^(BOOL finished) {
                self.wrapperHeightConstraint.constant = height;
                
                [UIView animateWithDuration:0.3 delay:0.12 options:UIViewAnimationOptionCurveLinear animations:^{
                    [self layoutIfNeeded];
                } completion:^(BOOL finished){
                    if ([component respondsToSelector:@selector(willAppear)]) {
                        [component willAppear];
                    }
                }];
            }];
        });
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect fullScreenRect = [UIScreen mainScreen].bounds;
    NSInteger numberOfItems = [self collectionView:collectionView numberOfItemsInSection:0];
    
    fullScreenRect.size.width = CGRectGetWidth(fullScreenRect) / numberOfItems;
    
    return CGSizeMake(CGRectGetWidth(fullScreenRect), sIntrinsicContentSizeCollapseHeight);
}

#pragma mark - Responding to Touch Events

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.currentComponent) {
        self.currentComponent = nil;
        
        NSLayoutConstraint *componentHeightConstraint = self.componentHeightConstraints[self.lastSelectedIndexPath];
        self.previousComponentHeight = componentHeightConstraint.constant;
        componentHeightConstraint.constant = 0;
        
        if ([self.currentComponent respondsToSelector:@selector(willDisappear)]) {
            
            [self.currentComponent willDisappear];
        }
        
        self.currentComponent = nil;
        
        self.wrapperHeightConstraint.constant = 0;
        
        [self layoutIfNeeded];
        
        DMLSelectorBarCell *cell = [self.selectorBarView cellForItemAtIndexPath:self.lastSelectedIndexPath];
        
        [cell setSelected:NO animated:NO];

        
        self.expanded = NO;
        [self invalidateIntrinsicContentSize];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.12 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSArray *previousCompentConstraints = self.componentConstraints[self.lastSelectedIndexPath];
            
            [self.currentComponent removeFromSuperview];
            [self.wrapper removeConstraints:previousCompentConstraints];
            
            // Restore component's height
            NSLayoutConstraint *previousComponentHeightConstraint = self.componentHeightConstraints[self.lastSelectedIndexPath];
            previousComponentHeightConstraint.constant = self.previousComponentHeight;
        });
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{ }

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{ }

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{ }

#pragma mark - Public Methods

- (void)updateComponentAtIndex:(NSUInteger)index withTitle:(NSString *)title indicatorDirection:(DMLSelectorComponentSelectionIndicatorDirection)direction
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    DMLSelectorBarCell *cell = [self.selectorBarView cellForItemAtIndexPath:indexPath];
    cell.textLabel.text = title;
    
    switch (direction) {
        case DMLSelectorComponentSelectionIndicatorDirectionUp:
            [cell updateIndicatorDirection:DMLSelectorBarCellIndicatorDirectionUp];
            break;
            
        case DMLSelectorComponentSelectionIndicatorDirectionDown:
            [cell updateIndicatorDirection:DMLSelectorBarCellIndicatorDirectionDown];
            break;
    }
}

- (void)collapseComponentWithSelectedIndexPath:(DMLSelectorIndexPath *)indexPath
{
    NSIndexPath *indexPathInCollectionView = [NSIndexPath indexPathForRow:indexPath.componentIndex inSection:0];
    
    NSLayoutConstraint *componentHeightConstraint = self.componentHeightConstraints[indexPathInCollectionView];
    self.previousComponentHeight = componentHeightConstraint.constant;
    componentHeightConstraint.constant = 0;
    
    self.currentComponent = nil;
    
    self.wrapperHeightConstraint.constant = 0;
    
    [self layoutIfNeeded];
    
    self.expanded = NO;
    
    [self invalidateIntrinsicContentSize];
    
    // Reset selector bar cell's state
    DMLSelectorBarCell *cell = [self.selectorBarView cellForItemAtIndexPath:indexPathInCollectionView];
    [cell setSelected:NO animated:YES];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.12 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *previousCompentConstraints = self.componentConstraints[indexPathInCollectionView];
        
        [self.currentComponent removeFromSuperview];
        [self.wrapper removeConstraints:previousCompentConstraints];
        
        // Restore component's height
        NSLayoutConstraint *previousComponentHeightConstraint = self.componentHeightConstraints[indexPathInCollectionView];
        previousComponentHeightConstraint.constant = self.previousComponentHeight;
        
        self.previousComponentHeight = 0;
        
        self.currentComponent = nil;
    });
    
    if ([self.delegate respondsToSelector:@selector(selector:didSelectOptionAtIndexPath:)]) {
        [self.delegate selector:self didSelectOptionAtIndexPath:indexPath];
    }
}

#pragma mark - Getter

- (NSDictionary *)selectorValues
{
    NSMutableDictionary *values = [NSMutableDictionary dictionaryWithCapacity:8];
    
    [self.components enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        UIView <DMLSelectorComponent> *component = obj;
        
        NSDictionary *dict = component.componentValues;
        [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [values setObject:obj forKey:key];
        }];
    }];
    
    return [values copy];
}

@end
