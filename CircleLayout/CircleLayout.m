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
    
    if ([path row] >= begin && [path row] < end) {
        // 位置
        CGPoint p = CGPointMake(_radius * cosf(2 * path.item * M_PI / visibleCount - 0.5 * M_PI + offset),
                                _radius * sinf(2 * path.item * M_PI / visibleCount - 0.5 * M_PI + offset));
        
        CGFloat s = p.x * cosf(self.rotate) - p.y * sinf(self.rotate);
        CGFloat t = p.x * sinf(self.rotate) + p.y * cosf(self.rotate);
        attributes.center = CGPointMake(/*_center.x + */s, _center.y + t);
        
        // 缩放
        if ([path row] == begin) {
            attributes.alpha = 1 - (var - begin);
//            attributes.transform3D = CATransform3DMakeScale(1 - (var - begin), 1 - (var - begin), 1);
        } else if ([path row] == end - 1) {
            attributes.alpha = var - begin;
//            attributes.transform3D = CATransform3DMakeScale(var - begin, var - begin, 1);
        } else {
            attributes.alpha = 1;
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
