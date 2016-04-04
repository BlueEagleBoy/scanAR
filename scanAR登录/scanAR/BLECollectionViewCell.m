//
//  BLECollectionViewCell.m
//  scanAR
//
//  Created by BlueEagleBoy on 16/3/19.
//  Copyright © 2016年 BlueEagleBoy. All rights reserved.
//

#import "BLECollectionViewCell.h"
#import "BLEFindBaseController.h"

@interface BLECollectionViewCell ()

@property (nonatomic, strong)BLEFindBaseController *findBaseVc;


@end

@implementation BLECollectionViewCell

- (void)setIndex:(NSInteger)index {
    
    _index = index;
    
    NSLog(@"%ld",(long)index);
    
    self.findBaseVc.index = index;
}


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        BLEFindBaseController *findBaseVc = [[BLEFindBaseController alloc]init];
        
        self.findBaseVc = findBaseVc;
        
    }
    
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    //防止循环引用
    __weak typeof(self)weakSelf = self;
    [self.contentView addSubview:weakSelf.findBaseVc.view];
    
}



@end
