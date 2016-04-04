//
//  BLECollectionViewCell.m
//  BLETitleController
//
//  Created by BlueEagleBoy on 16/3/20.
//  Copyright © 2016年 BlueEagleBoy. All rights reserved.
//

#import "BLETitleViewCell.h"
#define BLESelectedColor [UIColor orangeColor]
#define BLENormalColor [UIColor blackColor]

#define BLESelectedFontSize [UIFont systemFontOfSize:18]
#define BLENormalFontSize [UIFont systemFontOfSize:14]

@interface BLETitleViewCell ()

@property (nonatomic, weak)UILabel *label;

@end

@implementation BLETitleViewCell


//当点击被标记的时候 就重新布局 改变label的字体
- (void)setIsSelected:(BOOL)isSelected {
    
    _isSelected = isSelected ;
    
    [self setupLabel];
}

//设置title
- (void)setTitle:(NSString *)title {
    
    _title = title;
    
    self.label.text = title;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        UILabel *label = [[UILabel alloc]initWithFrame:self.contentView.bounds];
        
        self.label = label;
        
        label.textAlignment = NSTextAlignmentCenter;
        
        [self.contentView addSubview:self.label];

    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    [self setupLabel];
}

- (void)setupLabel {
    
    //根据是否选中 设置label的字体颜色 和 大小
    self.label.textColor = self.isSelected ? BLESelectedColor : BLENormalColor;
    
    self.label.font = self.isSelected ? BLESelectedFontSize : BLENormalFontSize;

}


@end

