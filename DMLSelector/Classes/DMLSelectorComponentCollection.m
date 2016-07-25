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
#import "DMLSelectorComponentCollectionCell.h"

static NSString *sCollectionCellIdentifier = @"sCollectionCellIdentifier";
static NSString *sCollectionSectionHeaderIdentifier = @"sCollectionSectionHeaderIdentifier";

@interface DMLSelectorComponentCollection () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic) UICollectionView      *collectionView;
@property (nonatomic) UIButton              *confirmButton;
@property (nonatomic) NSArray               *dynamicConstraints;
@property (nonatomic) BOOL                  setupConstraint;
@property (nonatomic) NSMutableDictionary   *values;

@end

@implementation DMLSelectorComponentCollection

@synthesize componentDescriptor = _componentDescriptor;
@synthesize selector = _selector;
@synthesize componentIndex = _componentIndex;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        self.backgroundColor = [UIColor whiteColor];

        _values = [NSMutableDictionary dictionaryWithCapacity:8];

        // View hiearchy
        UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[DMLSelectorComponentCollectionCell class] forCellWithReuseIdentifier:sCollectionCellIdentifier];
        [_collectionView registerClass:[DMLSelectorCollectionSectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sCollectionSectionHeaderIdentifier];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView setTranslatesAutoresizingMaskIntoConstraints:NO];

        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _confirmButton.backgroundColor = [UIColor colorWithRed:101 / 255.0 green:205 / 255.0 blue:214 / 255.0 alpha:1.0];
        _confirmButton.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        _confirmButton.contentEdgeInsets = UIEdgeInsetsMake(2, 8, 2, 8);
        _confirmButton.layer.cornerRadius = 4.0f;
        [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
        [_confirmButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_confirmButton addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];

        // Configure constraints
        NSLayoutConstraint  *collectionLeftConstraint = [NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
        NSLayoutConstraint  *collectionRightConstraint = [NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
        NSLayoutConstraint  *collectionTopConstraint = [NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
        NSLayoutConstraint  *collectionBottomConstraint = [NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_confirmButton attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];

        NSLayoutConstraint  *confirmButtonRightConsraint = [NSLayoutConstraint constraintWithItem:_confirmButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:-10];
        NSLayoutConstraint  *confirmButtonBottomConstraint = [NSLayoutConstraint constraintWithItem:_confirmButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-10];

        self.dynamicConstraints = @[collectionLeftConstraint, collectionRightConstraint, collectionTopConstraint, collectionBottomConstraint, confirmButtonRightConsraint, confirmButtonBottomConstraint];
    }

    return self;
}

#pragma mark - DMLSelectorComponent

- (CGFloat)componentHeight
{
    return (self.componentDescriptor.sections.count + 1) * 60;
}

- (void)willAppear
{
    [self addSubview:self.collectionView];
    [self addSubview:self.confirmButton];

    [self addConstraints:self.dynamicConstraints];

    //    [self layoutIfNeeded];
    [self setNeedsUpdateConstraints];
}

- (void)willDisappear
{
    [self.collectionView removeFromSuperview];
    [self.confirmButton removeFromSuperview];

    [self removeConstraints:self.dynamicConstraints];
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
    DMLSelectorComponentCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:sCollectionCellIdentifier forIndexPath:indexPath];

    DMLSelectorSection *option = self.componentDescriptor.sections[indexPath.section];

    cell.textLabel.text = option.rowTexts[indexPath.row];

    if (self.values.count > 0) {
        if (indexPath.section > 0) {
            NSMutableArray *storeValues = self.values[option.sectionText];
            [storeValues enumerateObjectsUsingBlock:^(NSString *_Nonnull string, NSUInteger idx, BOOL *_Nonnull stop) {
                if ([string isEqualToString:cell.textLabel.text]) {
                    [cell setChecked:YES animated:NO];
                }
            }];
        }
        else {
            NSString *value = self.values[option.sectionText];

            if ([value isEqualToString:cell.textLabel.text]) {
                [cell setChecked:YES animated:NO];
            }
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

    switch (indexPath.section) {
        case 0:
            size.width = 56.0;
            size.height = 30.0;
            break;

        case 1:
            size.width = 72.0;
            size.height = 30.0;
            break;

        default:
            break;
    }
    return size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DMLSelectorComponentCollectionCell *cell = [collectionView cellForItemAtIndexPath:indexPath];

    [cell setChecked:!cell.isChecked animated:YES];

    DMLSelectorSection *option = self.componentDescriptor.sections[indexPath.section];

    NSString    *key = option.sectionText;
    NSString    *value = option.rowTexts[indexPath.row];

    if (option.exclusiveSelect) {
        // Section is exclusive selection
        for (NSUInteger i = 0; i < option.rowTexts.count; i++) {
            if (i != indexPath.row) {
                NSIndexPath                         *idxPath = [NSIndexPath indexPathForRow:i inSection:indexPath.section];
                DMLSelectorComponentCollectionCell  *cell = [collectionView cellForItemAtIndexPath:idxPath];
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

#pragma mark - Action

- (void)confirm
{
    // Collapse component
    DMLSelectorIndexPath *indexPath = [DMLSelectorIndexPath indexPathWithComponentIndex:self.componentIndex forRow:0 inSection:0];

    [self.selector collapseComponentWithSelectedIndexPath:indexPath];
}

#pragma mark - Getter

- (NSDictionary *)componentValues
{
    return self.values;
}

@end
