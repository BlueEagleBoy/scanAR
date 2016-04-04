//
//  BLEFindCell.m
//  scanAR
//
//  Created by BlueEagleBoy on 16/3/15.
//  Copyright © 2016年 BlueEagleBoy. All rights reserved.
//

#import "BLEFindCell.h"
#import <UIImageView+WebCache.h>
#import "BLENameModel.h"
#import <MJExtension/MJExtension.h>

@interface BLEFindCell ()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *tagName;
@property (nonatomic, strong)UITapGestureRecognizer *tapGesture;



@end

@implementation BLEFindCell

- (UITapGestureRecognizer *)tapGesture {
    
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClickIcon:)];
    }
    
    return _tapGesture;
}

- (void)setEntityModel:(BLEEntityModel *)entityModel {
    
    _entityModel = entityModel;
    
    NSURL *url = [NSURL URLWithString:entityModel.photo];
    
    [self.icon sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"findAR_cell_title_image_bg"] ];
    
    self.titleLabel.text = entityModel.title;
    
    self.contentLabel.text = entityModel.content;
    
    if (entityModel.tags.count == 0) {
        
        self.tagName.hidden = YES;
        
    }else {
        
        BLENameModel *nameModel = [BLENameModel mj_objectWithKeyValues:entityModel.tags.lastObject];
        
        self.tagName.hidden = NO;
        [self.tagName setTitle:nameModel.tagName forState:UIControlStateNormal];
    }
}



- (void)awakeFromNib {
    
    self.icon.contentMode = UIViewContentModeScaleAspectFill;
    
    self.icon.userInteractionEnabled = YES;
    
    self.icon.clipsToBounds = YES;
    
    self.icon.image = [UIImage imageNamed:@"findAR_cell_title_image_bg"];
    
    self.icon.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didClickIcon:)];
    
    [self.icon addGestureRecognizer:gesture];
   
}


- (void)didClickIcon:(UIGestureRecognizer *)gesture {
   
    //点击图片手势  发送通知到findViewcontroller  push 出控制器
    [[NSNotificationCenter defaultCenter]postNotificationName:BLEPushEntityController object:nil userInfo:@{@"entitymodel":self.entityModel}];
   
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self]; 
}

@end
