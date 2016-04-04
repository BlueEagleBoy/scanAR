//
//  BLEFileTools.h
//  scanAR
//
//  Created by BlueEagleBoy on 16/3/8.
//  Copyright © 2016年 BlueEagleBoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLEFileTools : NSObject

// 单例
+ (instancetype)sharedInstance;

//获取本地文件路径
- (NSString *)setupFilePath;

//读取本地图片数组
-(NSArray *)readImagesFromFile;

//讲图片数组写入到本地
- (void)writeToFileWithImages:(NSArray *)images;

//删除指定文件
- (void)deletedFile;

@end
