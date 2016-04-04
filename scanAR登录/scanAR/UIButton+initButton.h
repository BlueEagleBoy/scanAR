//
//  UIButton+initButton.h
//  LoginPage
//
//  Created by BlueEagleBoy on 16/3/7.
//  Copyright © 2016年 BlueEagleBoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (initButton)

#pragma make  设置button的图片
- (void)buttonWithImage:(NSString *)normalName selectedImage:(NSString *)selectedName bgNormalImage:(NSString *)bgNormalName bgSelectedImage:(NSString *)bgSelectedImage title:(NSString *)title;

- (void)buttonWithImage:(NSString *)normalName selectedImage:(NSString *)selectedName;

- (void)buttonWithImage:(NSString *)normalName backgroundImage:(NSString *)backgroundName;


#pragma make 设置button的字体颜色
- (void)setTitleNormalColor:(UIColor *)normalColor selectedColor:(UIColor *)selectedColor;

@end
