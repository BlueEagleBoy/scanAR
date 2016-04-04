//
//  BLEFindController.m
//  scanAR
//
//  Created by BlueEagleBoy on 16/3/19.
//  Copyright © 2016年 BlueEagleBoy. All rights reserved.
//

#import "BLEFindController.h"
#import "BLECollectionViewCell.h"
#import "BLERequestData.h"
#import "BLETitleModel.h"
#import "AFNetworking.h"
#import "BLETitleView.h"
#import "BLEEntityModel.h"
#import "BLECommentController.h"

#define BLECellId @"cell_Id"
@interface BLEFindController ()

@property (nonatomic, strong)BLETitleView *titleView;
@property (nonatomic, strong)NSArray *titleArr;
@property (nonatomic, strong)NSMutableArray *titleModels;
@property (nonatomic, strong)BLECollectionViewCell *cell;


@end

@implementation BLEFindController

- (NSArray *)titleArr {
    
    if (!_titleArr) {
        _titleArr = [NSArray array];
    }
    return _titleArr;
}

- (NSMutableArray *)titleModels {
    if (!_titleModels) {
        _titleModels = [NSMutableArray array];
    }
    return _titleModels;
}

- (BLETitleView *)titleView {
    if (!_titleView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        
        _titleView = [[BLETitleView alloc]initWithFrame:CGRectMake(0, 0, BLEScreenWidth - 50, 44) collectionViewLayout:flowLayout];
    }
    
    return _titleView;
}


//请求标题数据
- (void)requestTitle {
    
    BLERequestData *tool = [BLERequestData sharedInstance];
    
    __weak typeof(self)__weakSelf = self;
    
    //请求标题数据
    [tool requestTitleModelWithSuccess:^(NSArray *responseTask) {
        
        //添加一个全部AR
        BLETitleModel *model = [[BLETitleModel alloc]init];
        model.indexId = 0;
        model.name = @"全部";

        [self.titleModels addObjectsFromArray:responseTask];
        [self.titleModels insertObject:model atIndex:0];
        
        NSMutableArray *titles = [NSMutableArray array];
        
        for (BLETitleModel *model in self.titleModels) {

            [titles addObject:model.name];
        }
        
        __weakSelf.titleView.titleArr = titles;
        
        //刷新标题数据
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [__weakSelf.collectionView reloadData];
            
        });
        
    } fause:^(NSError *error) {
        
        DLog(@"%@",error);
        
    }];
    
    
    self.titleView.myBlock = ^(NSInteger index) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
        
        BLETitleModel *model = __weakSelf.titleModels[index];
        
        __weakSelf.cell.index = model.indexId;
        
        [__weakSelf.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    };
}

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestTitle];
    [self.collectionView registerClass:[BLECollectionViewCell class] forCellWithReuseIdentifier:BLECellId];
    [self setup];
    [self setupNavigationBar];
    
    //接收来自BLEFindCell中图片的点击事件
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushEntityController:) name:BLEPushEntityController object:nil];
}

- (void)setup {
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    flowLayout.itemSize = CGSizeMake(BLEScreenWidth, BLEScreenHeight);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    self.collectionView.pagingEnabled = YES;
}

//设置导航栏
- (void)setupNavigationBar {
    
    self.tabBarController.navigationItem.titleView = self.titleView;
    
    self.tabBarController.navigationController.navigationBarHidden = NO;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"find_search_button_bg"] style:UIBarButtonItemStyleDone target:self action:@selector(didClickSearchBar)];
    
    self.tabBarController.navigationItem.rightBarButtonItem = rightItem;
}


- (void)pushEntityController:(NSNotification *)notity {

    BLEEntityModel *model = notity.userInfo[@"entitymodel"];
    
    NSLog(@"%@,%@",model.content,model.likeCount);
    
    BLECommentController *comment = [[BLECommentController alloc]init];
    
    comment.entityModel = model;
    
    [self.navigationController pushViewController:comment animated:YES];
}


- (void)didClickSearchBar {
    
    DLog(@"didClickSearchBar");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 数据源方法

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.titleArr.count == 0 ? 7 : self.titleArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BLECollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:BLECellId forIndexPath:indexPath];
    
    if (self.titleModels.count != 0 ) {
        
        self.cell = cell;
        BLETitleModel *model = self.titleModels[indexPath.item];
        cell.index = model.indexId;
    }
    
    return cell;
}



- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}



@end
