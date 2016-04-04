//
//  BLEResultModel.h
//  scanAR
//
//  Created by BlueEagleBoy on 16/3/14.
//  Copyright © 2016年 BlueEagleBoy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum  {
    
    arList = 0
    
}BLEModelType;

@interface BLEUnityModel : NSObject

@property (nonatomic, strong)NSNumber *count;
@property (nonatomic, strong)NSNumber *currentPage;
@property (nonatomic, strong)NSArray *items;
@property (nonatomic, strong)NSNumber *size;
@property (nonatomic, assign)BLEModelType *type;
@property (nonatomic, strong)NSNumber *totalPage;


+ (NSDictionary *)objectClassInArray;


@end
