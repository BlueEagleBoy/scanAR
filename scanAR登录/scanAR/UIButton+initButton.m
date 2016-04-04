//
//  UIButton+initButton.m
//  LoginPage
//
//  Created by BlueEagleBoy on 16/3/7.
//  Copyright © 2016年 BlueEagleBoy. All rights reserved.
//

#import "UIButton+initButton.h"

@implementation UIButton (initButton)

#pragma  make 设置图片
- (void)buttonWithImage:(NSString *)normalName selectedImage:(NSString *)selectedName bgNormalImage:(NSString *)bgNormalName bgSelectedImage:(NSString *)bgSelectedName title:(NSString *)title {
    
    
    if (normalName.length > 0 ) {
        [self setImage:[UIImage imageNamed:normalName] forState:UIControlStateNormal];
    }
    
    if (selectedName.length > 0) {
        
        [self setImage:[UIImage imageNamed:selectedName] forState:UIControlStateSelected];
    }
    
    if (bgNormalName.length > 0) {
        
        [self setBackgroundImage:[UIImage imageNamed:bgNormalName] forState:UIControlStateNormal];
    }
    
    if (bgSelectedName.length > 0) {
        
        [self setBackgroundImage:[UIImage imageNamed:bgSelectedName] forState:UIControlStateSelected];
    }
   
    [self setTitle:title forState:UIControlStateNormal];
    
    [self setupButton];
    
}

- (void)buttonWithImage:(NSString *)normalName selectedImage:(NSString *)selectedName {

    if (normalName.length > 0 ) {
        [self setImage:[UIImage imageNamed:normalName] forState:UIControlStateNormal];
    }
    
    if (selectedName.length > 0) {
        
        [self setImage:[UIImage imageNamed:selectedName] forState:UIControlStateSelected];
    }
    
    [self setupButton];

    
}

- (void)buttonWithImage:(NSString *)normalName backgroundImage:(NSString *)backgroundName {
    
    if (normalName.length > 0 ) {
        [self setImage:[UIImage imageNamed:normalName] forState:UIControlStateNormal];
    }
    
    if (backgroundName.length > 0) {
        
        [self setBackgroundImage:[UIImage imageNamed:backgroundName] forState:UIControlStateNormal];
    }
    
    [self setupButton];
 
}

#pragma make 设置button 的基本布局
- (void)setupButton {
    
    self.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    
}

#pragma make 设置title的颜色
- (void)setTitleNormalColor:(UIColor *)normalColor selectedColor:(UIColor *)selectedColor {
    
    [self setTitleColor:normalColor forState:UIControlStateNormal];
    [self setTitleColor:selectedColor forState:UIControlStateSelected];
    
}

@end
