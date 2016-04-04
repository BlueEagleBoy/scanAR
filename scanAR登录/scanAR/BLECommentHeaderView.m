//
//  BLECommentHeaderView.m
//  scanAR
//
//  Created by BlueEagleBoy on 16/3/25.
//  Copyright © 2016年 BlueEagleBoy. All rights reserved.
//

#import "BLECommentHeaderView.h"
#import "BLENameModel.h"
#import <UIImageView+WebCache.h>
#import <MJExtension.h>
@interface BLECommentHeaderView()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIButton *tagName;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *content;

@property (weak, nonatomic) IBOutlet UIButton *likeCount;
@property (weak, nonatomic) IBOutlet UIButton *commentCount;


@end

@implementation BLECommentHeaderView

- (void)setEntityModel:(BLEEntityModel *)entityModel {
    _entityModel = entityModel;
    
    self.title.text = entityModel.title;
    
    if (entityModel.tags.count != 0) {
        
        BLENameModel *model = [BLENameModel mj_objectWithKeyValues:[entityModel.tags firstObject]];
        
        [self.tagName setTitle:model.tagName forState:UIControlStateNormal];
        
    }
    
    NSURL *urlStr = [NSURL URLWithString:entityModel.photo];
    
    [self.icon sd_setImageWithURL:urlStr placeholderImage:[UIImage imageNamed:@"findAR_cell_title_image_bg"] ];
    
    [self.likeCount setTitle:[NSString stringWithFormat:@"%@",entityModel.likeCount] forState:UIControlStateNormal];
    
    self.content.numberOfLines = 0;
    
    self.content.text = entityModel.content;
    
    CGFloat maxCommet = CGRectGetMaxY(self.commentView.frame);
    
    CGFloat headerMax = maxCommet + [self sizeWithText:entityModel.content].height;
    
    NSLog(@"%lf",headerMax);
    
    self.height = headerMax;
    
    if (self.myBlock) {
        self.myBlock(headerMax);
    }
    
}

- (CGSize)sizeWithText:(NSString *)text {
    
    return [text boundingRectWithSize:CGSizeMake(200, 300) options:NSStringDrawingUsesLineFragmentOrigin attributes:nil context:nil].size;
}


- (IBAction)didClickWriteComment:(id)sender {
    
    
}


@end
