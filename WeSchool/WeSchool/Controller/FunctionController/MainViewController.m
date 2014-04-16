//
//  MainViewController.m
//  WeSchool
//
//  Created by Hongyi Zheng on 4/15/14.
//  Copyright (c) 2014 Hongyi Zheng. All rights reserved.
//

#import "MainViewController.h"
#import "MainTopView.h"
#import "MainTableCell.h"

static const CGFloat kTopViewH = 183;

@interface MainViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) MainTopView *topView;
@property (nonatomic, strong) UITableView *mainTable;
@end

@implementation MainViewController

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
    CGRect mainFrame = [[UIScreen mainScreen] bounds];
    UIView *global = [[UIView alloc] initWithFrame:mainFrame];
    self.view = global;
    
    _topView = [[MainTopView alloc] initWithFrame:CGRectMake(0, 0, mainFrame.size.width, kTopViewH)];
    [_topView.backImageView setBackgroundColor:[UIColor redColor]];
    
    _topView.mainTitleLabel.text = @"必胜客";
    _topView.subLabel.text = @"中国传媒大学";
    
    [self.view addSubview:_topView];
    
    _mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopViewH, mainFrame.size.width, mainFrame.size.height-kTopViewH-49-20-44)];
    _mainTable.delegate = self;
    _mainTable.dataSource = self;
    [self.view addSubview:_mainTable];
    
}

- (id) init
{
    self = [super init];
    if (self) {
        self.title = @"首页";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 3;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 63;
}

- (NSArray *) mainTiles
{
    return @[@"附近优惠",@"订外卖",@"找兼职/实习"];
}

- (NSArray *) subTitles
{
    return @[@"附近美食尽在掌握",@"饿了就开吃",@"好职位等你来挑"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    int rowNum = [indexPath row];
    MainTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
 
 // Configure the cell...
 
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MainTableCell" owner:self options:nil] lastObject];
    }

    cell.mainTitle.text = [self mainTiles][rowNum];
    cell.subTitle.text = [self subTitles][rowNum];
    return cell;
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
