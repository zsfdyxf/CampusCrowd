//
//  DataRequest.m
//  HaveIdle
//
//  Created by Hongyi Zheng on 4/13/14.
//  Copyright (c) 2014 Hongyi Zheng. All rights reserved.
//

#import "DataRequest.h"
//#import "ShareSDKManager.h"
#define HOST @""

#define STATUS @"status"
#define DATA @"data"
#define INFO @"msg"

static NSString *const kHostUrl = @"http://youxianapp.com/test/index.php";

@implementation DataRequest

+ (id) sharedRequest
{
    static const DataRequest *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[super allocWithZone:NULL] init];
    });
    return manager;
}

- (id)init {
    if (self = [super init]) {
        
    }
    return self;
}
+ (id)allocWithZone:(NSZone *)zone {
    return [self sharedRequest];
}
- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (void)dealloc {
}

-(ASIHTTPRequest *)httpRequestWithParms:(NSDictionary *)parms requestType:(APP_REQUEST_TYPE)type useAsynchronous:(BOOL)yes withCompletBlock:(CompletionBlock)completionBlock feildBlock:(CompletionBlock)feildBlock
{
    return [self httpRequestWithParms:parms requestType:type AndFilesParms:nil useAsynchronous:yes showHUD:YES  withCompletBlock:completionBlock feildBlock:feildBlock];
}

-(ASIHTTPRequest*)httpRequestWithParms:(NSDictionary *)parms
                           requestType:(APP_REQUEST_TYPE)type
                         AndFilesParms:(NSDictionary *)filesParms
                       useAsynchronous:(BOOL)isAsyn
                               showHUD:(BOOL)show
                      withCompletBlock:(CompletionBlock)completionBlock
                            feildBlock:(CompletionBlock)feildBlock
{
    NSMutableDictionary *headers = [[NSMutableDictionary alloc] init];
    switch (type) {
        case APP_LOGIN:
            headers = nil;
            break;
        default:
            [headers setObject:self.accessToken forKey:@"Token"];
            //[headers setObject:[[ShareSDK getCredentialWithType:ShareTypeSinaWeibo] uid] forKey:@"User"];
            break;
    }
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"%@",[self consistUrl:type]]]];
    [request setRequestHeaders:headers];
    //[request setValue:[AppTools toJsonString:parms] forKey:@"value"];
    if (nil != parms) {
        [request addPostValue:[AppTools toJsonString:parms] forKey:@"value"];
    }
    self.request = request;
    
    [request setCompletionBlock:^{
        NSData *responseData = [self.request responseData];
        self.accessToken = [[self.request responseHeaders] objectForKey:@"Token"];
        DLog(@"--------------------------------");
        DLog(@"%@",[[NSString alloc] initWithBytes:[responseData bytes] length:[responseData length] encoding:NSUTF8StringEncoding]);
        DLog(@"--------------------------------");
        NSError *error = [self.request error];
        NSDictionary *dic;
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                feildBlock(dic);
            });
        }else
        {
            dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(dic);
            });
        }
        DLog(@"%@",dic);
    }];
    
    [request setFailedBlock:^{
        DLog(@"error");
    }];
    DLog(@"post请求为%@",request.url);
    DLog(@"postBody为%@",request.postData);
    
    
//    if (show)
//    {
//        if (isAsyn)
//        {
//            
//            //[SVProgressHUD show];
//        }
//        else
//        {
//            //[SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
//        }
//    }
    [request startAsynchronous];
   // [request performSelectorInBackground:@selector(startSynchronous) withObject:nil];
    
    return request;
    
}

-(void)cancelRequest
{
    if (self.request) {
        [self.request clearDelegatesAndCancel];
    }
}

- (NSString *) consistUrl:(APP_REQUEST_TYPE) type
{
    NSString *urlString = nil;
    switch (type) {
        case APP_LOGIN:
            urlString = [NSString stringWithFormat:@"%@/user/login",kHostUrl];
            break;
        case APP_GET_QINIU_TOKEN:
            urlString = [NSString stringWithFormat:@"%@/product/qiniu_token",kHostUrl];
            break;
        case APP_PUBLISH_PRODUCT:
            urlString = [NSString stringWithFormat:@"%@/product/publish",kHostUrl];
            break;
        case APP_BIND_PHONE:
            urlString = [NSString stringWithFormat:@"%@/user/bind_phone_request",kHostUrl];
            break;
        case APP_RBIND_PHONE:
            urlString = [NSString stringWithFormat:@"%@/user/resend_bind_phone_request",kHostUrl];
            break;
        case APP_ONLINE_PRODUCT:
            urlString = [NSString stringWithFormat:@"%@/product/online",kHostUrl];
            break;
        case APP_BIND_TESTCODE:
            urlString = [NSString stringWithFormat:@"%@/user/bind_phone",kHostUrl];
            break;
        default:
            break;
    }
    return urlString;
}

@end
