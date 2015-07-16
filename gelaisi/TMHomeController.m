//
//  TMHomeController.m
//  gelaisi
//
//  Created by lxlong on 15/7/14.
//  Copyright (c) 2015年 lxlong. All rights reserved.
//

#import "TMHomeController.h"
#import "REFrostedViewController.h"
#import "TMHomeHeaderView.h"
#import "TMSearchController.h"

@interface TMHomeController () <TMHomeHeaderViewDelegate>

@property (nonatomic, strong) TMHomeHeaderView *headerView;

@end

@implementation TMHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configView];
    [self configHeader];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configView {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(menuBarItemDown:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_search"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(searchItemDown:)];
    
    self.view.backgroundColor = [UIColor whiteColor];

}

- (void)configHeader {
    TMHomeHeaderView *headerView = [[TMHomeHeaderView alloc] initWithFrame:CGRectZero];
    headerView.frame = (CGRect){
        CGPointZero,
        [headerView getViewSize]
    };
    self.headerView = headerView;
    self.headerView.delegate = self;
    [self.view addSubview:self.headerView];
}

#pragma -mrak navigationBar

- (void)menuBarItemDown:(id)sender {
    [self.frostedViewController presentMenuViewController];
}

- (void)searchItemDown:(id)sender {
    [self.navigationController pushViewController:[[TMSearchController alloc] init] animated:YES];
}

@end
