#import "CollectionView.h"
#import "CircleLayout.h"
#import "CoordinatingController.h"
#import "GeometryAssist.h"
#import <pop/POP.h>

@interface CollectionView ()

/// @brief 当前的旋转弧度
@property (assign, nonatomic) CGFloat currentRadians;

/// @brief 拖拽按下时存储的点击坐标转换的弧度
@property (assign, nonatomic) CGFloat startRotate;

/// @brief 拖拽拉动时，弧度增量的总和
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
        
        self.currentRadians = radians(CGPointMake(0, 0), CGPointMake(1, 0));
    }
    return self;
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)sender {
    [[[CoordinatingController sharedInstance] rootViewController] setNavigationBarHidden:YES animated:YES];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self.collectionViewLayout pop_removeAllAnimations];
        self.currentRadians = radians(CGPointMake(0, self.center.y)/* self.center*/, [sender locationInView:self]);
        self.startRotate = self.collectionViewLayout.rotate;
        self.sum_increment = 0;
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        [self.collectionViewLayout pop_removeAllAnimations];
        
        CGFloat rotate = self.startRotate;
        CGFloat theta = radians(CGPointMake(0, self.center.y) /*self.center*/, [sender locationInView:self]);
        CGFloat incrementRadians = increment(self.currentRadians, theta);
        self.sum_increment += incrementRadians;
        self.clockwise = (incrementRadians > 0);
        
        CGFloat new = self.startRotate + self.sum_increment;
        CGFloat min = 0;
        CGFloat max = [self maximumRotate];
        CGFloat constrained = fmin(min, fmax(new, max));
        rotate = constrained + (new - constrained) / 2;
        
        self.collectionViewLayout.rotate = rotate;
        [self.collectionViewLayout invalidateLayout];
        
        self.currentRadians = theta;
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

    BOOL outsideRotateMinimum = self.collectionViewLayout.rotate > [self minimumRotate];
    BOOL outsideRotateMaximum = self.collectionViewLayout.rotate < [self maximumRotate];
    __weak UIPanGestureRecognizer *weak_sender = sender;

    if (outsideRotateMaximum || outsideRotateMinimum) {
        POPSpringAnimation *springAnimation = [POPSpringAnimation animation];
        springAnimation.property = [POPAnimatableProperty propertyWithName:@"rotate" initializer:^(POPMutableAnimatableProperty *prop) {
            prop.readBlock = [self readBlock];
            prop.writeBlock = [self springWriteBlock];
            prop.threshold = 0.01;
        }];
        springAnimation.velocity = [NSNumber numberWithFloat:distance];
        springAnimation.toValue = [NSNumber numberWithFloat:outsideRotateMinimum ? [self minimumRotate] : [self maximumRotate]];
        springAnimation.springBounciness = 0.0;
        springAnimation.springSpeed = 5.0;
        [self.collectionViewLayout pop_addAnimation:springAnimation forKey:@"bounce"];
    } else if (fabs(distance) >= 3.5) {
        POPDecayAnimation *anim = [POPDecayAnimation animation];
        anim.velocity = [NSNumber numberWithFloat:distance];
        anim.deceleration = 0.998;
        anim.property = [POPAnimatableProperty propertyWithName:@"rotate" initializer:^(POPMutableAnimatableProperty *prop) {
            prop.readBlock = [self readBlock];
            prop.writeBlock = ^(CircleLayout *obj, const CGFloat values[]) {
                obj.rotate = values[0];
                if (obj.rotate > [self minimumRotate] || obj.rotate < [self maximumRotate]) {
                    [self.collectionViewLayout pop_removeAnimationForKey:@"decelerate"];
                    [self addDecayRotateAnimationWithVelocity:weak_sender];
                }
                [self.collectionViewLayout invalidateLayout];
            };
            prop.threshold = 0.01;
        }];
        [self.collectionViewLayout pop_addAnimation:anim forKey:@"decelerate"];
    }
}

- (void (^)(id obj, CGFloat values[]))readBlock {
    return ^(CircleLayout *obj, CGFloat values[]) {
        values[0] = obj.rotate;
    };
}

- (void (^)(id obj, const CGFloat values[]))springWriteBlock {
    return ^(CircleLayout *obj, const CGFloat values[]) {
        obj.rotate = values[0];
        [self.collectionViewLayout invalidateLayout];
    };
}

- (void (^)(id obj, const CGFloat values[]))decayWriteBlock {
}

- (CGFloat)minimumRotate {
    return 0;
}

- (CGFloat)maximumRotate {
    CGFloat result = -2.0 / kAmazonCount * [self.dataSource collectionView:self numberOfItemsInSection:0] * M_PI + M_PI;
    return  result;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.collectionViewLayout pop_removeAllAnimations];
}

@end
