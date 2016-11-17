//
//  ViewController.m
//  YOSRefresh
//
//  Created by yangyang on 2016/11/16.
//  Copyright © 2016年 shoppingm.cn. All rights reserved.
//

#import "ViewController.h"
#import "MJRefresh.h"
#import "YOSRefresh.h"
#import "HViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView = [UIScrollView new];
    [self.view addSubview:self.scrollView];
    
    self.scrollView.contentSize = CGSizeMake(320, 2000);
    self.scrollView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 400);
    self.scrollView.contentInset = UIEdgeInsetsMake(-50, 0, 50, 0);
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *v = [UIView new];
    [self.scrollView addSubview:v];
    
    v.frame = CGRectMake(50, 0, 50, 50);
    v.backgroundColor = [UIColor purpleColor];
    
    UIView *v2 = [UIView new];
    [self.scrollView addSubview:v2];
    
    v2.frame = CGRectMake(50, 1950, 50, 50);
    v2.backgroundColor = [UIColor purpleColor];
    
//    [self.scrollView addHeaderWithCallback:^{
//        NSLog(@"23");
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self.scrollView headerEndRefreshing];
//        });
//    }];
    
    [self.scrollView yos_addTopRefresh:^{
        NSLog(@"1231231");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.scrollView yos_endTopRefresh];
        });
    }];
    
//    [self.webView.scrollView addFooterWithCallback:^{
//        NSLog(@"d...");
//    }];
    
    self.scrollView.backgroundColor = [UIColor yellowColor];
    [self.scrollView yos_addBottomRefresh:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.scrollView yos_endBottomRefresh];
        });
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self presentViewController:[HViewController new] animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
