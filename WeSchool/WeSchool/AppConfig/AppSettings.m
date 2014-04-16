//
//  AppSettings.m
//  StartOfProject
//
//  Created by zheng on 13-11-26.
//  Copyright (c) 2013年 YF. All rights reserved.
//

#import "AppSettings.h"
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <CFNetwork/CFNetwork.h>
#include <netdb.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "Reachability.h"

#define kAppFirstLogin              @"k_app_first_login"

#define kAppLoadMainItem            @"k_app_load_main_item"
#define kAppLoadCompanyInfo         @"k_app_load_main_company_info"
#define kAppLoadLocalServe          @"k_app_load_local_serve"
#define kAppCurrentCityName         @"k_app_current_city_name"
#define kAppCurrentCityId           @"k_app_current_city_id"
#define kAppRegionInfo              @"k_app_region_info"
#define kLocationLa                 @"k_app_location_la"
#define kLocationLo                 @"k_app_location_lo"
#define kUserAddress                @"k_app_user_current_address"
#define kWifiDownLoad               @"k_app_can_down_load_wifi"

@interface AppSettings ()
+(void)setValue:(NSObject*)value forKey:(NSObject*)key;
+(NSObject*)getValueForKey:(NSObject*)key;
@end
@implementation AppSettings
+(void)setValue:(NSObject*)value forKey:(NSString*)key{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    @synchronized(prefs) {
        [prefs setObject:value forKey:key];
        [prefs synchronize];
    }
}

+(NSObject *)getValueForKey:(NSString*)key{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    return [prefs valueForKey:key];
}

#pragma mark - detail function
+ (BOOL) isFirstLogin
{
    NSNumber *num = (NSNumber *)[AppSettings getValueForKey:kAppFirstLogin];
    [AppSettings setFirst:YES];
    return ![num boolValue];
}
+ (void) setFirst:(BOOL)isFirst
{
    NSNumber *num = [NSNumber numberWithBool:isFirst];
    [AppSettings setValue:num forKey:kAppFirstLogin];
}
+ (UIColor *) appBackGroundColor
{
    return [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
}
+ (NSString *) generateFileInDir:(NSString *)dir fileName:(NSString *)fname
{
    NSString *fileDirectory = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",dir]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:fileDirectory]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:fileDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *path;
    path = [NSString stringWithFormat:@"%@/%@",fileDirectory,fname];
    return path;
}

+ (BOOL) copyFileFrom:(NSString *)sourceFile to:(NSString *)desFile
{
    return [[NSFileManager defaultManager] copyItemAtPath:sourceFile toPath:desFile error:nil];
}
+ (NSMutableArray *) appconfigInfo
{
    NSString *appInfo = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"mainitem.plist"];
    return [NSMutableArray arrayWithContentsOfFile:appInfo];
}

+ (NSMutableDictionary *) getDictionaryFromFile:(NSString *)filePath
{
    return [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
}
+ (NSMutableArray *) getArrayFormFile:(NSString *) filePath
{
    return [NSMutableArray arrayWithContentsOfFile:filePath];
}

#pragma mark - colors
+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

+ (UIColor *) mutiListViewBackGroundColor
{
    return [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1];
}
+ (UIColor *) mutiListViewTextColor
{
    return [UIColor colorWithRed:232/255.0 green:140/255.0 blue:38/255.0 alpha:1];
}
+ (UIColor *) productionCellTextColor
{
    return [UIColor colorWithRed:159/255.0 green:160/255.0 blue:160/255.0 alpha:1];
}
+ (UIColor *) productionCellPriceColor
{
    return [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1];
}
+ (int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to-from + 1)));
}
#pragma mark - 具体程序具体需要

+ (NSString*)currentUID
{
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    NSString* noUID = @"";
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        return noUID;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        return noUID;
    }
    
    if ((buf = (char*)malloc(len)) == NULL) {
        return noUID;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        free(buf);
        return noUID;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}

//检测当前网络是否可用
+ (BOOL) connectedToNetwork
{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        printf("Error. Could not recover network reachability flags\n");
        return NO;
    }
    
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
    return (isReachable && !needsConnection) ? YES : NO;
}
+ (BOOL) isWWANG
{
    BOOL isExistenceNetWork = NO;
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([reachability currentReachabilityStatus]) {
        case NotReachable://无网络
            isExistenceNetWork = NO;
            break;
        case ReachableViaWWAN://使用3G或RPRS
            isExistenceNetWork = YES;
            break;
        case ReachableViaWiFi://使用WiFi
            isExistenceNetWork = NO;
            break;
    }
    return isExistenceNetWork;
}

+ (BOOL) isWifi
{
    BOOL isExistenceNetWork = NO;
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([reachability currentReachabilityStatus]) {
        case NotReachable://无网络
            isExistenceNetWork = NO;
            break;
        case ReachableViaWWAN://使用3G或RPRS
            isExistenceNetWork = NO;
            break;
        case ReachableViaWiFi://使用WiFi
            isExistenceNetWork = YES;
            break;
    }
    return isExistenceNetWork;
}



@end
