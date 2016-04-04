//
//  BLEFindCollectionController.m
//  LoginPage
//
//  Created by BlueEagleBoy on 16/3/7.
//  Copyright © 2016年 BlueEagleBoy. All rights reserved.
//

#import "BLEFindBaseController.h"

#import "BLECommentController.h"
#import "BLEFileTools.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>
#import "BLEFindCell.h"
#import "BLEUnityModel.h"
#import "BLEEntityModel.h"

#import "MJExtension.h"
#import "MJRefreshBackNormalFooter.h"
#import "MJRefreshNormalHeader.h"
#import "BLEUserResultModel.h"
#import "BLERequestData.h"

#define  BLECellId @"Cell_Id"

typedef enum {
    
    BLERequestDataWayNormal,
    BLERequestDataWayDown,
    BLERequestDataWayUp
    
    
}BLERequestDataWay;

@interface BLEFindBaseController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)BLEFileTools *tools;
@property (nonatomic,strong)NSMutableArray *images;
@property (nonatomic, weak)UIImageView *imageView;
@property (nonatomic, strong)NSMutableArray *entityModels;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, assign)NSInteger currentPage;
@property (nonatomic, assign)BLERequestDataWay requestWay;

@end

@implementation BLEFindBaseController

//选中标题 加载cell中第一页的数据
- (void)setIndex:(NSInteger)index {
    
    _index = index;
    
    //默认开始刷新
    [self.tableView.mj_header beginRefreshing];
    //每次进入一个cell的时候默认从第一页开始加载
    self.currentPage = 1;
    self.requestWay = BLERequestDataWayNormal;
    [self reloadMoreDataWithCategory:index withPage:self.currentPage];
}

//懒加载实例数组
- (NSMutableArray *)entityModels {
    
    if (!_entityModels) {
        _entityModels = [NSMutableArray array];
        
    }
    
    return _entityModels;
}

//懒加载图片数组
- (NSMutableArray *)images {
    
    if (!_images) {
        _images = [NSMutableArray array];
    }
    
    return _images;
}
//懒加载tableView
- (UITableView *)tableView {
    
    if (!_tableView) {
        
        _tableView = [[UITableView alloc]init];
    }
    return _tableView;
}

- (void)loadView {
    
    [super loadView];
    
    [self.view addSubview:self.tableView];
    //设置tableView的frame
    self.tableView.frame = CGRectMake(0, 24, BLEScreenWidth, BLEScreenHeight - BLENavigationBarHeight-80);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    //设置tableview 的表头
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.currentPage++;
        self.requestWay = BLERequestDataWayDown;
        [self reloadMoreDataWithCategory:self.index withPage:self.currentPage];
    }];
    
    //设置tableView的表尾
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        [self reloadMoreDataWithCategory:self.index withPage:3];
    }];
    
    //自动切换透明度
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
}


//网络请求数据
- (void)reloadMoreDataWithCategory:(NSInteger)category withPage:(NSInteger)page {
    
    BLERequestData *dataTool = [BLERequestData sharedInstance];
    
    __weak typeof(self)__weakSelf = self;
        
        [dataTool requestEntityModelWithCategory:category withIndex:page withSuccessBlock:^(NSArray *responseTask) {
            
            if (self.requestWay == BLERequestDataWayNormal) {
                
                NSLog(@"点击title加载数据 ");
                //得到数据前先移除之前数组内容
                [self.entityModels removeAllObjects];
                
            }else if (self.requestWay == BLERequestDataWayDown) {
                
                NSLog(@"下啦刷新");
            }else if (self.requestWay == BLERequestDataWayUp){
                
                NSLog(@"上拉加载");
            }
            
            [self.entityModels addObjectsFromArray:responseTask];
            
            [__weakSelf.tableView reloadData];
            
            [__weakSelf.tableView.mj_header endRefreshing ];
            
        } fauseBlock:^(NSError *error) {
            
            NSLog(@"%@",error);
        }];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBarController.navigationController.navigationBarHidden = NO;
    
    //实例化单例本地文件工具
    BLEFileTools *tools = [BLEFileTools sharedInstance];
    self.tools = tools;
    
    UINib *nib = [UINib nibWithNibName:@"BLEFindCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:BLECellId];
    self.tableView.contentInset = UIEdgeInsetsMake(30, 0, 0, 0);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    //取出本地图片
    self.images = (NSMutableArray *)[self.tools readImagesFromFile];
}



#pragma  mark 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.entityModels.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BLEFindCell *cell = [tableView dequeueReusableCellWithIdentifier:BLECellId];
    
    cell.contentView.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.6];
    
    return cell;
    
}

#pragma mark cell将要显示方法
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BLEFindCell *cellRow = (BLEFindCell *)cell;
    
    BLEEntityModel *entityModel = self.entityModels[indexPath.row];
    
    cellRow.entityModel = entityModel;

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 210;
}



- (void)didClickButton {
    
    //开启图形上下文
    UIGraphicsBeginImageContext(CGSizeMake(BLEScreenWidth, BLEScreenHeight));
    
    //获取图形上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //渲染图层
    [self.view.layer renderInContext:ctx];
    
    //获取图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    NSData *imageData = UIImagePNGRepresentation(image);
    
    [self.images addObject:imageData];
    
    //保存图片到沙盒
    [self.tools writeToFileWithImages:self.images];
    
}

- (void)dealloc {
    
    NSLog(@"dealloc___________________________________");
}

@end
