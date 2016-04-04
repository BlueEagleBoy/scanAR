//
//  BLEEntityModel.m
//  scanAR
//
//  Created by BlueEagleBoy on 16/3/14.
//  Copyright © 2016年 BlueEagleBoy. All rights reserved.
//

#import "BLEEntityModel.h"

@implementation BLEEntityModel

+ (NSDictionary *)objectClassInArrays {
    return @{
             
             @"tags":@"BLENameModel"
            };
}

+ (NSDictionary *)replacedKeyFromPropertyName {
    
    return @{
             
             @"ids":@"id"
             };
}

@end
