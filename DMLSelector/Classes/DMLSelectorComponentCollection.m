//
//  DMLSelectorCollection.m
//  Pods
//
//  Created by DongMeiliang on 5/17/16.
//
//

#import "DMLSelectorComponentCollection.h"
#import "DMLSelectorComponentDescriptor.h"
#import "DMLSelectorSection.h"
#import "DMLSelector.h"
#import "DMLSelectorCollectionSectionHeader.h"
#import "DMLSelectorComponentDefaultCell.h"
#import "DMLSelectorComponentSubtitleCell.h"
#import "DMLSelectorComponentCheckboxCell.h"

static NSString *sCollectionCellIdentifier = @"sCollectionCellIdentifier";
static NSString *sCollectionSectionHeaderIdentifier = @"sCollectionSectionHeaderIdentifier";

@interface DMLSelectorComponentCollection () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) UIButton *confirmButton;
@property (nonatomic) UIButton *resetButton;
@property (nonatomic) NSArray *dynamicConstraints;
@property (nonatomic) BOOL installedConstraint;
@property (nonatomic) NSMutableDictionary *values;
@property (nonatomic) NSMutableDictionary *cellsForCaculate;

@end

@implementation DMLSelectorComponentCollection

@synthesize componentDescriptor = _componentDescriptor;
@synthesize selector = _selector;
@synthesize componentIndex = _componentIndex;

+ (NSMutableDictionary *)cellClassesForCollectionView
{
    static NSMutableDictionary *cellClasses = nil;

    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
            cellClasses = @{
                DMLSelectorComponentDefaultCellIdentifier : [DMLSelectorComponentDefaultCell class],
                DMLSelectorComponentSubtitleCellIdentifier : [DMLSelectorComponentSubtitleCell class],
                DMLSelectorComponentCheckboxCellIdentifier : [DMLSelectorComponentCheckboxCell class]
            }.mutableCopy;
        });

    return cellClasses;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        _values = [NSMutableDictionary dictionaryWithCapacity:8];

        _cellsForCaculate = [NSMutableDictionary dictionaryWithCapacity:8];

        // View hiearchy
        UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[DMLSelectorCollectionSectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sCollectionSectionHeaderIdentifier];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView setTranslatesAutoresizingMaskIntoConstraints:NO];

        NSMutableDictionary *cellClasses = [[self class] cellClassesForCollectionView];
        [cellClasses enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id _Nonnull obj, BOOL *_Nonnull stop) {
            [_collectionView registerClass:obj forCellWithReuseIdentifier:key];
        }];

        _resetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _resetButton.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        _resetButton.contentEdgeInsets = UIEdgeInsetsMake(8, 0, 8, 0);
        _resetButton.layer.borderWidth = 1.0f;
        _resetButton.layer.cornerRadius = 2.0f;
        [_resetButton setTitle:@"重置" forState:UIControlStateNormal];
        [_resetButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_resetButton addTarget:self action:@selector(reset) forControlEvents:UIControlEventTouchUpInside];

        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        _confirmButton.contentEdgeInsets = UIEdgeInsetsMake(8, 0, 8, 0);
        _confirmButton.layer.cornerRadius = 2.0f;
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_confirmButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_confirmButton addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];

        // Configure constraints
        NSLayoutConstraint *collectionLeftConstraint = [NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        NSLayoutConstraint *collectionRightConstraint = [NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
        NSLayoutConstraint *collectionTopConstraint = [NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        NSLayoutConstraint *collectionBottomConstraint = [NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_confirmButton attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];

        NSLayoutConstraint *resetButtonLeftConstraint = [NSLayoutConstraint constraintWithItem:_resetButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:10];

        NSLayoutConstraint *resetButtonRightConstraint = [NSLayoutConstraint constraintWithItem:_resetButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:_confirmButton attribute:NSLayoutAttributeLeft multiplier:1.0 constant:-8];

        NSLayoutConstraint *resetButtonWidthConstraint = [NSLayoutConstraint constraintWithItem:_resetButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_confirmButton attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];

        NSLayoutConstraint *resetButtonCenterYConstraint = [NSLayoutConstraint constraintWithItem:_resetButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:_confirmButton attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];

        NSLayoutConstraint *confirmButtonRightConsraint = [NSLayoutConstraint constraintWithItem:_confirmButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:-10];
        NSLayoutConstraint *confirmButtonBottomConstraint = [NSLayoutConstraint constraintWithItem:_confirmButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-10];

        confirmButtonBottomConstraint.priority = UILayoutPriorityRequired - 1;

        self.dynamicConstraints = @[collectionLeftConstraint, collectionRightConstraint, collectionTopConstraint, collectionBottomConstraint, confirmButtonRightConsraint, confirmButtonBottomConstraint, resetButtonLeftConstraint, resetButtonRightConstraint, resetButtonWidthConstraint, resetButtonCenterYConstraint];
    }

    return self;
}

- (void)updateConstraints
{
    if (self.confirmButton.superview) {
        if (!self.installedConstraint) {
            self.installedConstraint = YES;
            [self addConstraints:self.dynamicConstraints];
        }
    }
    else {
        if (self.installedConstraint) {
            self.installedConstraint = NO;

            [self removeConstraints:self.dynamicConstraints];
        }
    }

    [super updateConstraints];
}

#pragma mark - DMLSelectorComponent

- (CGFloat)componentHeight
{
    return (self.componentDescriptor.sections.count + 1) * 60;
}

- (void)willAppear
{
    [self.resetButton setTitleColor:self.componentDescriptor.textColor forState:UIControlStateNormal];
    self.resetButton.layer.borderColor = self.componentDescriptor.textColor.CGColor;

    self.confirmButton.backgroundColor = self.componentDescriptor.selectedTextColor;

    [self addSubview:self.collectionView];
    [self addSubview:self.confirmButton];
    [self addSubview:self.resetButton];

    [self setNeedsUpdateConstraints];
}

- (void)willDisappear
{
    [self.collectionView removeFromSuperview];
    [self.confirmButton removeFromSuperview];
    [self.resetButton removeFromSuperview];

    [self setNeedsUpdateConstraints];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.componentDescriptor.sections.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    DMLSelectorSection *option = self.componentDescriptor.sections[section];

    return option.rowTexts.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DMLSelectorSection *section = self.componentDescriptor.sections[indexPath.section];

    DMLSelectorCollectionCellDescriptor *cellDescriptor = section.rowTexts[indexPath.row];

    DMLSelectorComponentDefaultCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellDescriptor.cellIdentifier forIndexPath:indexPath];

    [cell configureWithCellDescriptor:cellDescriptor];

    if (self.values.count > 0) {
        id value = self.values[section.sectionText];

        if ([value isKindOfClass:[NSString class]]) {
            NSString *stringValue = (NSString *)value;

            if ([stringValue isEqualToString:cell.textLabel.text]) {
                [cell setChecked:YES animated:NO];
            }
        }
        else if ([value isKindOfClass:[NSArray class]]) {
            NSArray *listOfValue = (NSArray *)value;

            [listOfValue enumerateObjectsUsingBlock:^(NSString *_Nonnull string, NSUInteger idx, BOOL *_Nonnull stop) {
                if ([string isEqualToString:cell.textLabel.text]) {
                    [cell setChecked:YES animated:NO];
                }
            }];
        }
    }

    return cell;
}

- (UICollectionReusableView *)  collectionView                      :(UICollectionView *)collectionView
                                viewForSupplementaryElementOfKind   :(NSString *)kind
                                atIndexPath                         :(NSIndexPath *)indexPath
{
    DMLSelectorCollectionSectionHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sCollectionSectionHeaderIdentifier forIndexPath:indexPath];

    DMLSelectorSection *option = self.componentDescriptor.sections[indexPath.section];

    header.textLabel.text = option.sectionText;

    return header;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)  collectionView                  :(UICollectionView *)collectionView
            layout                          :(UICollectionViewLayout *)collectionViewLayout
            referenceSizeForHeaderInSection :(NSInteger)section
{
    return CGSizeMake(0, 30.0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size = CGSizeZero;

    DMLSelectorSection *section = self.componentDescriptor.sections[indexPath.section];

    DMLSelectorCollectionCellDescriptor *cellDescriptor = section.rowTexts[indexPath.row];

    DMLSelectorComponentDefaultCell *cell = self.cellsForCaculate[cellDescriptor.cellIdentifier];

    if (!cell) {
        NSMutableDictionary *cellClasses = [[self class] cellClassesForCollectionView];
        Class cellClass = cellClasses[cellDescriptor.cellIdentifier];

        cell = [[cellClass alloc] initWithFrame:CGRectZero];

        [self.cellsForCaculate setObject:cell forKey:cellDescriptor.cellIdentifier];
    }

    [cell configureWithCellDescriptor:cellDescriptor];

    size = cell.intrinsicContentSize;

    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DMLSelectorComponentDefaultCell *cell = [collectionView cellForItemAtIndexPath:indexPath];

    [cell setChecked:!cell.isChecked animated:YES];

    DMLSelectorSection *option = self.componentDescriptor.sections[indexPath.section];

    DMLSelectorCollectionCellDescriptor *cellDescriptor = option.rowTexts[indexPath.row];

    NSString *key = option.sectionText;
    NSString *value = cellDescriptor.text;

    if (option.exclusiveSelect) {
        // Section is exclusive selection
        for (NSUInteger i = 0; i < option.rowTexts.count; i++) {
            if (i != indexPath.row) {
                NSIndexPath *idxPath = [NSIndexPath indexPathForRow:i inSection:indexPath.section];
                DMLSelectorComponentCheckboxCell *cell = [collectionView cellForItemAtIndexPath:idxPath];
                [cell setChecked:NO animated:YES];
            }
        }

        // Update select value
        if (cell.isChecked) {
            [self.values setObject:value forKey:key];
        }
        else {
            [self.values removeObjectForKey:key];
        }
    }
    else {
        // Update select value
        if (cell.isChecked) {
            // Add
            NSMutableArray *storeValues = self.values[key];

            if (storeValues) {
                [storeValues addObject:value];

                [self.values setObject:storeValues forKey:key];
            }
            else {
                NSMutableArray *valueArray = [NSMutableArray arrayWithCapacity:option.rowTexts.count];
                [valueArray addObject:value];
                [self.values setObject:valueArray forKey:key];
            }
        }
        else {
            // Remove
            NSMutableArray *storeValues = self.values[key];
            NSAssert(storeValues != nil, @"Store value must not be nil!");

            if (storeValues.count > 1) {
                NSArray *enumerateArray = storeValues.copy;

                [enumerateArray enumerateObjectsUsingBlock:^(NSString *_Nonnull string, NSUInteger idx, BOOL *_Nonnull stop) {
                    if ([string isEqualToString:value]) {
                        [storeValues removeObjectAtIndex:idx];
                    }
                }];

                [self.values setObject:storeValues forKey:key];
            }
            else {
                [self.values removeObjectForKey:key];
            }
        }
    }
}

#pragma mark - Actions

- (void)confirm
{
    // Collapse component
    DMLSelectorIndexPath *indexPath = [DMLSelectorIndexPath indexPathWithComponentIndex:self.componentIndex forRow:0 inSection:0];

    [self.selector collapseComponentWithSelectedIndexPath:indexPath];
}

- (void)reset
{
    if (self.values.count > 0) {
        NSInteger numberOfSection = self.componentDescriptor.sections.count;

        for (NSUInteger i = 0; i < numberOfSection; ++i) {
            DMLSelectorSection *section = self.componentDescriptor.sections[i];

            for (NSUInteger j = 0; j < section.rowTexts.count; ++j) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:j inSection:i];

                DMLSelectorComponentDefaultCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];

                [cell setChecked:NO animated:NO];
            }
        }

        [self.values removeAllObjects];
    }
}

#pragma mark - Getter

- (NSDictionary *)componentValues
{
    return self.values;
}

@end
