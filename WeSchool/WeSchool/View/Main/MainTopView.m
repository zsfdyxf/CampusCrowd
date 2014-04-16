//
//  MainTopView.m
//  WeSchool
//
//  Created by Hongyi Zheng on 4/16/14.
//  Copyright (c) 2014 Hongyi Zheng. All rights reserved.
//

#import "MainTopView.h"


static const CGFloat kBottomHeight = 56;
static const CGFloat kBottomMaigin = 10;
static const CGFloat kMainLabelH = 20;
static const CGFloat kSubLabelH = 20;
@implementation MainTopView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self makeInterface];
    }
    return self;
}

- (void) makeInterface
{
    CGRect mainFrame  = [self bounds];
    _backImageView = [[UIImageView alloc] initWithFrame:mainFrame];
    [self addSubview:_backImageView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, mainFrame.size.height-kBottomHeight, mainFrame.size.width, kBottomHeight)];
    _mainTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kBottomMaigin, 0, mainFrame.size.width-kBottomMaigin, kMainLabelH)];
    [_mainTitleLabel setBackgroundColor:[UIColor clearColor]];
    [bottomView addSubview:_mainTitleLabel];
    
    _subLabel = [[UILabel alloc] initWithFrame:CGRectMake(kBottomMaigin, _mainTitleLabel.frame.origin.y+kMainLabelH+5, mainFrame.size.width, kSubLabelH)];
    [_subLabel setBackgroundColor:[UIColor clearColor]];
    [bottomView addSubview:_subLabel];
    
    [self addSubview:bottomView];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
