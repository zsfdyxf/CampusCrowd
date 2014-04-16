//
//  AppSettings.h
//  StartOfProject
//
//  Created by zheng on 13-11-26.
//  Copyright (c) 2013年 YF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppSettings : NSObject

+ (UIColor *) appBackGroundColor;
+ (NSMutableArray *) appconfigInfo;
+ (NSMutableArray *) getArrayFormFile:(NSString *) filePath;
+ (NSMutableDictionary *) getDictionaryFromFile:(NSString *) filePath;

+ (BOOL) isFirstLogin;
+ (void) setFirst:(BOOL) isFirst;

//随机数
+ (int)getRandomNumber:(int)from to:(int)to;

//文件操作
+ (NSString *) generateFileInDir:(NSString *)dir fileName:(NSString *)fname;
+ (BOOL) copyFileFrom:(NSString *) sourceFile to:(NSString *) desFile;

//颜色配置
+ (UIColor *) colorWithHexString: (NSString *)color;
+ (UIColor *) mutiListViewBackGroundColor;
+ (UIColor *) mutiListViewTextColor;
+ (UIColor *) productionCellTextColor;
+ (UIColor *) productionCellPriceColor;

//检测是否连接到网络
+ (BOOL) connectedToNetwork;
+ (BOOL) isWWANG;
+ (BOOL) isWifi;
+ (NSString*)currentUID;

@end
