//
//  TwoCodeViewController.m
//  WeSchool
//
//  Created by Hongyi Zheng on 4/15/14.
//  Copyright (c) 2014 Hongyi Zheng. All rights reserved.
//

#import "TwoCodeViewController.h"
#import "QRCodeGenerator.h"
#import "TwoCodeView.h"

@interface TwoCodeViewController ()

@property (nonatomic, strong) TwoCodeView *qrView;

@end

@implementation TwoCodeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) loadView
{
    [super loadView];
    CGRect mainFrame = [[UIScreen mainScreen] bounds];
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, mainFrame.size.width, mainFrame.size.height-64-49)];
    [scroll setContentSize:CGSizeMake(mainFrame.size.width, 568-64-49)];
    [scroll setBackgroundColor:[UIColor redColor]];
    scroll.scrollEnabled = NO;
    
    
    
    TwoCodeView *twoCode = [[[NSBundle mainBundle] loadNibNamed:@"TwoCodeView" owner:self options:nil] lastObject];
    twoCode.center = CGPointMake(mainFrame.size.width/2, twoCode.frame.size.height/2);
    _qrView = twoCode;
    [scroll addSubview:twoCode];
    
    [self.view addSubview:scroll];
}
- (id) init
{
    self = [super init];
    if (self) {
        self.title = @"二维码";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.qrView.twoCodeImage.image = [QRCodeGenerator qrImageForString:@"test" imageSize:_qrView.frame.size.width];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
