//
//  AppTools.m
//  HaveIdle
//
//  Created by Hongyi Zheng on 4/13/14.
//  Copyright (c) 2014 Hongyi Zheng. All rights reserved.
//

#import "AppTools.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "Reachability.h"
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <CFNetwork/CFNetwork.h>
#include <netdb.h>

@implementation AppTools

+ (void)drawBoundsForView:(UIView *)temp
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 243.0/255.0, 243.0/255.0, 243.0/255.0, 1 });
    [temp.layer setMasksToBounds:YES];
    [temp.layer setCornerRadius:0];
    [temp.layer setBorderWidth:1];
    [temp.layer setBorderColor:colorref];
    CGColorRelease(colorref);
    CGColorSpaceRelease(colorSpace);
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

+ (NSString *) findUniqueSavePhotoInDir:(NSString *)dir
{
    int i = 1;
    NSString *path;
    NSString *fileDirectory = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",dir]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:fileDirectory]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:fileDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    do {
        path = [NSString stringWithFormat:@"%@/IMAGE_%04d.PNG",fileDirectory,i++];
    } while ([[NSFileManager defaultManager] fileExistsAtPath:path]);
    return path;
}
+ (NSString *) findAudioInDir:(NSString *)dir
{
    NSString *fileDirectory = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",dir]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:fileDirectory]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:fileDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return [NSString stringWithFormat:@"%@/88.amr",fileDirectory];
}

+ (BOOL) deleteFileInDir:(NSString *) dir
{
    NSFileManager *manage = [NSFileManager defaultManager];
    if ([[NSFileManager defaultManager] fileExistsAtPath:dir]) {
        return [manage removeItemAtPath:dir error:nil];
    }
    return YES;
}

+ (BOOL) deleteImages
{
    NSString *fileDirectory = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",kSourceImageDir]];
    NSArray *allFile = [[NSFileManager defaultManager]contentsOfDirectoryAtPath:fileDirectory error:nil];
    int count = [allFile count];
    if (count > 0) {
        int i=0;
        for (NSString *temp in allFile) {
            NSString *file = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@",kSourceImageDir,temp]];
            if ([[NSFileManager defaultManager] removeItemAtPath:file error:nil]) {
                i++;
                DLog(@"%d",i);
            }
        }
        if (i == count) {
            DLog(@"--");
            return YES;
        }else{
            DLog(@"dddddd")
            return NO;
        }
    }else{
        DLog(@"0000000")
        return YES;
    }
}
+ (NSString *) toJsonString:(id)data
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if ([jsonData length] > 0 && error == nil){
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }else{
        return nil;
    }
}
@end
