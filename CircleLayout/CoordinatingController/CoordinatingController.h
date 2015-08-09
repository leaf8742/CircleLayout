/**
 * @file
 * @author 单宝华
 * @date 2014-12-3
 */
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 * @protocol CoordinatingControllerDelegate
 * @brief 协调者协议
 * @author 单宝华
 * @date 2014-12-3
 */
@protocol CoordinatingControllerDelegate <NSObject>

@optional
/// @brief 自己创建可压入的视图
+ (instancetype)buildViewController;

/// @brief 标题是否隐藏
- (BOOL)navigationBarHidden;

/**
 NSLayoutConstraint
/// @brief 左侧标题栏按钮
@property (nonatomic, copy) NSArray *leftBarButtonItems;

/// @brief 左侧标题栏按钮
@property (nonatomic, copy) NSArray *rightBarButtonItems;

/// @brief 返回按钮是否隐藏
@property (nonatomic, assign) BOOL hidesBackButton;

/// @brief
@property (nonatomic, copy) UINavigationItem *navigationItem;
 */

@end


/**
 * @class CoordinatingController
 * @brief 页面协调者类
 * @author 单宝华
 * @date 2014-12-3
 */
@interface CoordinatingController : NSObject

/// @brief 提供给AppDelegate使用
@property (readonly, nonatomic) UINavigationController *rootViewController;

/// @brief 当前ViewController
@property (readonly, nonatomic) UIViewController *activeViewController;

/// @brief 单例，页面协调者在应用程序中有且仅有一个
+ (instancetype)sharedInstance;

/// @brief 根据class name创建页面，并压入navigationController
/// @warning 指定class必须实现BaseViewControllerDelegate的buildViewController
/// @see BaseViewControllerDelegate
- (void)pushViewControllerWithClass:(Class<CoordinatingControllerDelegate>)class animated:(BOOL)animated;

/// @brief 根据Class切换页面，出栈动作
- (BOOL)popToViewControllerWithClass:(Class)pushClass animated:(BOOL)animated;

/// @brief 返回上级页面
- (void)popViewControllerWithAnimated:(BOOL)animated;

/// @brief 返回上级页面
- (IBAction)popViewController;

/// @brief 背景点击事件
- (IBAction)backgroundTap:(id)sender;

/// @brief 拍照
+ (UIImagePickerController *)shootPictureWithDelegate:(id <UINavigationControllerDelegate, UIImagePickerControllerDelegate>)delegate;

/// @brief 从手机相册中选择
+ (UIImagePickerController *)selectExistingPictureWithDelegate:(id <UINavigationControllerDelegate, UIImagePickerControllerDelegate>)delegate;

@end
