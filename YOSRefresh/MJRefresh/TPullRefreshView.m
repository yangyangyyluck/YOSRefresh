//
//  TPullRefreshView.m
//  TGodAnimationTest
//
//  Created by yangyang on 16/2/19.
//  Copyright © 2016年 kuailai.inc. All rights reserved.
//

#import "TPullRefreshView.h"
#import "TPullRefresh3DView.h"
#import "MJRefreshConst.h"


static const CGFloat TPullRefreshViewDuration = 0.4;

@interface TPullRefreshView ()

@property (nonatomic, strong) CAShapeLayer *backLayer;

@property (nonatomic, strong) CAShapeLayer *fillLayer;

@property (nonatomic, strong) CALayer *smileLayer;

@property (nonatomic, strong) CALayer *cycleLayer;

@end

@implementation TPullRefreshView {
    
}

+ (instancetype)pullRefreshView {
    
    // 子类实现, 当前类不删除, 因为需求更改
    TPullRefresh3DView *refreshView = [TPullRefresh3DView new];
    
    refreshView.frame = CGRectMake(100, 100, 36, 36);
    
    return refreshView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (!self) {
        return nil;
    }
    
    return self;
}

- (void)didMoveToWindow {
    
    [super didMoveToWindow];

    [self.layer addSublayer:self.backLayer];
    [self.layer addSublayer:self.smileLayer];
    [self.layer addSublayer:self.fillLayer];
    [self.layer addSublayer:self.cycleLayer];
    
    self.layer.masksToBounds = NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s", __func__);
    
    [self resume];
    
}

#pragma mark - getter & setter

- (CAShapeLayer *)backLayer {
    if (!_backLayer) {
        _backLayer = [CAShapeLayer layer];
        _backLayer.frame = self.bounds;
        _backLayer.path = [UIBezierPath bezierPathWithOvalInRect:self.bounds].CGPath;
//        _backLayer.fillColor = [UIColor colorWithHexString:@"#0aa2f1"].CGColor;
        _backLayer.transform = CATransform3DMakeScale(0, 0, 1);
    }
    
    return _backLayer;
}

- (CALayer *)smileLayer {
    if (!_smileLayer) {
        _smileLayer = [CALayer layer];
        _smileLayer.frame = self.bounds;
        _smileLayer.contents = (__bridge id _Nullable)([UIImage imageNamed:MJRefreshSrcName(@"smile.png")].CGImage);
        _smileLayer.opacity = 0.0;
    }
    
    return _smileLayer;
}

- (CAShapeLayer *)fillLayer {
    if (!_fillLayer) {
        _fillLayer = [CAShapeLayer layer];
        _fillLayer.backgroundColor = [UIColor clearColor].CGColor;
        _fillLayer.fillColor = [UIColor whiteColor].CGColor;
        _fillLayer.frame = self.bounds;
        
        CGRect rect = CGRectInset(self.bounds, 4, 4);
        _fillLayer.path = [UIBezierPath bezierPathWithOvalInRect:rect].CGPath;
        _fillLayer.opacity = 0.0;
        _fillLayer.transform = CATransform3DMakeScale(0, 0, 1);
    }
    
    return _fillLayer;
}

- (CALayer *)cycleLayer {
    if (!_cycleLayer) {
        _cycleLayer = [CALayer layer];
        _cycleLayer.frame = self.bounds;
        _cycleLayer.contents = (__bridge id _Nullable)([UIImage imageNamed:MJRefreshSrcName(@"refreshCycle.png")].CGImage);
        _cycleLayer.opacity = 0.0;
    }
    
    return _cycleLayer;
}

#pragma mark - animation delegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    NSString *name = [anim valueForKey:@"name"];
    
    if ([name isEqualToString:@"fillAnimation"] && flag) {
        
        self.cycleLayer.opacity = 1.0;
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        animation.fromValue = @0;
        animation.toValue = @(M_PI * 2);
        animation.duration = 0.7;
        animation.repeatCount = MAXFLOAT;
        
        [self.cycleLayer addAnimation:animation forKey:@"cycleLayer"];
    }
    
    if ([name isEqualToString:@"backgroundAnimation"]) {
        self.backLayer.opacity = 0.0;
    }
    
}

#pragma mark - public methods

- (void)setPercentage:(CGFloat)percentage {
    // 100%
    if (percentage >= 1.0) {
        percentage = 1.0;
    }
    
    _percentage = percentage;
    
    self.backLayer.opacity = 1.0;
    self.backLayer.transform = CATransform3DMakeScale(percentage, percentage, 1.0);
    _smileLayer.opacity = percentage;
    
}

- (void)executeCustomAnimation {
    _fillLayer.opacity = 1.0;
    
    CABasicAnimation *fillAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    fillAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0, 0, 1)];
    fillAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
    fillAnimation.beginTime = CACurrentMediaTime();
    fillAnimation.duration = TPullRefreshViewDuration;
    fillAnimation.delegate = self;
    fillAnimation.removedOnCompletion = NO;
    fillAnimation.fillMode = kCAFillModeForwards;
    [fillAnimation setValue:@"fillAnimation" forKey:@"name"];
    
    [self.fillLayer addAnimation:fillAnimation forKey:nil];
    
    CABasicAnimation *backgroundAnimation = nil;
    // iOS9+
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0) {
        CASpringAnimation *springAnimation = [CASpringAnimation animationWithKeyPath:@"transform"];
        // 1.2
        springAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05, 1)];
        springAnimation.mass = 1;
        springAnimation.damping = 10;
        springAnimation.stiffness = 100;
        springAnimation.initialVelocity = 60;
        springAnimation.duration = TPullRefreshViewDuration;
        springAnimation.delegate = self;
        backgroundAnimation = springAnimation;
    } else {
        backgroundAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
        backgroundAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1)];
        // 1.4
        backgroundAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.25, 1.25, 1)];
        backgroundAnimation.beginTime = CACurrentMediaTime();
        backgroundAnimation.duration = TPullRefreshViewDuration;
        backgroundAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        backgroundAnimation.autoreverses = YES;
        backgroundAnimation.delegate = self;
    }
    
    [backgroundAnimation setValue:@"backgroundAnimation" forKey:@"name"];
    [self.backLayer addAnimation:backgroundAnimation forKey:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(TPullRefreshViewDuration / 2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.smileLayer.opacity = 0.0;
    });
}


- (void)resume {
    
    NSLog(@"\r\n\r\n resume \r\n\r\n");
    
    self.fillLayer.transform = CATransform3DMakeScale(0, 0, 1);
    [self.fillLayer removeAllAnimations];
    
    self.backLayer.opacity = 1.0;
    self.backLayer.transform = CATransform3DMakeScale(0, 0, 1);
    [self.backLayer removeAllAnimations];
    
    self.smileLayer.opacity = 0.0;
    [self.smileLayer removeAllAnimations];
    
    self.cycleLayer.opacity = 0.0;
    [self.cycleLayer removeAllAnimations];
    
    _percentage = 0.0;
}

@end
