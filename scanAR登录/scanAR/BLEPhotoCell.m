//
//  BLEPhotoCell.m
//  scanAR
//
//  Created by BlueEagleBoy on 16/3/8.
//  Copyright © 2016年 BlueEagleBoy. All rights reserved.
//

#import "BLEPhotoCell.h"

@interface BLEPhotoCell ()
@property (weak, nonatomic) IBOutlet UIImageView *icon;

@end

@implementation BLEPhotoCell

- (void)setImage:(UIImage *)image {
    
    _image = image;
    
    self.icon.image = image;
}

@end
