//
//  BLEBackgroundView.m
//  scanAR
//
//  Created by BlueEagleBoy on 16/3/11.
//  Copyright © 2016年 BlueEagleBoy. All rights reserved.
//

#import "BLEBackgroundView.h"
#import "Masonry.h"

@interface BLEBackgroundView ()

@property (nonatomic, strong)UIImageView *bgIcon;
@property (nonatomic, strong)UIButton *findBtn;
@property (nonatomic, strong)UILabel *tipLabel;
@end

@implementation BLEBackgroundView

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        UIImageView *bgIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"UNInfo_image_sad"]];
        self.bgIcon = bgIcon;
        [bgIcon sizeToFit];
        
        UIButton *findBtn = [[UIButton alloc]init];
        self.findBtn = findBtn;
        [self.findBtn setBackgroundImage:[UIImage imageNamed:@"find_search_hot_button_bg"] forState:UIControlStateNormal];
        [self.findBtn setTitle:@"去发现" forState:UIControlStateNormal];
        self.findBtn.layer.cornerRadius = 13;
        self.findBtn.layer.masksToBounds = YES;
        [self.findBtn setFont:[UIFont systemFontOfSize:12]];
        
        
        UILabel *tipLabel = [[UILabel alloc]init];
        self.tipLabel = tipLabel;
        self.tipLabel.text = @"相册为空\n 快去拍摄AR照片惊爆他人眼球";
        self.tipLabel.textAlignment = NSTextAlignmentCenter;
        self.tipLabel.numberOfLines = 0;
        self.tipLabel.font = [UIFont systemFontOfSize:14];
        self.tipLabel.textColor = [UIColor lightGrayColor];
        
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self addSubview:self.bgIcon];
    [self addSubview:self.findBtn];
    [self addSubview:self.tipLabel];
    
    [self.bgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self).offset(60);
        
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.bgIcon.mas_bottom).offset(40);
        
    }];
    
    [self.findBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.tipLabel.mas_bottom).offset(20);
        make.width.mas_equalTo(100);
        
    }];
    

    
    
}

@end
