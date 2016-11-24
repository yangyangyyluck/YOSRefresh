//
//  YOSRightRefreshView.m
//  YOSRefresh
//
//  Created by yangyang on 2016/11/17.
//  Copyright © 2016年 shoppingm.cn. All rights reserved.
//

#import "YOSRightRefreshView.h"
#import "TPullRefresh3DView.h"
#import "YOSRefreshConst.h"

@interface YOSRightRefreshView ()

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic, assign) BOOL hasInit;

@property (nonatomic, assign) YOSRefreshStatus status;

@property (nonatomic, assign) UIEdgeInsets originalContentInset;

@property (nonatomic, strong) TPullRefresh3DView *animView;

@end

@implementation YOSRightRefreshView

+ (instancetype)refreshView {
    return [YOSRightRefreshView new];
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
        self.scrollView.alwaysBounceHorizontal = YES;
        
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
    
    CGFloat contentSizeWidth = [self contentSizeWidth];
    
    CGFloat viewWidth = self.scrollView.frame.size.width;
    
    // set y
    CGRect frame = CGRectMake(MAX(viewWidth, contentSizeWidth), 0, YOSRefreshLeftRightWidth, self.scrollView.frame.size.height);
    self.frame = frame;
}

- (void)adjustStatus {
    CGFloat offset = [self judgePointOffset];
    
    // offsetY > 0 上拉
    if (offset > 0) {
        CGFloat absOffset = ABS(offset);
        
        CGFloat percentage = absOffset / YOSRefreshLeftRightWidth;
        percentage = MIN(1.0, percentage);
        
        self.animView.percentage = percentage;
        
        if (self.scrollView.isDragging) {
            
            if (0 < absOffset && absOffset < YOSRefreshLeftRightWidth) {
                self.status = YOSRefreshStatusPulling;
            } else if (absOffset >= YOSRefreshLeftRightWidth) {
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
                
                self.scrollView.contentInset = UIEdgeInsetsMake(self.originalContentInset.top, self.originalContentInset.left, self.originalContentInset.bottom, [self refreshingRight]);
                
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

- (CGFloat)contentSizeWidth {
    CGFloat contentSizeW = MAX(self.scrollView.contentSize.width, self.scrollView.frame.size.width - self.originalContentInset.right);
    
    if (self.originalContentInset.right > 0) {
        contentSizeW += self.originalContentInset.right;
    }
    
    if (self.originalContentInset.right < 0) {
        // do nothing..
    }
    
    return contentSizeW;
}

- (CGFloat)judgePointOffset {
    // refreshView 添加到 scrollView 自身的 y = MAX(contentSize.height, frame.size.height) 处
    // offsetY < 0 下拉 | offsetY > 0 上拉
    // offsetY计算公式: contentOffset.y + frame.size.h - contentSize.h
    
    CGFloat currentOffsetX = self.scrollView.contentOffset.x;
    
    CGFloat frameW = self.scrollView.frame.size.width;
    
    CGFloat contentSizeW = [self contentSizeWidth];
    
    CGFloat offsetX = currentOffsetX + frameW - contentSizeW;
    
    return offsetX;
}

- (CGFloat)refreshingRight {
    CGFloat bottom = YOSRefreshLeftRightWidth + self.originalContentInset.right;
    
    if (self.originalContentInset.right > 0) {
        // do nothing..
    }
    
    if (self.originalContentInset.right < 0) {
        bottom += ABS(self.originalContentInset.right);
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
