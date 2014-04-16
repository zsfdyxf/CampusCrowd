//
//  MyTopView.h
//  WeSchool
//
//  Created by Hongyi Zheng on 4/16/14.
//  Copyright (c) 2014 Hongyi Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTopView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *userProfile;

@property (weak, nonatomic) IBOutlet UILabel *nickName;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *userMark;
@end
