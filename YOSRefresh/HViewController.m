//
//  HViewController.m
//  YOSRefresh
//
//  Created by yangyang on 2016/11/17.
//  Copyright © 2016年 shoppingm.cn. All rights reserved.
//

#import "HViewController.h"
#import "YOSRefresh.h"

@interface HViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation HViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.scrollView = [UIScrollView new];
    [self.view addSubview:self.scrollView];
    
//    self.scrollView.contentSize = CGSizeMake(2000, 200);
    self.scrollView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200);
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 50, 0, 50);
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *v = [UIView new];
    [self.scrollView addSubview:v];
    
    v.frame = CGRectMake(0, 50, 50, 50);
    v.backgroundColor = [UIColor purpleColor];
    
    UIView *v2 = [UIView new];
    [self.scrollView addSubview:v2];
    
    v2.frame = CGRectMake(320 - 50, 50, 50, 50);
    v2.backgroundColor = [UIColor purpleColor];
    
    //    [self.scrollView addHeaderWithCallback:^{
    //        NSLog(@"23");
    //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //            [self.scrollView headerEndRefreshing];
    //        });
    //    }];
    
    //    [self.scrollView yos_addTopRefresh:^{
    //        NSLog(@"1231231");
    //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //            [self.scrollView yos_endTopRefresh];
    //        });
    //    }];
    
    //    [self.webView.scrollView addFooterWithCallback:^{
    //        NSLog(@"d...");
    //    }];
    
    self.scrollView.backgroundColor = [UIColor yellowColor];
    
    
    [self.scrollView yos_addRightRefresh:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.scrollView yos_endRightRefresh];
        });
    }];
    
//    [self.scrollView yos_addLeftRefresh:^{
//    
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self.scrollView yos_endLeftRefresh];
//        });
//        
//    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
