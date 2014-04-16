//
//  MainTableCell.h
//  WeSchool
//
//  Created by Hongyi Zheng on 4/16/14.
//  Copyright (c) 2014 Hongyi Zheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *mainIcon;
@property (weak, nonatomic) IBOutlet UILabel *mainTitle;
@property (weak, nonatomic) IBOutlet UILabel *subTitle;

@end
