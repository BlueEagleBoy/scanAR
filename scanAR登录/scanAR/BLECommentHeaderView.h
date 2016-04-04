//
//  BLECommentHeaderView.h
//  scanAR
//
//  Created by BlueEagleBoy on 16/3/25.
//  Copyright © 2016年 BlueEagleBoy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLEEntityModel.h"

typedef void(^block)(NSInteger height);
@interface BLECommentHeaderView : UIView
@property (nonatomic,strong)BLEEntityModel *entityModel;
@property (nonatomic, copy)block myBlock;
@property (weak, nonatomic) IBOutlet UIView *commentView;
@property (nonatomic, assign)CGFloat height;

@end
