//
//  BLETarBar.h
//  LoginPage
//
//  Created by BlueEagleBoy on 16/3/7.
//  Copyright © 2016年 BlueEagleBoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BLETabBar : UIView


//设置图片
@property (nonatomic, strong)NSArray *images;

//设置标题
@property (nonatomic, strong)NSArray *titles;

//点击item的回调block
@property (nonatomic, copy)void (^myBlock)(NSInteger);


// 设置不同状态下的item颜色
- (void)setupButtonNormalColor:(UIColor *)normalColor selectedColor:(UIColor *)selectedColor;


/**
 *  normalNames: 普通状态的图片数组
 *
 *  selectedSuf : 选中状态的图片后缀
 *
 *  backgroundSuf: 背景图片的图片后缀
 */
//设置图片 只需要穿入一个普通状态下图片数组
- (void)setupButtonWithNormalImageNames:(NSArray *)normalNames withSelectedSuffix:(NSString *)selectedSuf withBackgroundSuffix:(NSString *)backgroundSuf;

@end
