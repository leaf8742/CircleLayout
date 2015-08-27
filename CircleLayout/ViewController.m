#import "ViewController.h"
#import "Cell.h"
#import "CircleLayout.h"
#import "CollectionView.h"
#import "CoordinatingController.h"

@interface ViewController()

@end

@implementation ViewController

#pragma mark - CoordinatingControllerDelegate
+ (instancetype)buildViewController {
    return [[ViewController alloc] initWithCollectionViewLayout:[[CircleLayout alloc] init]];
}

- (BOOL)navigationBarHidden {
    return YES;
}

- (id)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithCollectionViewLayout:layout]) {
    }
    return self;
}

- (void)viewDidLoad {
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.cellCount = 16;
    self.collectionView = [[CollectionView alloc] initWithFrame:self.collectionView.frame collectionViewLayout:self.collectionViewLayout];
    [self.collectionView setDelegate:self];
    [self.collectionView setDataSource:self];
    [self.collectionView registerClass:[Cell class] forCellWithReuseIdentifier:@"MY_CELL"];
    self.collectionView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return self.cellCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    Cell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"MY_CELL" forIndexPath:indexPath];
    [cell.label setText:[NSString stringWithFormat:@"%ld", (long)[indexPath item]]];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self setTitle:[NSString stringWithFormat:@"%ld", (long)[indexPath row]]];
    [[[CoordinatingController sharedInstance] rootViewController] setNavigationBarHidden:NO animated:YES];
}

@end
