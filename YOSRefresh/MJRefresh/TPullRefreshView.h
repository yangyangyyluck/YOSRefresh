//
//  TPullRefreshView.h
//  TGodAnimationTest
//
//  Created by yangyang on 16/2/19.
//  Copyright © 2016年 kuailai.inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TPullRefreshView : UIView

@property (nonatomic, assign) CGFloat percentage;

+ (instancetype)pullRefreshView;

- (void)executeCustomAnimation;

- (void)resume;

@end
