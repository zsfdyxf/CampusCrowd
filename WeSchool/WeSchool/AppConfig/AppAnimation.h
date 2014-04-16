//
//  AppAnimation.h
//  StartOfProject
//
//  Created by Hongyi Zheng on 12/31/13.
//  Copyright (c) 2013 YF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/CALayer.h>
#import <QuartzCore/QuartzCore.h>

@interface AppAnimation : NSObject

// change the view's alpha
+ (void) changeViewAlpha:(int)alpha inView:(UIView *) tempView completion:(void (^)(BOOL finished))completion;

// hide navigation bar
+ (void) hideNavigationBar:(UINavigationController*) temp hiden:(BOOL) isHiden completion:(void (^)(BOOL finished))completion;
+ (CAAnimation *) disappearFromTopAnimation;

//move view to a new point (center point)
+ (void) changeViewCenter:(UIView *) temp center:(CGPoint) point completion:(void (^)(BOOL finished))completion;

@end
