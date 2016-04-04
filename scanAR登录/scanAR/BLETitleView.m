
//
//  BLECollectionView.m
//  BLETitleController
//
//  Created by BlueEagleBoy on 16/3/20.
//  Copyright © 2016年 BlueEagleBoy. All rights reserved.
//

#import "BLETitleView.h"
#import "BLETitleViewCell.h"
#define BLECellId @"cell_id"

@interface BLETitleView ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, weak)BLETitleViewCell *lastSelectedCell;

@property (nonatomic, strong)NSIndexPath *lastIndexPath;

@end

@implementation BLETitleView


- (void)setTitleArr:(NSArray *)titleArr {
    
    _titleArr = titleArr;
    
    [self reloadData];
}

- (void)setSelectedTitle:(NSInteger)selectedTitle {
    
    _selectedTitle = selectedTitle;
    self.lastSelectedCell.isSelected = NO;
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:selectedTitle inSection:0];
    BLETitleViewCell *cell = (BLETitleViewCell *)[self cellForItemAtIndexPath:indexPath];
    
    self.lastIndexPath = indexPath;
    self.lastSelectedCell = cell;
    cell.isSelected = YES;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        
        //设置collectionvview 的基本布局
        [self setupFlowLayout];
        
        self.dataSource = self;
        self.delegate = self;
        [self registerClass:[BLETitleViewCell class] forCellWithReuseIdentifier:BLECellId];
    }
    
    return self;
}

- (void)setupFlowLayout {

    self.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    
    flowLayout.itemSize = CGSizeMake(50, 44);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.showsHorizontalScrollIndicator = 0;
    self.showsVerticalScrollIndicator = 0;
  
    
}


#pragma mark 数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.titleArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BLETitleViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:BLECellId forIndexPath:indexPath];
    
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

    BLETitleViewCell *cell = (BLETitleViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    cell.isSelected = YES;
    
    self.lastSelectedCell = cell;
    
    self.lastIndexPath = indexPath;
    
    if (self.myBlock) {
        
        self.myBlock(indexPath.item);
    }
    
}

//防止重用cell导致当前被点击的cell的选中状态消失
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BLETitleViewCell *customCell = (BLETitleViewCell *)cell;
    if (indexPath.item == self.lastIndexPath.item) {
        
        customCell.isSelected = YES;
    }
}




@end
