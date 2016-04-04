//
//  BLEPhotosController.m
//  scanAR
//
//  Created by BlueEagleBoy on 16/3/7.
//  Copyright © 2016年 BlueEagleBoy. All rights reserved.
//

#import "BLEPhotosController.h"
#import "BLEFileTools.h"
#import "BLEPhotoCell.h"
#import "BLEBackgroundView.h"

#define BLECellId @"cell_id"
@interface BLEPhotosController ()

@property (nonatomic, strong)NSMutableArray *images;
@property (nonatomic, strong)BLEFileTools *tools;
@property (nonatomic, weak)UILabel *titleLabel;
@property (nonatomic, assign)NSInteger currentIndex;
@property (nonatomic, strong)UIBarButtonItem *buttonItem;
@property (nonatomic, strong)BLEBackgroundView *bgView;

@end

@implementation BLEPhotosController

- (NSMutableArray *)images {
    
    if (!_images) {
        
        _images = [NSMutableArray array];
    }
    return _images;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    BLEFileTools *tools = [BLEFileTools sharedInstance];
    
    self.tools = tools;
    
    self.images = (NSMutableArray *)[tools readImagesFromFile];
    
    if (self.images == 0) {
    }
    
    DLog(@"%@",NSHomeDirectory());
    self.collectionView.backgroundColor = [UIColor whiteColor];
   
    [self setupUI];
}

#pragma mark collectionview的布局
- (void)setupUI {
    
    //注册photoCell
    UINib *cellNib = [UINib nibWithNibName:@"PhotoCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:BLECellId];
    
    //布局对象
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    
    //设置collectionView的布局
    flowLayout.itemSize = CGSizeMake(self.collectionView.frame.size.width,self.collectionView.frame.size.height - BLENavigationBarHeight);
    
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView.scrollEnabled = YES;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    

    //设置titileView
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    self.titleLabel = label;
    self.titleLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)self.currentIndex,(unsigned long)self.images.count];
    [self.navigationItem setTitleView:label];
    
}



#pragma mark collectionView的代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BLEPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:BLECellId forIndexPath:indexPath];
    
    UIImage *image = self.images[indexPath.row];
    
    cell.image = image;
 
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    CGFloat offsetX = scrollView.contentOffset.x / BLEScreenWidth;
    
    self.currentIndex = offsetX;
    
    self.titleLabel.text = [NSString stringWithFormat:@"%d/%ld",self.currentIndex + 1,(unsigned long)self.images.count];
    
    DLog(@"currentIndex:%ld",self.currentIndex);

}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupNavigationBar];
    
    //无图片的情况下设置背景图片
    BLEBackgroundView *bgView = [[BLEBackgroundView alloc]initWithFrame:self.collectionView.frame];
    self.bgView = bgView;
    bgView.hidden = self.images.count > 0;
    [self.collectionView addSubview:bgView];
}


- (void)setupNavigationBar {
    //设置显示navigationbar
    self.navigationController.navigationBar.hidden = NO;
    
    //设置背景图片
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"allAR_topBar_bg"] forBarMetrics:UIBarMetricsDefault];
   
    if (self.images.count == 0) {
        
        [self setupNavigationWithNoImage];
        return;
    }
    
    self.currentIndex = 1;
    self.titleLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)self.currentIndex,(unsigned long)self.images.count];
    
    //添加右侧删除按钮
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"mainVC_dynamic_delete_image"] style:UIBarButtonItemStyleDone target:self action:@selector(didClickDeletedItem)];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    
    self.buttonItem = barButtonItem;
    
}

//无图片下的导航拦
- (void)setupNavigationWithNoImage {
    
    self.titleLabel.text = @"我的相册";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]init];
    
}

#pragma mark 点击删除当前图片
- (void)didClickDeletedItem {
    
    //删除图片数组中当前索引下的图片
    [self.images removeObjectAtIndex:self.currentIndex - 1];
    
    //刷新colelctioView
    [self.collectionView reloadData];
    
    
    NSMutableArray *dataImages = [NSMutableArray array];
    for (UIImage *image in self.images) {
        
        NSData *dataImage = UIImagePNGRepresentation(image);
        
        [dataImages addObject:dataImage];
    }

    [self.tools writeToFileWithImages:dataImages];
    
    //刷新沙盒机制
    if (self.images.count == 0) {
        
        [self setupNavigationWithNoImage];
        
        self.bgView.hidden = NO;
        
        return;
    }
    
    self.titleLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)self.currentIndex,(unsigned long)self.images.count];
    
    
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
