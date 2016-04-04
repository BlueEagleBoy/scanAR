//
//  BLENavigationController.m
//  scanAR
//
//  Created by BlueEagleBoy on 16/3/8.
//  Copyright © 2016年 BlueEagleBoy. All rights reserved.
//

#import "BLENavigationController.h"

@interface BLENavigationController ()

@end

@implementation BLENavigationController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBar.backgroundColor = [UIColor redColor];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupNavigationBar];
}

- (void)setupNavigationBar {
    
    self.navigationBar.tintColor = [UIColor orangeColor];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"mainVC_top_backButton_image"] style:UIBarButtonItemStyleDone target:self action:@selector(didClickGoBack)];
    
    self.navigationItem.leftBarButtonItem = backItem;
    
}

- (void)didClickGoBack {
    
    [self popViewControllerAnimated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    return UIStatusBarStyleDefault;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
