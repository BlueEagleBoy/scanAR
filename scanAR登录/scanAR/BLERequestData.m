//
//  BLERequestData.m
//  scanAR
//
//  Created by BlueEagleBoy on 16/3/19.
//  Copyright © 2016年 BlueEagleBoy. All rights reserved.
//

#import "BLERequestData.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>
#import "BLEUnityModel.h"
#import "BLETitleModel.h"
#import "BLEEntityModel.h"
#import "BLEUserResultModel.h"

@interface BLERequestData ()

@property (nonatomic, strong)NSMutableArray *entityModels;

@end


@implementation BLERequestData

//单例
+ (instancetype)sharedInstance {
    
    static id _instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _instance = [[self alloc]init];
    });
    
    return _instance;
}

- (NSMutableArray *)entityModels {
    
    if (!_entityModels) {
        _entityModels = [NSMutableArray array];
    }
    return _entityModels;
}

//加载find导航栏的titleData
- (NSArray *)requestDataWithUrlString:(NSString *)urlString {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    __block NSMutableArray *array = [NSMutableArray array];
    
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *responseArr = responseObject[@"result"];
        
        for (NSDictionary *dict in responseArr) {
            
            BLETitleModel *titleModle = [BLETitleModel mj_objectWithKeyValues:dict];
            
            [array addObject:titleModle];
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        DLog(@"error:%@",error);
        
    }];
    
    return array;
    
}

- (void)requestDataWithIndex:(NSInteger)index {
    
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    static  NSInteger currentPage = 1;
    NSString *urlString = [NSString stringWithFormat:@"http://user.sightp.com/mobile/get-ar?page=%ld&lang=zh_cn",(long)currentPage];
    
    
    [[sessionManager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *entityModels = [BLEUnityModel mj_objectWithKeyValues:responseObject[@"result"]].items;
        
        if (entityModels.count != 0) {
            
            [self.entityModels addObjectsFromArray:entityModels];
            
            DLog(@"entityModelCount:%ld",self.entityModels.count);
            
            DLog(@"currentThread:%@",[NSThread currentThread]);
            
            currentPage++;
        }else {
            
            NSLog(@"未加载到数据");
            
        }
        
        NSLog(@"currentPage:%ld",(long)currentPage);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        DLog(@"error:%@",error);
        
    }]resume];
}



#pragma mark 获取标题数据
- (void)requestTitleModelWithSuccess:(success)success fause:(fause)fause {
    
    NSDictionary *parameter = @{@"lang":@"zh_cn"};
    
    [self requestDataWithUrlString:BLECategoryARUrlString WithParameter:parameter success:success fause:fause];
    
}

//请求标题数据 转成模型并返回模型数组
- (void)requestDataWithUrlString:(NSString *)urlStr WithParameter:(NSDictionary *)parameter success:(success)successBlock fause:(fause)fauseBlock {
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:urlStr parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //获取result下的字典
        NSArray *reponseArr = responseObject[@"result"];
        
        NSMutableArray *models = [NSMutableArray array];
        
        //字典转模型
        for ( NSDictionary *dict in reponseArr) {
            
            [models addObject:[BLETitleModel mj_objectWithKeyValues:dict]];
        }
        
        //返回模型数组
        if (successBlock) {
            
            successBlock(models);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (error && fauseBlock) {
            
            fauseBlock(error);
        }
    }];
}

#pragma  mark 获取每一个ar的数据
- (void)requestEntityModelWithCategory:(NSInteger)category withIndex:(NSInteger)page withSuccessBlock:(success)successBlock fauseBlock:(fause)fauseBlock {
    
    NSString *urlString = nil;
    if (category == 0) {

        urlString = [NSString stringWithFormat:@"http://user.sightp.com/mobile/get-ar?page=%ld&lang=zh_cn",(long)page];
    }else {

        urlString = [NSString stringWithFormat:@"http://user.sightp.com/mobile/get-ar?category=%ld&page=%ld&lang=zh_cn",(long)category,(long)page];
    }
    
    [self requestEntityDataWithUrlString:urlString WithParameter:nil success:successBlock fause:fauseBlock];
}


//根据类别和页数请求数据 并转换为模型 返回模型数组
- (void)requestEntityDataWithUrlString:(NSString *)urlStr WithParameter:(NSDictionary *)parameter success:(success)successBlock fause:(fause)fauseBlock {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:urlStr parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dict = responseObject[@"result"];
        
        BLEUnityModel *userModel = [BLEUnityModel mj_objectWithKeyValues:dict];
    
        //返回模型数组
        if (successBlock) {
            successBlock(userModel.items);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (error && fauseBlock) {
            fauseBlock(error);
        }
        
    }];
    
}


//请求评论数据
- (void)requestCommentModelWithId:(NSNumber *)ids success:(success)successBlock fause:(fause)fauseBlock {
    
    NSString *str =[NSString stringWithFormat:@"http://user.sightp.com/mobile/get-ar-info?id=%@&lang=zh_cn",ids];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager GET:str parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) {
            
            BLEEntityModel *model = [BLEEntityModel mj_objectWithKeyValues:responseObject[@"result"]];
            successBlock(model);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (fauseBlock) {
            fauseBlock(error);
        }
    }];
}


//请求评论人的信息
- (void)requestCommentModelWithId:(NSNumber *)ids page:(NSInteger)page success:(success)successBlock fause:(fause)fauseBlock {
    
    NSString *str = [NSString stringWithFormat:@"http://user.sightp.com/mobile/get-ar-comment?id=%@&page=%zd",ids,page];
    
    NSLog(@"%@",str);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //请求数据
    [manager GET:str parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        BLEUserResultModel *resultModel = [BLEUserResultModel mj_objectWithKeyValues:responseObject[@"result"]];

        if (successBlock) {
            successBlock(resultModel.items);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (fauseBlock) {
            fauseBlock(error);
        }
    }];
    
}




@end
