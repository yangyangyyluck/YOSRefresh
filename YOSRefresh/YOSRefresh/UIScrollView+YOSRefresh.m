//
//  UIScrollView+YOSRefresh.m
//  god
//
//  Created by yangyang on 2016/11/16.
//  Copyright © 2016年 shoppingm.cn. All rights reserved.
//

#import "UIScrollView+YOSRefresh.h"
#import "YOSTopRefreshView.h"
#import "YOSBottomRefreshView.h"
#import "YOSLeftRefreshView.h"
#import "YOSRightRefreshView.h"
#import <objc/runtime.h>

static char kTopRefreshKey;
static char kBottomRefreshKey;
static char kLeftRefreshKey;
static char kRightRefreshKey;

@interface UIScrollView ()

@property (nonatomic, weak) YOSTopRefreshView *topRefreshView;

@property (nonatomic, weak) YOSBottomRefreshView *bottomRefreshView;

@property (nonatomic, weak) YOSLeftRefreshView *leftRefreshView;

@property (nonatomic, weak) YOSRightRefreshView *rightRefreshView;

@end

@implementation UIScrollView (YOSRefresh)

- (void)yos_addTopRefresh:(void (^)())block {
    if (!self.topRefreshView) {
        YOSTopRefreshView *topRefreshView = [YOSTopRefreshView refreshView];
        [self addSubview:topRefreshView];
        
        self.topRefreshView = topRefreshView;
    }
    
    self.topRefreshView.block = block;
}

- (void)yos_endTopRefresh {
    [self.topRefreshView endRefresh];
}

- (void)yos_addBottomRefresh:(void (^)())block {
    if (!self.bottomRefreshView) {
        YOSBottomRefreshView *bottomRefreshView = [YOSBottomRefreshView refreshView];
        [self addSubview:bottomRefreshView];
        
        self.bottomRefreshView = bottomRefreshView;
    }
    
    self.bottomRefreshView.block = block;
}

- (void)yos_endBottomRefresh {
    [self.bottomRefreshView endRefresh];
}

- (void)yos_addLeftRefresh:(void (^)())block {
    if (!self.leftRefreshView) {
        YOSLeftRefreshView *leftRefreshView = [YOSLeftRefreshView refreshView];
        [self addSubview:leftRefreshView];
        
        self.leftRefreshView = leftRefreshView;
    }
    
    self.leftRefreshView.block = block;
}

- (void)yos_endLeftRefresh {
    [self.leftRefreshView endRefresh];
}

- (void)yos_addRightRefresh:(void (^)())block {
    if (!self.rightRefreshView) {
        YOSRightRefreshView *rightRefreshView = [YOSRightRefreshView refreshView];
        [self addSubview:rightRefreshView];
        
        self.rightRefreshView = rightRefreshView;
    }
    
    self.rightRefreshView.block = block;
}

- (void)yos_endRightRefresh {
    [self.rightRefreshView endRefresh];
}

#pragma mark - getter & setter

- (YOSTopRefreshView *)topRefreshView {
    return objc_getAssociatedObject(self, &kTopRefreshKey);
}

- (void)setTopRefreshView:(YOSTopRefreshView *)topRefreshView {
    objc_setAssociatedObject(self, &kTopRefreshKey, topRefreshView, OBJC_ASSOCIATION_ASSIGN);
}

- (YOSBottomRefreshView *)bottomRefreshView {
    return objc_getAssociatedObject(self, &kBottomRefreshKey);
}

- (void)setBottomRefreshView:(YOSBottomRefreshView *)bottomRefreshView {
    objc_setAssociatedObject(self, &kBottomRefreshKey, bottomRefreshView, OBJC_ASSOCIATION_ASSIGN);
}

- (YOSLeftRefreshView *)leftRefreshView {
    return objc_getAssociatedObject(self, &kLeftRefreshKey);
}

- (void)setLeftRefreshView:(YOSRightRefreshView *)leftRefreshView {
    objc_setAssociatedObject(self, &kLeftRefreshKey, leftRefreshView, OBJC_ASSOCIATION_ASSIGN);
}

- (YOSRightRefreshView *)rightRefreshView {
    return objc_getAssociatedObject(self, &kRightRefreshKey);
}

- (void)setRightRefreshView:(YOSRightRefreshView *)rightRefreshView {
    objc_setAssociatedObject(self, &kRightRefreshKey, rightRefreshView, OBJC_ASSOCIATION_ASSIGN);
}

@end
