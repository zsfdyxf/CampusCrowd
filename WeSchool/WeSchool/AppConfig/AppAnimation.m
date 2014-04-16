//
//  AppAnimation.m
//  StartOfProject
//
//  Created by Hongyi Zheng on 12/31/13.
//  Copyright (c) 2013 YF. All rights reserved.
//

#import "AppAnimation.h"

@implementation AppAnimation
+ (CAAnimation *) disappearFromTopAnimation
{
    CATransition *transtion = [CATransition animation];
    transtion.duration = 0.3;
    [transtion setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [transtion setType:kCATransitionFade];
    [transtion setSubtype:kCATransitionFromTop];
    return transtion;
}

+ (void) changeViewAlpha:(int)alpha inView:(UIView *)tempView completion:(void (^)(BOOL))completion
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        tempView.alpha = alpha;
    } completion:^(BOOL finished) {
        completion(finished);
    }];
}
+ (void) hideNavigationBar:(UINavigationController*) temp hiden:(BOOL) isHiden completion:(void (^)(BOOL finished))completion
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        temp.navigationBarHidden = isHiden;
    } completion:^(BOOL finished) {
        completion(finished);
    }];
}

+ (void) changeViewCenter:(UIView *) temp center:(CGPoint) point completion:(void (^)(BOOL finished))completion
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        temp.center = point;
    } completion:^(BOOL finished) {
        completion(finished);
    }];
}

@end
