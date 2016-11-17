//
//  YOSTopRefreshView.h
//  god
//
//  Created by yangyang on 2016/11/16.
//  Copyright © 2016年 shoppingm.cn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YOSTopRefreshView : UIView

@property (nonatomic, copy) void (^block)();

+ (instancetype)refreshView;

- (void)endRefresh;

@end
