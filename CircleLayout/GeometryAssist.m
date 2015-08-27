#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GeometryAssist.h"

CGFloat radians(CGPoint center, CGPoint position) {
    CGPoint vector = CGPointMake(position.x - center.x, position.y - center.y);
    CGFloat distance = sqrtf(pow(vector.x, 2) + pow(vector.y, 2));
    CGPoint unitVector = CGPointMake(vector.x / distance, vector.y / distance);
    CGFloat result = (unitVector.y >= 0) ? 2 * M_PI - acosf(unitVector.x) : acosf(unitVector.x);
    
    return result;
}

CGPoint position(CGFloat radian) {
    return CGPointMake(cosf(radian), sinf(radian));
}

CGFloat distance(CGPoint position1, CGPoint position2) {
    return sqrt(pow(position1.x - position2.x, 2) + pow(position1.y - position2.y, 2));
}

CGFloat increment(CGFloat beginRadius, CGFloat endRadius) {
    CGFloat result =  beginRadius - endRadius;
    if (result < 0 && fabs(result) > M_PI) {
        result += 2 * M_PI;
    } else if (result > 0 && fabs(result) > M_PI) {
        result -= 2 * M_PI;
    }
    return result;
}

CGPoint pointAddVector(CGPoint position, CGPoint vector) {
    return CGPointMake(position.x + vector.x, position.y + vector.y);
}

CGPoint rotatePoint(CGPoint position, CGFloat rotateRadian) {
    CGFloat s = position.x * cosf(rotateRadian) - position.y * sinf(rotateRadian);
    CGFloat t = position.x * sinf(rotateRadian) + position.y * cosf(rotateRadian);
    return CGPointMake(s, t);
}
