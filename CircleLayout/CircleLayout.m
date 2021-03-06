#import "CircleLayout.h"

@interface CircleLayout()

@property (nonatomic, assign) NSInteger cellCount;

@property (nonatomic, assign) CGPoint center;

@property (nonatomic, assign) CGFloat radius;

@end

const CGFloat average = 1.0 / kAmazonCount * M_PI * 2;
const CGFloat offset = M_PI / kAmazonCount;
const NSInteger hiddenCount = 8;
const CGFloat begin = 0;
const CGFloat end = 1;

@implementation CircleLayout

- (id)init {
    if (self = [super init]) {
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    
    CGSize size = self.collectionView.frame.size;
    _cellCount = [[self collectionView] numberOfItemsInSection:0];
    _center = CGPointMake(size.width / 2.0, size.height / 2.0);
    _radius = MIN(size.width, size.height) / 2;
    _radius -= ITEM_SIZE / 2;
    _magnifierBeginRadius = average * 2;
    _magnifierEndRadius = average * 6;
}

- (CGSize)collectionViewContentSize {
    return [self collectionView].frame.size;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)path {
    UICollectionViewLayoutAttributes* attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:path];
    attributes.size = CGSizeMake(ITEM_SIZE, ITEM_SIZE);
    
    NSInteger visibleCount = _cellCount;
    if (visibleCount > kAmazonCount) {
        visibleCount = kAmazonCount;
    }
    
    CGFloat var = -(self.rotate - offset) / average;
    CGFloat begin = floorf(var);
    CGFloat end = (kAmazonCount - hiddenCount) + begin;
    const CGFloat itemRadian = (2 * path.item * M_PI / visibleCount - 0.5 * M_PI + offset);
    const CGFloat modItemRadian = fmod(2 * path.item * M_PI / visibleCount + self.rotate + offset, 2 * M_PI);
    const CGFloat constraintMagnifierBeginRadius = fmod(self.magnifierBeginRadius, 2 * M_PI);
    const CGFloat constraintMagnifierEndRadius = fmod(self.magnifierEndRadius, 2 * M_PI);
    const CGFloat magnifierDistance = fabs(constraintMagnifierBeginRadius - constraintMagnifierEndRadius);
    const CGFloat constraintMagnifierCenterRadius = constraintMagnifierBeginRadius + magnifierDistance / 2;
    attributes.alpha = 1;
    
    if ([path row] >= begin && [path row] < end) {
        // 位置
        CGPoint p = CGPointMake(_radius * cosf(itemRadian + self.rotate),
                                _radius * sinf(itemRadian + self.rotate));
        attributes.center = CGPointMake(/*_center.x + */p.x, _center.y + p.y);
        
        // 缩放
        if ([path row] == begin) {
            // 第1个
            attributes.alpha = 1 - (var - begin);
//            attributes.transform3D = CATransform3DMakeScale(1 - (var - begin), 1 - (var - begin), 1);
        }
        if ([path row] == end - 1) {
            // 当前显示的最后一个
            attributes.alpha = var - begin;
//            attributes.transform3D = CATransform3DMakeScale(var - begin, var - begin, 1);
        }
        if (modItemRadian > constraintMagnifierBeginRadius && modItemRadian < constraintMagnifierEndRadius) {
            // 在放大镜区域内，放大
            CGFloat scale = 2 - fabs(constraintMagnifierCenterRadius - modItemRadian) / (magnifierDistance / 2);
            attributes.transform3D = CATransform3DMakeScale(scale, scale, 1);
        }
    } else {
        attributes.alpha = 0;
        attributes.center = CGPointMake(_center.x, _center.y);
    }
    
    return attributes;
}

- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect {
    CGFloat var = -(self.rotate - offset) / average;
    CGFloat begin = floorf(var);
    CGFloat end = (kAmazonCount - hiddenCount) + begin;
    
    NSMutableArray* attributes = [NSMutableArray array];
    for (NSInteger row = begin; row != end; ++row) {
        if (row >= 0 && row < [[self collectionView] numberOfItemsInSection:0]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
            [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
        }
    }
    
    return attributes;
}

@end
