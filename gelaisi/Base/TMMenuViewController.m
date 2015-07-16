//
//  TMMenuViewController.m
//  Jingtemai
//
//  Created by Jasper on 15/4/14.
//  Copyright (c) 2015年 jasper. All rights reserved.
//

#import "TMMenuViewController.h"
#import "TMNavigationController.h"
#import "TMFrostedMenuCell.h"
#import "TMControllerManager.h"

typedef enum {
    TMMenuHome  = 0,
    TMMenuSeckill,
    TMMenuPhoneSpecial,
    TMMenuPersonCenter,
} TMMenu;

@interface TMMenuViewController ()

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSArray    *data;
@property (nonatomic, strong)NSIndexPath *currSelectedIndexPath;

@end

@implementation TMMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    [self.tableView registerClass:[TMFrostedMenuCell class] forCellReuseIdentifier:kReuseTMFrostedMenuCellIndentifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.scrollEnabled = NO;
    [self.view addSubview:self.tableView];
    [self.tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
//    self.tableView.separatorColor = [UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:1.0f];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 150.0f)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, 60, 60)];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        imageView.image = [UIImage imageNamed:@"logo_sidemenu"];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 120, 0, 24)];
        label.text = @"鲸特卖，你的京东省钱助手";
        label.font = [UIFont systemFontOfSize:13.0f];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = TMCOLOR(TM_Black);
        [label sizeToFit];
        label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        [view addSubview:imageView];
        [view addSubview:label];
        view;
    });
    
    self.data = @[
                  @{@"title":@"下单立减",@"image":@"manjian_off",@"highlightedImage":@"manjian_off"},
                  @{@"title":@"心跳秒杀",@"image":@"seckill_off",@"highlightedImage":@"seckill_off"},
                  @{@"title":@"手机专享",@"image":@"phone_off",@"highlightedImage":@"phone_off"},
                  @{@"title":@"个人中心",@"image":@"me_off",@"highlightedImage":@"me_off"},
                  ];
}

#pragma mark -
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if([[(UINavigationController*)self.frostedViewController.contentViewController viewControllers] count] == 1) {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
}
#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UINavigationController *nav = (UINavigationController*)self.frostedViewController.contentViewController;
    if (indexPath.row == self.currSelectedIndexPath.row &&
        [nav.viewControllers count] != 1) {
        return;
    } else {
        self.currSelectedIndexPath = indexPath;
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        NSLog(@"selected: %d", cell.selected);
        switch (indexPath.row) {
            case TMMenuHome:
            {
                [nav popToRootViewControllerAnimated:YES];
            }
                break;
                
            case TMMenuSeckill:
            {
//                [nav popToRootViewControllerAnimated:NO];
//                NSURL *URL = [NSURL URLWithString:@"http://wqs.jd.com/portal/wx/ju_miao.shtml"];
//                TMSeckillWebController *webViewController = [[TMSeckillWebController alloc] initWithURL:URL];
//                [nav pushViewController:webViewController animated:YES];
            }
                break;
                
            case TMMenuPhoneSpecial:
            {
//                [nav popToRootViewControllerAnimated:NO];
//                NSURL *URL = [NSURL URLWithString:@"http://sale.jd.com/m/act/N1maiIC8E6.html"];
//                SVWebViewController *webViewController = [[SVWebViewController alloc] initWithURL:URL];
//                [nav pushViewController:webViewController animated:YES];
            }
                break;
                
            case TMMenuPersonCenter:
            {
//                [nav popToRootViewControllerAnimated:NO];
//                NSURL *URL = [NSURL URLWithString:@"http://home.m.jd.com/user/userAllOrderList.action"];
//                SVWebViewController *webViewController = [[SVWebViewController alloc] initWithURL:URL];
//                [nav pushViewController:webViewController animated:YES];
            }
                break;
                
            default:
                break;
        }
    }
    [self.frostedViewController hideMenuViewController];
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TMFrostedMenuCell *menuCell = [tableView dequeueReusableCellWithIdentifier:kReuseTMFrostedMenuCellIndentifier forIndexPath:indexPath];
    NSDictionary *cellData = [self.data objectAtIndex:indexPath.row];
    [menuCell configCell:cellData];
    menuCell.selectionStyle = UITableViewCellSeparatorStyleNone;
    return menuCell;
}


- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}
@end
