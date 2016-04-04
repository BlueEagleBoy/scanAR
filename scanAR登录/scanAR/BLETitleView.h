//
//  BLECollectionView.h
//  BLETitleController
//
//  Created by BlueEagleBoy on 16/3/20.
//  Copyright © 2016年 BlueEagleBoy. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^block)(NSInteger index);
@interface BLETitleView : UICollectionView

@property (nonatomic ,strong)NSArray *titleArr;

@property (nonatomic, copy)block myBlock;



@end
