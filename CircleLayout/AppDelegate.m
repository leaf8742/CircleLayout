#import "AppDelegate.h"
#import "CoordinatingController.h"

#import "ViewController.h"
#import "CircleLayout.h"
#import "scroll.h"

#import <objc/message.h>

@interface AppDelegate()<UIScrollViewDelegate>

@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    self.viewController = [[ViewController alloc] initWithCollectionViewLayout:[[CircleLayout alloc] init]];
//    self.viewController = [[UIViewController alloc] init];
//    scroll *scro = [[scroll alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
//    [scro setContentSize:CGSizeMake(320, 1000)];
//    [scro setBackgroundColor:[UIColor whiteColor]];
//    scro.delegate = self;
//    [self.viewController.view addSubview:scro];

    self.window.rootViewController = [[CoordinatingController sharedInstance] rootViewController];
    self.window.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
#warning _lastUpdateOffsetY
#warning _pageDecelerationTarget，翻页scroll用得上，这个项目暂时用不上
#warning _pagingSpringPull 衡值0.0003
#warning _pagingFriction 衡值0.97
#warning _accuracy 衡值2
#warning decelerationRate 衡值0.998
#warning _decelerationFactor 衡值NSSize: {0.99800003, 0.99800003}
#warning pan _hysteresis, _adjustScreenLocation:
    // 拉动时，记住上一次的速度
#warning _previousHorizontalVelocity, _previousVerticalVelocity
#warning _horizontalVelocity, _verticalVelocity
//    id result = objc_msgSend([scrollView valueForKey:@"_pan"], @selector(_hysteresis));
//    if (![scrollView isDragging]) {
        NSLog(@"%@, %@, %@, %@",
              [scrollView valueForKey:@"_horizontalVelocity"],
              [scrollView valueForKey:@"_verticalVelocity"],
              [scrollView valueForKey:@"_previousHorizontalVelocity"],
              [scrollView valueForKey:@"_previousVerticalVelocity"]);
//    }
}

@end
