//
//  BLEUserResultModel.h
//  scanAR
//
//  Created by BlueEagleBoy on 16/3/17.
//  Copyright © 2016年 BlueEagleBoy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLEUserModel.h"

@interface BLEUserResultModel : NSObject

@property (nonatomic, strong)NSNumber *count;
@property (nonatomic, strong)NSNumber *currentPage;
@property (nonatomic, strong)NSArray *items;
@property (nonatomic, strong)NSNumber *size;
@property (nonatomic, assign)BLEUserModel *type;
@property (nonatomic, strong)NSNumber *totalPage;

+ (NSDictionary *)objectClassInArray;

@end
