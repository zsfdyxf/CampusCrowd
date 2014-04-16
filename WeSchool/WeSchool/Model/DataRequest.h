//
//  DataRequest.h
//  HaveIdle
//
//  Created by Hongyi Zheng on 4/13/14.
//  Copyright (c) 2014 Hongyi Zheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

static NSString *const kImageBaseUrl = @"http://youxian.qiniudn.com";
typedef   void(^CompletionBlock)(NSDictionary * dataDic);

typedef enum : NSUInteger {
    APP_LOGIN,
    APP_GET_QINIU_TOKEN,
    APP_PUBLISH_PRODUCT,
    APP_BIND_PHONE,
    APP_RBIND_PHONE,
    APP_ONLINE_PRODUCT,
    APP_BIND_TESTCODE,
    
} APP_REQUEST_TYPE;

@interface DataRequest : NSObject

@property(strong,nonatomic)ASIFormDataRequest *request;
@property (nonatomic, strong) NSString *accessToken;
@property (nonatomic, strong) NSString *accessUser;

+ (id) sharedRequest;


-(ASIHTTPRequest*)httpRequestWithParms:(NSDictionary *)parms
                           requestType:(APP_REQUEST_TYPE) type
                       useAsynchronous:(BOOL)yes
                      withCompletBlock:(CompletionBlock)completionBlock
                            feildBlock:(CompletionBlock)feildBlock;

-(ASIHTTPRequest*)httpRequestWithParms:(NSDictionary *)parms
                           requestType:(APP_REQUEST_TYPE) type
                         AndFilesParms:(NSDictionary *)filesParms
                       useAsynchronous:(BOOL)isAsyn
                               showHUD:(BOOL)show
                      withCompletBlock:(CompletionBlock)completionBlock
                            feildBlock:(CompletionBlock)feildBlock;

@end
