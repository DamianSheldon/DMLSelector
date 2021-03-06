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


@interface DMLSelector () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

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
            DMLSelectorComponentTypeCollection : [DMLSelectorComponentCollection class]
        }
            mutableCopy];
    });
    return dml_classesForSelectorComponentTypes;
}

+ (NSMutableDictionary *)cellClassesForSelectorBar
{
    static NSMutableDictionary *dml_cellClassesForSelectorBar;

    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        dml_cellClassesForSelectorBar = [@{
            DMLSelectorBarCellIdentifier : [DMLSelectorBarCell class],
            DMLSelectorImageBarCellIdentifier : [DMLSelectorImageBarCell class]
        } mutableCopy];
    });

    return dml_cellClassesForSelectorBar;
}

#pragma mark - Initialization

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectZero];

    if (self) {
        self.backgroundColor = [UIColor dml_grayColor];

        _components = [NSMutableDictionary dictionaryWithCapacity:8];
        _componentConstraints = [NSMutableDictionary dictionaryWithCapacity:8];
        _componentHeightConstraints = [NSMutableDictionary dictionaryWithCapacity:8];

        _maxComponentExpanedHeight = [UIScreen mainScreen].bounds.size.height - 128.0f;

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

        [[[self class] cellClassesForSelectorBar] enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id _Nonnull obj, BOOL *_Nonnull stop) {
            [_selectorBarView registerClass:obj forCellWithReuseIdentifier:key];
        }];

        [self addSubview:_selectorBarView];

        _wrapper = [UIView new];
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
    } else {
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
    DMLSelectorComponentDescriptor *componentDescriptor = [self.dataSource selector:self componentDescriptorForComponentAtIndex:indexPath.row];

    DMLSelectorBarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:componentDescriptor.componentCellIdentifier forIndexPath:indexPath];

    [cell configureWithComponentDescriptor:componentDescriptor];

    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DMLSelectorComponentDescriptor *componentDescriptor = [self.dataSource selector:self componentDescriptorForComponentAtIndex:indexPath.row];

    // Reset previous selected cell's state
    if (self.lastSelectedIndexPath && ([self.lastSelectedIndexPath compare:indexPath] != NSOrderedSame)) {
        DMLSelectorComponentDescriptor *previousComponentDescriptor = [self.dataSource selector:self componentDescriptorForComponentAtIndex:self.lastSelectedIndexPath.row];

        if (previousComponentDescriptor.interactionStyle != DMLSelectorComponentInteractionStyleSelect) {
            DMLSelectorBarCell *previousSelectedCell = (DMLSelectorBarCell *)[collectionView cellForItemAtIndexPath:self.lastSelectedIndexPath];
            [previousSelectedCell setSelected:NO animated:YES];
        }
    }

    DMLSelectorBarCell *cell = (DMLSelectorBarCell *)[collectionView cellForItemAtIndexPath:indexPath];

    switch (componentDescriptor.interactionStyle) {
        case DMLSelectorComponentInteractionStyleSelect: {
            // Collapse previous expanded component
            if (self.lastSelectedIndexPath) {
                NSIndexPath *lastSelectedIndexPath = self.lastSelectedIndexPath;
                self.lastSelectedIndexPath = nil;

                NSLayoutConstraint *componentHeightConstraint = self.componentHeightConstraints[lastSelectedIndexPath];
                self.previousComponentHeight = componentHeightConstraint.constant;
                componentHeightConstraint.constant = 0;

                if ([self.currentComponent respondsToSelector:@selector(willDisappear)]) {
                    [self.currentComponent willDisappear];
                }

                self.currentComponent = nil;

                self.wrapperHeightConstraint.constant = 0;

                [self layoutIfNeeded];

                DMLSelectorBarCell *previousCell = (DMLSelectorBarCell *)[collectionView cellForItemAtIndexPath:lastSelectedIndexPath];

                [previousCell setSelected:NO animated:YES];

                self.expanded = NO;

                [self invalidateIntrinsicContentSize];

                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.12 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    NSArray *previousCompentConstraints = self.componentConstraints[lastSelectedIndexPath];

                    // Remove previous component
                    [self.currentComponent removeFromSuperview];
                    [self.wrapper removeConstraints:previousCompentConstraints];

                    // Restore component's height
                    NSLayoutConstraint *previousComponentHeightConstraint = self.componentHeightConstraints[lastSelectedIndexPath];
                    previousComponentHeightConstraint.constant = self.previousComponentHeight;
                });
            }

            componentDescriptor.selected = !componentDescriptor.isSelected;
            [cell setSelected:componentDescriptor.selected animated:YES];

            if ([self.delegate respondsToSelector:@selector(selector:didSelectComponentAtIndexPath:)]) {
                DMLSelectorIndexPath *idxPath = [DMLSelectorIndexPath indexPathWithComponentIndex:indexPath.row forRow:0 inSection:0];
                [self.delegate selector:self didSelectComponentAtIndexPath:idxPath];
            }

            break;
        }

        case DMLSelectorComponentInteractionStyleExpand: {
            [cell setSelected:cell.selected animated:YES];

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
            BOOL trigger = NO;

            if (self.currentComponent == component) {
                trigger = YES;
            } else if (!self.currentComponent) {
                trigger = YES;
            }

            // Collapse previous component if need
            void (^collapasePreviousComponent)(BOOL deselected) = ^(BOOL deselected) {
                NSLayoutConstraint *componentHeightConstraint = self.componentHeightConstraints[self.lastSelectedIndexPath];
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
                    NSArray *previousCompentConstraints = self.componentConstraints[self.lastSelectedIndexPath];

                    // Remove previous component
                    [self.currentComponent removeFromSuperview];
                    [self.wrapper removeConstraints:previousCompentConstraints];

                    // Restore component's height
                    NSLayoutConstraint *previousComponentHeightConstraint = self.componentHeightConstraints[self.lastSelectedIndexPath];
                    previousComponentHeightConstraint.constant = self.previousComponentHeight;

                    self.lastSelectedIndexPath = nil;
                });
            } else {
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

                    // Remove previous component
                    NSArray *previousCompentConstraints = self.componentConstraints[self.lastSelectedIndexPath];

                    [self.currentComponent removeFromSuperview];
                    [self.wrapper removeConstraints:previousCompentConstraints];

                    // Restore component's height
                    NSLayoutConstraint *previousComponentHeightConstraint = self.componentHeightConstraints[self.lastSelectedIndexPath];
                    previousComponentHeightConstraint.constant = self.previousComponentHeight;

                    self.currentComponent = component;
                    self.lastSelectedIndexPath = indexPath;

                    [self.wrapper addSubview:component];

                    // Constraint
                    NSArray *constraints = self.componentConstraints[indexPath];

                    if (!constraints) {
                        NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:component attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.wrapper attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
                        NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:component attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.wrapper attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
                        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:component attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.wrapper attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
                        NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:component attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.wrapper attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];

                        constraints = @[ leftConstraint, rightConstraint, topConstraint, heightConstraint ];

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
                        } completion:^(BOOL finished) {
                            if ([component respondsToSelector:@selector(willAppear)]) {
                                [component willAppear];
                            }
                        }];
                    }];
                });
            }

            break;
        }
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
        UIView<DMLSelectorComponent> *currentComponent = self.currentComponent;
        self.currentComponent = nil;

        NSLayoutConstraint *componentHeightConstraint = self.componentHeightConstraints[self.lastSelectedIndexPath];
        self.previousComponentHeight = componentHeightConstraint.constant;
        componentHeightConstraint.constant = 0;

        if ([currentComponent respondsToSelector:@selector(willDisappear)]) {
            [currentComponent willDisappear];
        }

        self.wrapperHeightConstraint.constant = 0;

        [self layoutIfNeeded];

        DMLSelectorBarCell *cell = (DMLSelectorBarCell *)[self.selectorBarView cellForItemAtIndexPath:self.lastSelectedIndexPath];

        [cell setSelected:NO animated:NO];

        self.lastSelectedIndexPath = nil;

        self.expanded = NO;
        [self invalidateIntrinsicContentSize];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.12 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSArray *previousCompentConstraints = self.componentConstraints[self.lastSelectedIndexPath];

            [currentComponent removeFromSuperview];
            [self.wrapper removeConstraints:previousCompentConstraints];

            // Restore component's height
            NSLayoutConstraint *previousComponentHeightConstraint = self.componentHeightConstraints[self.lastSelectedIndexPath];
            previousComponentHeightConstraint.constant = self.previousComponentHeight;

            self.previousComponentHeight = 0;
        });
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
}

#pragma mark - Public Methods

- (void)updateComponentAtIndex:(NSUInteger)componentIndex withComponentDescriptor:(DMLSelectorComponentDescriptor *)componentDescriptor
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:componentIndex inSection:0];
    DMLSelectorBarCell *cell = (DMLSelectorBarCell *)[self.selectorBarView cellForItemAtIndexPath:indexPath];

    [cell updateWithComponentDescriptor:componentDescriptor];
}

- (void)collapseComponentWithSelectedIndexPath:(DMLSelectorIndexPath *)indexPath
{
    if (self.currentComponent) {
        UIView<DMLSelectorComponent> *currentComponent = self.currentComponent;

        self.currentComponent = nil;
        self.lastSelectedIndexPath = nil;

        NSIndexPath *indexPathInCollectionView = [NSIndexPath indexPathForRow:indexPath.componentIndex inSection:0];

        NSLayoutConstraint *componentHeightConstraint = self.componentHeightConstraints[indexPathInCollectionView];

        self.previousComponentHeight = componentHeightConstraint.constant;
        componentHeightConstraint.constant = 0;

        if ([currentComponent respondsToSelector:@selector(willDisappear)]) {
            [currentComponent willDisappear];
        }

        self.wrapperHeightConstraint.constant = 0;

        [self layoutIfNeeded];

        self.expanded = NO;

        [self invalidateIntrinsicContentSize];

        // Reset selector bar cell's state
        DMLSelectorBarCell *cell = (DMLSelectorBarCell *)[self.selectorBarView cellForItemAtIndexPath:indexPathInCollectionView];
        [cell setSelected:NO animated:YES];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.12 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSArray *previousCompentConstraints = self.componentConstraints[indexPathInCollectionView];

            [currentComponent removeFromSuperview];
            [self.wrapper removeConstraints:previousCompentConstraints];

            // Restore component's height
            NSLayoutConstraint *previousComponentHeightConstraint = self.componentHeightConstraints[indexPathInCollectionView];
            previousComponentHeightConstraint.constant = self.previousComponentHeight;

            self.previousComponentHeight = 0;
        });

        if ([self.delegate respondsToSelector:@selector(selector:didSelectComponentAtIndexPath:)]) {
            [self.delegate selector:self didSelectComponentAtIndexPath:indexPath];
        }
    }
}

- (void)reloadData
{
    [self.selectorBarView reloadData];
}

#pragma mark - Getter

- (NSDictionary *)selectorValues
{
    NSMutableDictionary *values = [NSMutableDictionary dictionaryWithCapacity:8];

    NSUInteger componentCount = [self.dataSource numberOfComponentsInSelector:self];

    for (NSUInteger i = 0; i < componentCount; i++) {
        DMLSelectorComponentDescriptor *componentDescriptor = [self.dataSource selector:self componentDescriptorForComponentAtIndex:i];

        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];

        switch (componentDescriptor.interactionStyle) {
            case DMLSelectorComponentInteractionStyleSelect: {
                [values setObject:@(componentDescriptor.isSelected) forKey:componentDescriptor.title];
                break;
            }

            case DMLSelectorComponentInteractionStyleExpand: {
                UIView<DMLSelectorComponent> *component = self.components[indexPath];
                NSDictionary *v = component.componentValues;

                if (v) {
                    [v enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id _Nonnull obj, BOOL *_Nonnull stop) {
                        if (obj) {
                            [values setObject:obj forKey:key];
                        }
                    }];
                }

                break;
            }
        }
    }

    return [values copy];
}

@end
