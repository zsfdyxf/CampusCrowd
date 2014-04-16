//
//  DLog.h
//  SampleProject
//
//  Created by zheng on 13-8-5.
//  Copyright (c) 2013年 YF. All rights reserved.
//
//#import "MBProgressHUD.h"
//#import "TestPhotoViewController.h"

#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)
#endif

#ifndef ____DeviceModelGeneration_h
#define ____DeviceModelGeneration_h


#define IS_WIDESCREEN ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define IS_IPHONE ( [ [ [ UIDevice currentDevice ] model ] isEqualToString: @"iPhone" ] )
#define IS_IPOD   ( [ [ [ UIDevice currentDevice ] model ] isEqualToString: @"iPod touch" ] )


#define IS_IPHONE_5 ( IS_IPHONE && IS_WIDESCREEN )

#define IS_IOS7 ( [ [ [ UIDevice currentDevice ] systemVersion ] floatValue ] >= 7.0  )
#define iOS7_FOR_5 CGRectMake(0, 20, 320, 568)
#define iOS7_BEFORE_5 CGRectMake(0, 0, 320, 480)
#define BEFORE_iOS7_5 CGRectMake(0, 20, 320, 568)
#define BEFORE_iOS7_BEFORE_5 CGRectMake(0, 0, 320, 480)

enum {
    PLAYER_STOP = 1,
    PLAYER_START,
    PLAYER_CONTINUE,
    PLAYER_PAUSE
};
typedef NSUInteger PLAYER_CONTROL;

#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define StateBarHeight 20
#define MainHeight (ScreenHeight - StateBarHeight)
#define MainWidth ScreenWidth

#define IS_BEFORE_IOS5 [[[UIDevice currentDevice] systemVersion] doubleValue] < 5
#define IS_LAND_SCAPE ([[ UIScreen mainScreen ] bounds ].size.height <  400)

#endif
#define show(msg,view) MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];\
hud.mode = MBProgressHUDModeText;\
hud.labelText = msg;\
hud.removeFromSuperViewOnHide = YES;\
[hud hide:YES afterDelay:2];



#define progress(msg,view) MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];\
hud.labelText = msg;\
hud.mode = MBProgressHUDModeIndeterminate;\
view.userInteractionEnabled=NO;

#define progressDone(view) [MBProgressHUD hideHUDForView:view animated:YES];\
view.userInteractionEnabled=YES;

#define FSystemVersion          ([[[UIDevice currentDevice] systemVersion] floatValue])
