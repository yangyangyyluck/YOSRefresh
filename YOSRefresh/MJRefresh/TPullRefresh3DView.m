//
//  TPullRefresh3DView.m
//  TGodAnimationTest
//
//  Created by yangyang on 16/6/12.
//  Copyright © 2016年 kuailai.inc. All rights reserved.
//

#import "TPullRefresh3DView.h"
#import "MJRefreshConst.h"

static const CGFloat TPullRefreshViewDuration = 0.4;

@interface TPullRefresh3DView ()

@property (nonatomic, strong) CALayer *animLayer;

@property (nonatomic, assign) NSUInteger imageIndex;

@property (nonatomic, assign) NSUInteger currentPIIndex;

@property (nonatomic, assign, getter=isAnimating) BOOL animating;

@end

@implementation TPullRefresh3DView {
    
}

@synthesize percentage = _percentage;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (!self) {
        return nil;
    }
    
    return self;
}

- (void)didMoveToWindow {
    
    [super didMoveToWindow];
    
    [self.layer addSublayer:self.animLayer];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"%s", __func__);
    
    [self resume];
    
}

#pragma mark - getter & setter

- (CALayer *)animLayer {
    if (!_animLayer) {
        _animLayer = [CALayer layer];
        _animLayer.frame = self.bounds;
        _animLayer.contentsGravity = kCAGravityResizeAspectFill;
        _animLayer.contents = (__bridge id _Nullable)([self _randomImage].CGImage);
    }
    
    return _animLayer;
}

- (NSUInteger)imageIndex {
    if (!_imageIndex) {
        _imageIndex = arc4random_uniform(3) + 1;
    }
    
    return _imageIndex;
}

#pragma mark - animation delegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    if (self.percentage > 0.1) {
        [self _beginCustomAnimation];
    }
    
}

#pragma mark - private methods

- (UIImage *)_randomImage {
    NSString *imageStr = [NSString stringWithFormat:@"%zi.png", self.imageIndex];
    
    UIImage *image = [UIImage imageNamed:MJRefreshSrcName(imageStr)];
    
    self.imageIndex = (self.imageIndex) % 3 + 1;
    
    return image;
}

- (CATransform3D)_currentTransform3D {
    return CATransform3DMakeRotation((self.currentPIIndex) * M_PI_2, 0, 1, 0);
}

#pragma mark begin animation

- (void)_beginCustomAnimation {
    
    self.animating = YES;
    
    if (self.currentPIIndex % 2 == 1) {
        self.animLayer.contents = (__bridge id _Nullable)([self _randomImage].CGImage);
    }
    
    self.currentPIIndex += 1;
    
    CABasicAnimation *anim0 = [CABasicAnimation animationWithKeyPath:@"transform"];
    anim0.toValue = [NSValue valueWithCATransform3D:[self _currentTransform3D]];
    anim0.duration = TPullRefreshViewDuration;
    anim0.delegate = self;
    anim0.removedOnCompletion = NO;
    anim0.fillMode = kCAFillModeForwards;
    
    [self.animLayer addAnimation:anim0 forKey:nil];
}

#pragma mark - public methods

- (void)setPercentage:(CGFloat)percentage {
    // 100%
    if (percentage >= 1.0) {
        percentage = 1.0;
    }
    
    _percentage = percentage;
    
    NSLog(@"\r %f", _percentage);
    
    if (!self.isAnimating && _percentage > 0.1) {
        [self _beginCustomAnimation];
    } else if (_percentage <= 0.1) {
        [self resume];
    }
}

- (void)executeCustomAnimation {
    // do nothing..
    return;
}


- (void)resume {
    
    NSLog(@"\r\n\r\n resume \r\n\r\n");
    
    self.animLayer.transform = CATransform3DIdentity;
    
    [self.animLayer removeAllAnimations];
    
    self.currentPIIndex = 0;
    
    _percentage = 0.0;
    
    self.animating = NO;
}

@end
