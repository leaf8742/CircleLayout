/**
 * @file
 * @author 单宝华
 * @date 2015-08-27
 * @brief 图形学相关函数
 */

/**
 * @function radians
 * @param center 圆中心点
 * @param point 参与运算的坐标
 * @return 返回坐标位于圆的弧度
 */
extern CGFloat radians(CGPoint center, CGPoint position);

/**
 * @function
 * @param radian 弧度
 * @return 将弧度转换成坐标
 * @note 以圆心为(0, 0)的单元坐标
 */
extern CGPoint position(CGFloat radian);

/**
 * @function
 * @param position1 第1个坐标
 * @param position2 第2个坐标
 * @return 计算两个坐标之间的长度
 */
extern CGFloat distance(CGPoint position1, CGPoint position2);

/**
 * @function increment
 * @param 起始弧度
 * @param 结束弧度
 * @return 两点之间的增量
 */
extern CGFloat increment(CGFloat beginRadius, CGFloat endRadius);

/**
 * @function pointAddVector
 * @param position 初始坐标
 * @param vector 位移的向量
 * @return 坐标和向量之和
 */
extern CGPoint pointAddVector(CGPoint position, CGPoint vector);

/**
 * @function rotatePoint
 * @param position 旋转之前的坐标
 * @param rotateRadian 旋转弧度
 * @return 旋转之后的坐标
 */
extern CGPoint rotatePoint(CGPoint position, CGFloat rotateRadian);
