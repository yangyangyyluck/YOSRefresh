//
//  YOSBottomRefreshView.m
//  YOSRefresh
//
//  Created by yangyang on 2016/11/16.
//  Copyright © 2016年 shoppingm.cn. All rights reserved.
//

#import "YOSBottomRefreshView.h"
#import "TPullRefresh3DView.h"
#import "YOSRefreshConst.h"

@interface YOSBottomRefreshView ()

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, assign) BOOL hasInit;

@property (nonatomic, assign) YOSRefreshStatus status;

@property (nonatomic, assign) UIEdgeInsets originalContentInset;

@property (nonatomic, strong) TPullRefresh3DView *animView;

@end

@implementation YOSBottomRefreshView

+ (instancetype)refreshView {
    return [YOSBottomRefreshView new];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 1.自己的属性
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor clearColor];
        
        // 2.设置默认状态
        self.status = YOSRefreshStatusNormal;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.animView.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    [self.superview removeObserver:self forKeyPath:YOSRefreshContentOffset];
    [self.superview removeObserver:self forKeyPath:YOSRefreshContentSize];
    
    if (newSuperview) {
        [newSuperview addObserver:self forKeyPath:YOSRefreshContentOffset options:NSKeyValueObservingOptionNew context:nil];
        [newSuperview addObserver:self forKeyPath:YOSRefreshContentSize options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    if (!self.hasInit) {
        self.hasInit = YES;
        
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        
        self.scrollView = scrollView;
        self.scrollView.alwaysBounceVertical = YES;
        
        self.originalContentInset = scrollView.contentInset;
        
        [self adjustFrame];
    }
    
}

#pragma mark - 监听UIScrollView的contentOffset属性
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // 不能跟用户交互就直接返回
    if (!self.userInteractionEnabled || self.alpha <= 0.01 || self.hidden) return;
    
    if ([keyPath isEqualToString:YOSRefreshContentSize]) {
        [self adjustFrame];
    }
    
    // 如果正在刷新，直接返回
    if (self.status == YOSRefreshStatusRefreshing) return;
    
    if ([keyPath isEqualToString:YOSRefreshContentOffset]) {
        [self adjustStatus];
    }
}

#pragma mark - 核心逻辑

- (void)adjustFrame {

    CGFloat contentSizeHeight = [self contentSizeHeight];

    CGFloat viewHeight = self.scrollView.frame.size.height;

    // set y
    CGRect frame = CGRectMake(0, MAX(viewHeight, contentSizeHeight), self.scrollView.frame.size.width, YOSRefreshTopBottomHeight);
    self.frame = frame;
}

- (void)adjustStatus {
    CGFloat offset = [self judgePointOffset];
    
    // offset > 0 上拉
    if (offset > 0) {
        CGFloat absOffset = ABS(offset);
        
        CGFloat percentage = absOffset / YOSRefreshTopBottomHeight;
        percentage = MIN(1.0, percentage);
        
        self.animView.percentage = percentage;
        
        if (self.scrollView.isDragging) {
            
            if (0 < absOffset && absOffset < YOSRefreshTopBottomHeight) {
                self.status = YOSRefreshStatusPulling;
            } else if (absOffset >= YOSRefreshTopBottomHeight) {
                self.status = YOSRefreshStatusWillRefreshing;
            } else {
                // normal 状态只能让endRefresh触发,不能用位移去触发
                if (self.status != YOSRefreshStatusRefreshing) {
                    self.status = YOSRefreshStatusNormal;
                }
            }
            
        } else if (self.status == YOSRefreshStatusWillRefreshing) {
            self.status = YOSRefreshStatusRefreshing;
        }
        
    } else {
        // offsetY < 0 下拉
        // normal 状态只能让endRefresh触发,不能用位移去触发
        if (self.status != YOSRefreshStatusRefreshing) {
            self.status = YOSRefreshStatusNormal;
        }
    }
    
    NSLog(@"\r\r contentOffset : %@ - \r contentSize : %@ - \r contentInset : %@", NSStringFromCGPoint(self.scrollView.contentOffset), NSStringFromCGSize(self.scrollView.contentSize), NSStringFromUIEdgeInsets(self.scrollView.contentInset));
    
    NSLog(@"\r\r status : %zi, offsetY : %f", self.status, offset);
}

- (void)setStatus:(YOSRefreshStatus)status {
    
    // 1.一样的就直接返回(暂时不返回)
    if (self.status == status) return;
    
    // 2.旧状态
    YOSRefreshStatus oldState = self.status;
    
    // 3.存储状态
    _status = status;
    
    // 4.根据状态执行不同的操作
    switch (status) {
        case YOSRefreshStatusNormal: {
            [self.animView resume];
            
            if (oldState == YOSRefreshStatusRefreshing) {
                [UIView animateWithDuration:YOSRefreshFastAnimationDuration animations:^{
                    self.scrollView.contentInset = self.originalContentInset;
                }];
            } else {
                
            }
            break;
        }
            
        case YOSRefreshStatusPulling:
            break;
            
        case YOSRefreshStatusWillRefreshing:
            break;
            
        case YOSRefreshStatusRefreshing: {
            // 执行动画
            [UIView animateWithDuration:YOSRefreshFastAnimationDuration animations:^{
                // 1.增加滚动区域
                
                self.scrollView.contentInset = UIEdgeInsetsMake(self.originalContentInset.top, self.originalContentInset.left, [self refreshingBottom], self.originalContentInset.right);
                
            }];
            
            if (self.block) {
                self.block();
            }
            break;
        }
        default:
            break;
    }
    
}

#pragma mark - helper

- (CGFloat)contentSizeHeight {
    CGFloat contentSizeH = self.scrollView.contentSize.height;
    
    if (self.originalContentInset.bottom > 0) {
        contentSizeH += self.originalContentInset.bottom;
    }
    
    if (self.originalContentInset.bottom < 0) {
        // do nothing..
    }
    
    return contentSizeH;
}

- (CGFloat)judgePointOffset {
    // refreshView 添加到 scrollView 自身的 y = MAX(contentSize.height, frame.size.height) 处
    // offsetY < 0 下拉 | offsetY > 0 上拉
    // offsetY计算公式: contentOffset.y + frame.size.h - contentSize.h
    
    CGFloat currentOffsetY = self.scrollView.contentOffset.y;
    
    CGFloat frameH = self.scrollView.frame.size.height;
    
    CGFloat contentSizeH = [self contentSizeHeight];
    
    CGFloat offsetY = currentOffsetY + frameH - contentSizeH;
    
    return offsetY;
}

- (CGFloat)refreshingBottom {
    CGFloat bottom = YOSRefreshTopBottomHeight + self.originalContentInset.bottom;
    
    if (self.originalContentInset.bottom > 0) {
        // do nothing..
    }
    
    if (self.originalContentInset.bottom < 0) {
        bottom += ABS(self.originalContentInset.bottom);
    }
    
    return bottom;
}

#pragma mark - APIs

- (void)endRefresh {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.status = YOSRefreshStatusNormal;
    });
}

#pragma mark - getter & setter

- (TPullRefresh3DView *)animView {
    if (!_animView) {
        _animView = [TPullRefresh3DView pullRefreshView];
        [self addSubview:_animView];
    }
    
    return _animView;
}

@end

