//
//  BLEImageView.h
//  scanAR
//
//  Created by BlueEagleBoy on 16/3/17.
//  Copyright © 2016年 BlueEagleBoy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BLEImageView : UIView

@property (nonatomic, strong)UIImage *image;
- (instancetype)initWithImage:(UIImage *)image;

@end
