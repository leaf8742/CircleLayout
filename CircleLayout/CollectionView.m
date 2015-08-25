#import "CollectionView.h"
#import "CircleLayout.h"
#import <pop/POP.h>
#import "CoordinatingController.h"

CGFloat radians(CGPoint center, CGPoint position) {
    CGPoint vector = CGPointMake(position.x - center.x, position.y - center.y);
    CGFloat distance = sqrtf(pow(vector.x, 2) + pow(vector.y, 2));
    CGPoint unitVector = CGPointMake(vector.x / distance, vector.y / distance);
    CGFloat result = (unitVector.y >= 0) ? 2 * M_PI - acosf(unitVector.x) : acosf(unitVector.x);
    
    return result;
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

CGPoint pointAddVector(CGPoint point, CGPoint vector) {
    return CGPointMake(point.x + vector.x, point.y + vector.y);
}

@interface CollectionView ()

/// @brief 当前的旋转弧度
@property (assign, nonatomic) CGFloat currentAngle;

@property (assign, nonatomic) CGFloat startRotate;

@property (assign, nonatomic) CGFloat sum_increment;

/// @brief 当前滚动是否为顺时针滚动
@property (assign, nonatomic) BOOL clockwise;

/// @brief 二次构建
@property (nonatomic, retain) CircleLayout *collectionViewLayout;

@end


@implementation CollectionView

@dynamic collectionViewLayout;

#pragma mark - Override
- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        [self addGestureRecognizer:panRecognizer];
        
        self.currentAngle = radians(CGPointMake(0, 0), CGPointMake(1, 0));
    }
    return self;
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)sender {
    [[[CoordinatingController sharedInstance] rootViewController] setNavigationBarHidden:YES animated:YES];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self.collectionViewLayout pop_removeAllAnimations];
        self.currentAngle = radians(CGPointMake(0, self.center.y)/* self.center*/, [sender locationInView:self]);
        self.startRotate = self.collectionViewLayout.rotate;
        self.sum_increment = 0;
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        [self.collectionViewLayout pop_removeAllAnimations];
        
        CGFloat rotate = self.startRotate;
        CGFloat theta = radians(CGPointMake(0, self.center.y) /*self.center*/, [sender locationInView:self]);
        CGFloat incrementRadians = increment(self.currentAngle, theta);
        self.sum_increment += incrementRadians;
        self.clockwise = (incrementRadians > 0);
        
        CGFloat new = self.startRotate + self.sum_increment;
        CGFloat min = 0;
#warning TODO 最大
        CGFloat max = -MAXFLOAT;
        CGFloat constrained = fmin(min, fmax(new, max));
        rotate = constrained + (new - constrained) / 2;
        
        self.collectionViewLayout.rotate = rotate;
        [self reloadData];
        
        self.currentAngle = theta;
    } else if (sender.state == UIGestureRecognizerStateEnded ||
               sender.state == UIGestureRecognizerStateCancelled) {
        [self addDecayRotateAnimationWithVelocity:sender];
    }
}

- (void)addDecayRotateAnimationWithVelocity:(UIPanGestureRecognizer *)sender {
    CGPoint velocity = [sender velocityInView:self];
    CGPoint location = [sender locationInView:self];
    CGFloat radius = sqrt(pow(/*self.center.x - */location.x, 2) + pow(self.center.y - location.y, 2));
    CGFloat distance = (self.clockwise ? 1 : -1) * sqrt(pow(location.x - velocity.x, 2) + pow(location.y - velocity.y, 2)) / radius;

    BOOL outsideBoundsMinimum = self.collectionViewLayout.rotate > 0;
#warning TODO 最大
    BOOL outsideBoundsMaximum = self.collectionViewLayout.rotate < -MAXFLOAT;

    if (outsideBoundsMaximum || outsideBoundsMinimum) {
        POPSpringAnimation *springAnimation = [POPSpringAnimation animation];
        springAnimation.property = [POPAnimatableProperty propertyWithName:@"bounce" initializer:^(POPMutableAnimatableProperty *prop) {
            prop.readBlock = ^(CircleLayout *obj, CGFloat values[]) {
                values[0] = obj.rotate;
            };
            prop.writeBlock = ^(CircleLayout *obj, const CGFloat values[]) {
                obj.rotate = values[0];
                [self reloadData];
            };
            prop.threshold = 0.01;
        }];
        springAnimation.velocity = [NSNumber numberWithFloat:distance];
        springAnimation.toValue = [NSNumber numberWithFloat:0];
        springAnimation.springBounciness = 0.0;
        springAnimation.springSpeed = 5.0;
        [self.collectionViewLayout pop_addAnimation:springAnimation forKey:@"bounce"];
    } else if (fabs(distance) >= 3.5) {
        POPDecayAnimation *anim = [POPDecayAnimation animation];
        anim.velocity = [NSNumber numberWithFloat:distance];
        anim.deceleration = 0.998;
        anim.property = [POPAnimatableProperty propertyWithName:@"decelerate" initializer:^(POPMutableAnimatableProperty *prop) {
            prop.readBlock = ^(CircleLayout *obj, CGFloat values[]) {
                values[0] = obj.rotate;
            };
            prop.writeBlock = ^(CircleLayout *obj, const CGFloat values[]) {
                obj.rotate = values[0];
                [self reloadData];
            };
            prop.threshold = 0.01;
        }];
        [self.collectionViewLayout pop_addAnimation:anim forKey:@"decelerate"];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.collectionViewLayout pop_removeAllAnimations];
}

@end
