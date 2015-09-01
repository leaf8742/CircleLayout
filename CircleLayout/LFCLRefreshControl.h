/**
 * @file
 * @author 单宝华
 * @date 2015-08-28
 */
#import <UIKit/UIKit.h>

/**
 * @class LFCLRefreshControl
 * @brief CircleLayout下拉刷新控件(LEAF CircleLayout RefreshControl)
 * @author 单宝华
 * @date 2015-08-28
 */
@interface LFCLRefreshControl : UIControl

- (instancetype)init;

/// @brief 是否正在刷新
@property (nonatomic, readonly, getter=isRefreshing) BOOL refreshing;

@property (nonatomic, retain) UIColor *tintColor;

@property (nonatomic, retain) NSAttributedString *attributedTitle;

/// @brief 开始刷新
- (void)beginRefreshing;

/// @brief 结束刷新
- (void)endRefreshing;

@end
