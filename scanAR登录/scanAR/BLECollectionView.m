
//
//  BLECollectionView.m
//  BLETitleController
//
//  Created by BlueEagleBoy on 16/3/20.
//  Copyright © 2016年 BlueEagleBoy. All rights reserved.
//

#import "BLECollectionView.h"
#import "BLECollectionViewCell.h"
#define BLECellId @"cell_id"

@interface BLECollectionView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, weak)BLECollectionViewCell *lastSelectedCell;

@property (nonatomic, strong)NSIndexPath *lastIndexPath;

@end

@implementation BLECollectionView


- (void)setTitleArr:(NSArray *)titleArr {
    
    _titleArr = titleArr;
    
    [self reloadData];
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        
        //设置collectionvview 的基本布局
        [self setupFlowLayout];
        
        self.dataSource = self;
        self.delegate = self;
        [self registerClass:[BLECollectionViewCell class] forCellWithReuseIdentifier:BLECellId];
        
    }
    
    return self;
}

- (void)setupFlowLayout {

    self.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    
    flowLayout.itemSize = CGSizeMake(50, 44);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    
    self.showsHorizontalScrollIndicator = 0;
    self.showsVerticalScrollIndicator = 0;
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    
}


#pragma mark 数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.titleArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BLECollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:BLECellId forIndexPath:indexPath];
    
    cell.title = self.titleArr[indexPath.item];
    
    
    if (indexPath.item == 0 && !self.lastSelectedCell) {
        
        cell.isSelected = YES;
        self.lastIndexPath = indexPath;
        self.lastSelectedCell = cell;
        
    }else if (indexPath.item != self.lastIndexPath.item) {
        
        cell.isSelected = NO;
    }
    
    return cell;
}

#pragma  mark 代理方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    self.lastSelectedCell.isSelected = NO;

    BLECollectionViewCell *cell = (BLECollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    cell.isSelected = YES;
    
    self.lastSelectedCell = cell;
    
    self.lastIndexPath = indexPath;
    
}

//防止重用cell导致当前被点击的cell的选中状态消失
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BLECollectionViewCell *customCell = (BLECollectionViewCell *)cell;
    if (indexPath.item == self.lastIndexPath.item) {
        
        customCell.isSelected = YES;
    }
}




@end
