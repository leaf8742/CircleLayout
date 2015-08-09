#import "CoordinatingController.h"
//#import "CustomTextField.h"
#import "ViewController.h"

#if __has_feature(objc_arc)
#error CoordinatingController must be built with ARC.
// You can turn off ARC for only CoordinatingController.m by adding -fobjc-arc to the build phase.
#endif

@interface CoordinatingController()<UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UINavigationController *rootViewController;

@property (retain, nonatomic) UIViewController *activeViewController;

@property (retain, nonatomic) UITextField *currentUsedTextField;

@property (retain, nonatomic) NSNotification *keyboardWillChangeFrame;

@end


@implementation CoordinatingController

#pragma mark - Signleton Implementation
+ (instancetype)sharedInstance {
    static CoordinatingController *sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedClient = [NSAllocateObject([self class], 0, NULL) init];
        [sharedClient initialize];
    });
    return sharedClient;
}

+ (id)allocWithZone:(NSZone *)zone {
    static id result;
    result = nil;
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        result = [self sharedInstance];
    });
    return result;
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (NSUInteger)retainCount {
    return UINT_MAX;
}

- (oneway void)release {
}

- (id)autorelease {
    return self;
}

- (void)initialize {
    self.rootViewController = [[UINavigationController alloc] init];
    self.rootViewController.navigationBar.translucent = YES;
//    self.rootViewController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    [self.rootViewController setNavigationBarHidden:YES];
    [self appearance];
    [self.rootViewController setDelegate:self];
    [self pushViewControllerWithClass:[ViewController class] animated:YES];

    // 注册键盘回调函数
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidEndEditing:) name:UITextFieldTextDidEndEditingNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)appearance {
    // 白色状态栏
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor yellowColor]];
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:95.0f / 255 green:90.0f / 255 blue:85.0f / 255 alpha:1.0f], UITextAttributeTextColor,
                                                           [UIColor clearColor], UITextAttributeTextShadowColor,
                                                           [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset,
                                                           [UIFont fontWithName:@"HelveticaNeue" size:18], UITextAttributeFont,
                                                           nil]];
}

#pragma mark - 场景切换
- (void)pushViewControllerWithClass:(Class<CoordinatingControllerDelegate>)class animated:(BOOL)animated {
    id viewController = [class buildViewController];
    [self.rootViewController pushViewController:viewController animated:animated];
}

- (BOOL)popToViewControllerWithClass:(Class)pushClass animated:(BOOL)animated {
    UINavigationController *rootViewController = self.rootViewController;

    NSArray *filteredObjects = [[rootViewController viewControllers] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return [evaluatedObject isKindOfClass:pushClass];
    }]];

    if ([filteredObjects count]) {
        [self.rootViewController popToViewController:[filteredObjects firstObject] animated:YES];
        return YES;
    } else {
        return NO;
    }
}

- (void)popViewControllerWithAnimated:(BOOL)animated {
    [self.rootViewController popViewControllerAnimated:animated];
}

- (IBAction)popViewController {
    [self popViewControllerWithAnimated:YES];
}

+ (UIImagePickerController *)shootPictureWithDelegate:(id <UINavigationControllerDelegate, UIImagePickerControllerDelegate>)delegate {
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[[UIImagePickerController alloc] init] autorelease];
        picker.delegate = delegate;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        return picker;
    } else {
        return nil;
    }
}

+ (UIImagePickerController *)selectExistingPictureWithDelegate:(id <UINavigationControllerDelegate, UIImagePickerControllerDelegate>)delegate {
    UIImagePickerController *picker = [[[UIImagePickerController alloc] init] autorelease];
    picker.delegate = delegate;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    return picker;
}

- (IBAction)backgroundTap:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

#pragma mark - 键盘回调事件
- (void)textDidBeginEditing:(NSNotification *)notification {
#warning TODO
//    self.currentUsedTextField = [notification object];
//    if (![self.currentUsedTextField isKindOfClass:[CustomTextField class]]) {
//        return;
//    }
//
//    [(CustomTextField *)self.currentUsedTextField didBeginEditing:notification];
//
//    if (self.keyboardWillChangeFrame) {
//        [UIView animateWithDuration:0.25 animations:^{
//            [(CustomTextField *)self.currentUsedTextField reciveFocus:self.keyboardWillChangeFrame];
//        }];
//    }
}

- (void)textDidEndEditing:(NSNotification *)notification {
#warning TODO
//    if ([[notification object] isKindOfClass:[CustomTextField class]]) {
//        [(CustomTextField *)[notification object] didEndEditing:notification];
//    }
//    self.currentUsedTextField = nil;
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification {
#warning TODO
//    self.keyboardWillChangeFrame = notification;
//    if (![self.currentUsedTextField isKindOfClass:[CustomTextField class]]) {
//        return;
//    }
//
//    [UIView animateWithDuration:0.25 animations:^{
//        [(CustomTextField *)self.currentUsedTextField animationKeyboard:notification];
//    }];
//
//    CGRect keyboardFrameEnd = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    if (keyboardFrameEnd.origin.y == [[UIApplication sharedApplication] keyWindow].frame.size.height) {
//        self.keyboardWillChangeFrame = nil;
//    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([_activeViewController conformsToProtocol:@protocol(UITextFieldDelegate)] && [_activeViewController respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
        return [(id<UITextFieldDelegate>)_activeViewController textFieldShouldBeginEditing:textField];
    } else {
        return YES;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
#warning TODO
//    if ([_activeViewController conformsToProtocol:@protocol(UITextFieldDelegate)] && [_activeViewController respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
//        return [(id<UITextFieldDelegate>)_activeViewController textField:textField shouldChangeCharactersInRange:range replacementString:string];
//    } else {
//        NSAssert([textField isKindOfClass:[CustomTextField class]], @"设置协调者为输入代理，必须是CustomTextField类才可以");
//        return [(CustomTextField*)textField shouldChangeCharactersInRange:range replacementString:string];
//    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
#warning TODO
//    if ([_activeViewController conformsToProtocol:@protocol(UITextFieldDelegate)] && [_activeViewController respondsToSelector:@selector(textFieldShouldReturn:)]) {
//        return [(id<UITextFieldDelegate>)_activeViewController textFieldShouldReturn:textField];
//    } else if ([textField isKindOfClass:[CustomTextField class]] && textField.returnKeyType == UIReturnKeyNext) {
//        [[[(CustomTextField *)textField inputValidator] nextTextField] becomeFirstResponder];
//    } else {
//        [textField resignFirstResponder];
//    }
//    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([_activeViewController conformsToProtocol:@protocol(UITextFieldDelegate)] && [_activeViewController respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [(id<UITextFieldDelegate>)_activeViewController textFieldDidEndEditing:textField];
    }
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [viewController.navigationItem setBackBarButtonItem:backItem];
    
    if ([viewController conformsToProtocol:@protocol(CoordinatingControllerDelegate)] && [viewController respondsToSelector:@selector(navigationBarHidden)]) {
        [self.rootViewController setNavigationBarHidden:[(id<CoordinatingControllerDelegate>)viewController navigationBarHidden] animated:YES];
    } else {
        [self.rootViewController setNavigationBarHidden:NO animated:YES];
    }
    self.activeViewController = viewController;
}

@end
