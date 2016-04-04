//
//  BLERequestData.h
//  scanAR
//
//  Created by BlueEagleBoy on 16/3/19.
//  Copyright © 2016年 BlueEagleBoy. All rights reserved.
//  请求数据的单例类

#import <Foundation/Foundation.h>

typedef void(^success)(id responseTask);
typedef void(^fause)(NSError *error);


@interface BLERequestData : NSObject

+ (instancetype)sharedInstance;

//请求导航栏的title
- (NSArray *)requestDataWithUrlString:(NSString *)urlString;
- (NSArray *)requestDataWithUrlString:(NSString *)urlString parameter:(NSDictionary *)parameter;

/**
 *  请求title模型数据
 *
 *  @param success 成功的回调
 *  @param fause   失败的回调
 */
- (void)requestTitleModelWithSuccess:(success) success fause:(fause)fause;

/**
 *  请求数据的title
 *
 *  @param index
 *  @param categer 
 */
- (void)requestEntityModelWithCategory:(NSInteger)category withIndex:(NSInteger)page withSuccessBlock:(success)successBlock fauseBlock:(fause)fauseBlock;


/**
 *  获取评论的实体对象
 *
 *  @param ids          ar实体a的id
 *  @param successBlock 请求成功回调
 *  @param fauseBlock   请求失败回调
 */
- (void)requestCommentModelWithId:(NSNumber *)ids success:(success)successBlock fause:(fause)fauseBlock;

/**
 *  获取改对象的所有评论
 *
 *  @param ids          ar实体的id
 *  @param page         请求第几页的评论
 *  @param successBlock 请求成功的回调
 *  @param fauseBlock   请求失败的回调
 */
- (void)requestCommentModelWithId:(NSNumber *)ids page:(NSInteger)page success:(success)successBlock fause:(fause)fauseBlock;

@end
