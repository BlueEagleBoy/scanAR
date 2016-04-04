//
//  BLETCommentCell.m
//  scanAR
//
//  Created by BlueEagleBoy on 16/3/30.
//  Copyright © 2016年 BlueEagleBoy. All rights reserved.
//

#import "BLETCommentCell.h"
#import "UIImageView+WebCache.h"
#import "BLEUserModel.h"

@interface BLETCommentCell ()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *username;

@property (weak, nonatomic) IBOutlet UILabel *comment;
@property (weak, nonatomic) IBOutlet UILabel *tiemStemp;

@end

@implementation BLETCommentCell

- (void)setModel:(BLEUserModel *)model {
    
    _model = model;

    [self.icon sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"my_button_image"]];
    self.username.text = model.username;
    self.comment.text = model.content;
    self.tiemStemp.text = model.commentTime;
 
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
