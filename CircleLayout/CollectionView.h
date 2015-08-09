/**
 * @file
 * @author 单宝华
 * @date 2014-11-22
 */
#import <CoreGraphics/CoreGraphics.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

/**
 * @function radians
 * @param center 圆中心点
 * @param point 参与运算的坐标
 * @return 返回坐标位于圆的弧度
 */
extern CGFloat radians(CGPoint center, CGPoint position);

/**
 * @function increment
 * @param 起始弧度
 * @param 结束弧度
 * @return 两点之间的增量
 */
extern CGFloat increment(CGFloat beginRadius, CGFloat endRadius);

/**
 * @class CollectionView
 * @brief collectionView
 * @author 单宝华
 * @date 2014-11-22
 */
@interface CollectionView : UICollectionView

@end
