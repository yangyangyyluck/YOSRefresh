//
//  YOSRightRefreshView.h
//  YOSRefresh
//
//  Created by yangyang on 2016/11/17.
//  Copyright © 2016年 shoppingm.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YOSRightRefreshView : UIView

@property (nonatomic, copy) void (^block)();

+ (instancetype)refreshView;

- (void)endRefresh;

@end
