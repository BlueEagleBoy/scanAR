//
//  BLEEntityModel.h
//  scanAR
//
//  Created by BlueEagleBoy on 16/3/14.
//  Copyright © 2016年 BlueEagleBoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLEEntityModel : NSObject

@property (nonatomic, strong)NSNumber *ids;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *photo;
@property (nonatomic, strong)NSString *content;
@property (nonatomic, strong)NSNumber *likeCount;
@property (nonatomic, strong)NSArray *tags;
@property (nonatomic, copy)NSString *attr;
@property (nonatomic, copy)NSString *shareUrl;

+ (NSDictionary *)objectClassInArrays;




@end
