//
//  AppTools.h
//  HaveIdle
//
//  Created by Hongyi Zheng on 4/13/14.
//  Copyright (c) 2014 Hongyi Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *const kSourceDir = @"Documents/Resource";
static NSString *const kSourceImageDir = @"Documents/Resource/Image";
static NSString *const kSourceAudioDir = @"Documents/Resource/Audio";

@interface AppTools : NSObject

+ (void) drawBoundsForView:(UIView *) temp;

+ (BOOL) connectedToNetwork;
+ (BOOL) isWWANG;
+ (BOOL) isWifi;
+ (NSString*)currentUID;
+ (NSString *) findUniqueSavePhotoInDir:(NSString *) dir;
+ (NSString *) toJsonString:(id) data;
+ (NSString *) findAudioInDir:(NSString *) dir;
+ (BOOL) deleteFileInDir:(NSString *) dir;
+ (BOOL) deleteImages;
@end
