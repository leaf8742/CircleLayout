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

@property (assign, nonatomic) CGFloat lastAngle;

/// @brief 当前滚动是否为顺时针滚动
@property (assign, nonatomic) BOOL clockwise;

/// @brief 二次构建
@property (nonatomic, retain) CircleLayout *collectionViewLayout;

//@property (nonatomic, retain) UITouch *currentTouch;

/**
 UITableView
 UITouch *_currentTouch;
 
 UIScrollView
 struct CGPoint _pageDecelerationTarget;
 struct CGSize _decelerationFactor;
 struct CGPoint _adjustedDecelerationTarget;
 struct CGSize _adjustedDecelerationFactor;
 double _decelerationLnFactorH;
 double _decelerationLnFactorV;
 struct CGSize _accumulatedOffset;
 double _accuracy;
 
 -[UIScrollView _rubberBandContentOffsetForOffset:outsideX:outsideY:]
 -[UIScrollView _rubberBandOffsetForOffset:maxOffset:minOffset:range:outside:]
 -[UIScrollView _rubberBandToOffset:] ^
 -[UIScrollView _updatePanGesture]
 -[UIScrollView handlePan:]
 doubleBounds
 setNeedsLayoutOnGeometryChange
 floor
 floorf
 roundf
 round
 */
@end


@implementation CollectionView

#pragma mark - Override
- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        [self addGestureRecognizer:panRecognizer];
        
        self.lastAngle = radians(CGPointMake(0, 0), CGPointMake(1, 0));
    }
    return self;
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)sender {
    [[[CoordinatingController sharedInstance] rootViewController] setNavigationBarHidden:YES animated:YES];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self.collectionViewLayout pop_removeAllAnimations];
        self.lastAngle = radians(CGPointMake(0, self.center.y)/* self.center*/, [sender locationInView:self]);
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        [self.collectionViewLayout pop_removeAllAnimations];
        
        CGFloat theta = radians(CGPointMake(0, self.center.y) /*self.center*/, [sender locationInView:self]);
        CGFloat incrementRadians = increment(self.lastAngle, theta);
        
        self.clockwise = (incrementRadians > 0);
        self.collectionViewLayout.rotate += incrementRadians;
        [self reloadData];
        
        self.lastAngle = theta;
    } else if (sender.state == UIGestureRecognizerStateEnded ||
               sender.state == UIGestureRecognizerStateCancelled) {
        if (self.collectionViewLayout.rotate > 0) {
            self.collectionViewLayout.rotate = 0;
            [self reloadData];
        } else {
            [self addDecayRotateAnimationWithVelocity:sender];
        }
    }
}

- (void)addDecayRotateAnimationWithVelocity:(UIPanGestureRecognizer *)sender {
    CGPoint velocity = [sender velocityInView:self];
    CGPoint location = [sender locationInView:self];
    CGFloat radius = sqrt(pow(/*self.center.x - */location.x, 2) + pow(self.center.y - location.y, 2));
    CGFloat distance = (self.clockwise ? 1 : -1) * sqrt(pow(location.x - velocity.x, 2) + pow(location.y - velocity.y, 2)) / radius;
    if (fabsf(distance) < 3.5) return;
    
    POPDecayAnimation *anim = [POPDecayAnimation animation];
    anim.velocity = [NSNumber numberWithFloat:distance];
    anim.deceleration = 0.998;
    anim.property = [POPAnimatableProperty propertyWithName:@"count" initializer:^(POPMutableAnimatableProperty *prop) {
        prop.readBlock = ^(CircleLayout *obj, CGFloat values[]) {
            values[0] = obj.rotate;
        };
        prop.writeBlock = ^(CircleLayout *obj, const CGFloat values[]) {
            obj.rotate = values[0];
            [self reloadData];
        };
        prop.threshold = 0.01;
    }];
    [self.collectionViewLayout pop_addAnimation:anim forKey:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.collectionViewLayout pop_removeAllAnimations];
}

@end
