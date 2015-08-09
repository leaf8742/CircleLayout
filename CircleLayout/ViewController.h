#import <UIKit/UIKit.h>
#import "CoordinatingController.h"

@interface ViewController : UICollectionViewController <CoordinatingControllerDelegate>

@property (nonatomic, assign) NSInteger cellCount;

@end
