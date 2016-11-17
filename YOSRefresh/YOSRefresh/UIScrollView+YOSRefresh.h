//
//  UIScrollView+YOSRefresh.h
//  god
//
//  Created by yangyang on 2016/11/16.
//  Copyright © 2016年 shoppingm.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (YOSRefresh)

- (void)yos_addTopRefresh:(void (^)())block;

- (void)yos_endTopRefresh;

- (void)yos_addBottomRefresh:(void (^)())block;

- (void)yos_endBottomRefresh;

- (void)yos_addLeftRefresh:(void (^)())block;

- (void)yos_endLeftRefresh;

- (void)yos_addRightRefresh:(void (^)())block;

- (void)yos_endRightRefresh;

@end
