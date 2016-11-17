//
//  YOSRefreshConst.h
//  god
//
//  Created by yangyang on 2016/11/16.
//  Copyright © 2016年 shoppingm.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, YOSRefreshStatus) {
    YOSRefreshStatusNormal          = 0,    // 普通
    YOSRefreshStatusPulling         = 1,    // 下拉
    YOSRefreshStatusWillRefreshing  = 2,    // 即将刷新
    YOSRefreshStatusRefreshing      = 3,    // 正在刷新
};

UIKIT_EXTERN const CGFloat YOSRefreshFastAnimationDuration;
UIKIT_EXTERN const CGFloat YOSRefreshTopBottomHeight;
UIKIT_EXTERN const CGFloat YOSRefreshLeftRightWidth;

UIKIT_EXTERN NSString *const YOSRefreshContentOffset;
UIKIT_EXTERN NSString *const YOSRefreshContentSize;
