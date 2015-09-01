#define ITEM_SIZE 30
#define kAmazonCount 16

#import <UIKit/UIKit.h>

@interface CircleLayout : UICollectionViewLayout

@property (nonatomic, assign) CGFloat rotate;

@property (nonatomic, assign) NSRange range;

/// @brief 放大镜起始弧度
@property (nonatomic, assign) CGFloat magnifierBeginRadius;

/// @brief 放大镜结束弧度
@property (nonatomic, assign) CGFloat magnifierEndRadius;

/// @brief 放大镜区域是否顺时针
@property (nonatomic, assign) CGFloat magnifierClockwise;

@end
