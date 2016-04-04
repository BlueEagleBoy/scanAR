//
//  BLEFileTools.m
//  scanAR
//
//  Created by BlueEagleBoy on 16/3/8.
//  Copyright © 2016年 BlueEagleBoy. All rights reserved.
//


#import "BLEFileTools.h"
#import <UIKit/UIKit.h>

static id _instance;
@implementation BLEFileTools

//单例
+(instancetype) sharedInstance {
    
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init] ;
    }) ;
    
    return _instance ;
}



//获取图片存储路径
- (NSString *)setupFilePath {
    
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    filePath = [filePath stringByAppendingPathComponent:@"images.data"];
    
    return filePath;
}

//从本地获取图片数组
- (NSArray *)readImagesFromFile {
    
    NSString *filePath = [self setupFilePath];
    
    NSArray *array = [NSArray arrayWithContentsOfFile:filePath];
    
    NSMutableArray *images = [NSMutableArray array];
    
    for (NSData *data in array) {
        
        UIImage *image = [UIImage imageWithData:data];
        
        [images addObject:image];
    }
    
    if (array) {
        
        DLog(@"读取数据成功");
    }else {
        DLog(@"读取数据失败");
    }
    
    return images;
}


#warning 此处有bug 怎么回不能转换呢
//保存图片数组到本地
- (void)writeToFileWithImages:(NSArray *)images {

    NSString *filePath = [self setupFilePath];
    
    if ([images writeToFile:filePath atomically:YES]) {
        
        DLog(@"保存沙盒成功");
    }else {
        
        DLog(@"保存沙盒失败");
    }
    
}

//删除本地文件
- (void)deletedFile {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager removeItemAtPath:[self setupFilePath] error:nil]) {
        
        [fileManager removeItemAtPath:[self setupFilePath] error:nil];
        
        DLog(@"删除data成功");
    }else {
        DLog(@"删除失败");
    }
    
}





@end
