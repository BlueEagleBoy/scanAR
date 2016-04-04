//
//  BLETarBar.m
//  LoginPage
//
//  Created by BlueEagleBoy on 16/3/7.
//  Copyright © 2016年 BlueEagleBoy. All rights reserved.
//

#import "BLETabBar.h"
#import "Masonry.h"
#import "UIButton+initButton.h"
#import "BLEFindBaseController.h"
#import "BLEScanController.h"
#import "BLEProfileController.h"

@interface BLETabBar ()

//添加Tabbar的子控件
@property (nonatomic)UIButton *findBtn;
@property (nonatomic)UIButton *scanBtn;
@property (nonatomic)UIButton *profileBtn;

@property (nonatomic)UIButton *lastClickButton;
@property (nonatomic, strong)NSMutableArray *items;

@end

@implementation BLETabBar

//懒加载数组 存放tabbar上的item
- (NSMutableArray *)items {
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}

//根据图片和标题 初始化tabBar的子控件
- (void)setImages:(NSArray *)images {
    
    _images = images;
    
    if (self.items.count == 0) {
        
        [self initButtonWithCount:images.count];
        
    }
    
    [self setupButtonWithCount:images.count];
    
}

- (void)setTitles:(NSArray *)titles {
    
    _titles = titles;
    
    if (self.items.count == 0) {
        
        [self initButtonWithCount:titles.count];
    }
    
    [self setupButtonWithCount:titles.count];

}

#pragma mark 创建item
- (void)initButtonWithCount:(NSInteger )count {
    
    //根据images 或者titles的个数 创建item
    for (int i = 0; i < count; i++) {
        
        UIButton *button = [[UIButton alloc]init];
        if (i == 0) {
            button.selected = YES;
            self.lastClickButton = button;
        }
        [button addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i + 1001;
        button.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
        [self addSubview:button];
        [self.items addObject:button];
        
    }
}


#pragma mark 赋值数据
- (void)setupButtonWithCount:(NSInteger)count {
    
    for (int i = 0; i < count; i++) {
        
        UIButton *button = self.items[i];
        
        //赋值数据
        if (self.images.count > 0) {
            
            UIImage *image = [UIImage imageNamed:self.images[i]];
            
            [button setImage:image forState:UIControlStateNormal];
            
        }
        
        if (self.titles.count > 0) {
            
            NSString *title = self.titles[i];
            
            [button setTitle:title forState:UIControlStateNormal];
        }
    }
}

#pragma mark 设置item的颜色
- (void)setupButtonNormalColor:(UIColor *)normalColor selectedColor:(UIColor *)selectedColor {
    
    for (UIButton *btn in self.items) {
        
        [btn setTitleColor:normalColor forState:UIControlStateNormal];
        [btn setTitleColor:selectedColor forState:UIControlStateSelected];
    }
    
}



#pragma mark 点击tabBar弹出控制器
- (void)didClickBtn:(UIButton *)sender {
    
    self.lastClickButton.selected = NO;
    
    sender.selected = YES;
    
    self.lastClickButton = sender;
    
    if (self.myBlock) {
    
        self.myBlock(sender.tag - 1001);
    }
}



- (void)layoutSubviews  {
    [super layoutSubviews];
    
    //遍历控件 约束布局
    for (int i = 0; i < self.items.count; i ++) {
        
        UIButton *button = self.items[i];
        
        //设置第一个item的约束
        if (i == 0) {
            
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.leading.mas_equalTo(self);
            }];
        }else {
            
            UIButton *lastBtn = self.items[i - 1];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.leading.mas_equalTo(lastBtn.mas_trailing);
                make.width.mas_equalTo(lastBtn);
            }];
        }
        
        //设置最后一个button的约束
        if (i == self.items.count - 1){
            
            [button mas_makeConstraints:^(MASConstraintMaker *make) {

                make.trailing.mas_equalTo(self);
            }];
        }
        
        //共有的约束
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.mas_equalTo(self);
            make.height.mas_equalTo(self);
        }];
    }
}

- (void)setupButtonWithNormalImageNames:(NSArray *)normalNames withSelectedSuffix:(NSString *)selectedSuf withBackgroundSuffix:(NSString *)backgroundSuf {
    
    if (self.items.count == 0) {
        
        [self initButtonWithCount:normalNames.count];
        
    }
    
    if (self.items.count != 0 ) {
        
        for (int i = 0; i < normalNames.count; i++) {
            
            {
                UIButton *button = self.items[i];
    
                NSString *normalImageName = normalNames[i];
                
                [button setImage:[UIImage imageNamed:normalImageName] forState:UIControlStateNormal];
                
                //判断是否有选择图片名称后缀
                if (selectedSuf.length > 0) {
                    
                     NSString *selectedImageName = [normalImageName stringByAppendingString:selectedSuf];
                    
                     [button setImage:[UIImage imageNamed:selectedImageName] forState:UIControlStateSelected];
                }
                
                //判断是否有背景图片名称后缀
                if (backgroundSuf.length > 0) {
                    
                    NSString *bgImageName = [normalImageName stringByAppendingString:backgroundSuf];
                    
                    [button setBackgroundImage:[UIImage imageNamed:bgImageName] forState:UIControlStateSelected];
                }
            }
        }
    }
}


@end
