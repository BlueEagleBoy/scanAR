//
//  BLEImageView.m
//  scanAR
//
//  Created by BlueEagleBoy on 16/3/17.
//  Copyright © 2016年 BlueEagleBoy. All rights reserved.
//

#import "BLEImageView.h"

@implementation BLEImageView

- (instancetype)initWithImage:(UIImage *)image {
    if ([super initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)]) {
        
        self.image = image;
    }
    
    return self;
}

- (void)setImage:(UIImage *)image {
    
    _image = image;
    
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect {

    [self.image drawInRect:rect];
}


@end
