//
//  BLEUserModel.h
//  scanAR
//
//  Created by BlueEagleBoy on 16/3/17.
//  Copyright © 2016年 BlueEagleBoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLEUserModel : NSObject

@property (nonatomic, copy)NSString *commentId;
@property (nonatomic, copy)NSString *username;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, copy)NSString *commentTime;
@property (nonatomic, copy)NSString *avatar;

@end
