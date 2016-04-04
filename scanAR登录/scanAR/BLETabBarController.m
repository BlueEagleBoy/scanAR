//
//  BLETabBarController.m
//  scanAR
//
//  Created by BlueEagleBoy on 16/3/7.
//  Copyright © 2016年 BlueEagleBoy. All rights reserved.
//

#import "BLETabBarController.h"
#import "BLEFindController.h"
#import "BLEScanController.h"
#import "BLEProfileController.h"
#import "BLETabBar.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "BLETitleModel.h"
#import "ViewController.h"
#import "BLENavigationController.h"

@interface BLETabBarController ()

@property (nonatomic, strong)UINavigationController *findNav;
@property (nonatomic, strong)UINavigationController *scanNav;
@property (nonatomic, strong)UINavigationController *profileNav;

@end

@implementation BLETabBarController

- (UINavigationController *)findNav {
    
    if (!_findNav) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        BLEFindController *findVc = [[BLEFindController alloc]initWithCollectionViewLayout:flowLayout];
        _findNav = [[UINavigationController alloc]initWithRootViewController:findVc];
    }
    return _findNav;
}

- (UINavigationController *)scanNav {
    
    if (!_scanNav) {
       UIViewController *scanVc = [[ViewController alloc]init];
        _scanNav = [[UINavigationController alloc]initWithRootViewController:scanVc];
    }
    return _scanNav;
}

- (UINavigationController *)profileNav {
    
    
    if (!_profileNav) {
        UIViewController *profileVc = [[UIStoryboard storyboardWithName:@"Profile" bundle:nil]instantiateInitialViewController];
        
        _profileNav = [[UINavigationController alloc]initWithRootViewController:profileVc];
    }
    
    return _profileNav;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestTitleData];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    
    [self addChildViewController:self.findNav];
    [self addChildViewController:self.scanNav];
    [self addChildViewController:self.profileNav];
    
    self.selectedIndex = 0;
    
    BLETabBar *customTabBar = [[BLETabBar alloc]initWithFrame:self.tabBar.bounds];
    
    customTabBar.titles = @[@"发现",@"扫描",@"我的"];

    [self.tabBar addSubview:customTabBar];
    
    [customTabBar setupButtonNormalColor:[UIColor lightGrayColor] selectedColor:[UIColor orangeColor]];
    
    NSArray *images = @[@"find_button_image",@"scan_button_image",@"my_button_image"];
    [customTabBar setupButtonWithNormalImageNames:images withSelectedSuffix:@"_select" withBackgroundSuffix:nil];
    
    customTabBar.myBlock = ^(NSInteger selectedIndex) {
        
        self.selectedIndex = selectedIndex;
    
    };
}

- (void)requestTitleData {
    
    NSDictionary *parameter = @{@"lang":@"zh_cn" };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    __weak typeof(self) weakSelf = self;
    [manager GET:BLECategoryARUrlString parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *arr = responseObject[@"result"];
        
        NSMutableArray *titleArr = [NSMutableArray array];
        
        for (NSDictionary *dict in arr) {
            
            [titleArr addObject:[BLETitleModel mj_objectWithKeyValues:dict]];
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (!error ) {
            
            DLog(@"error:%@",error);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
