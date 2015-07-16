//
//  UNAlertView.m
//  UnionSys
//
//  Created by linxiaolong on 15/2/28.
//  Copyright (c) 2015年 linxiaolong. All rights reserved.
//

#import "UNAlertView.h"
#import "IMGActivityIndicator.h"

@implementation BlockButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 15;
        self.layer.borderWidth = 1;
        self.layer.shadowRadius = 2;
        self.layer.shadowColor = [UIColor grayColor].CGColor;
        self.layer.borderColor = [UIColor orangeColor].CGColor;
    }
    return self;
}

- (void)addSubTarget {
    [self addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnClicked: (UIButton *)sender {
    self.tBlock(sender.tag);
}

@end

@implementation UNAlertView

- (void)mainTitle:(NSString *)mtitle
         subTitle:(NSString *)stitle
         btnTitle:(NSString *)btitle
       touchClose:(BOOL)cando
            block:(TouchBlock)block
{
    CGRect mainRect = [UIScreen mainScreen].bounds;
    CGFloat wlength = 240;
    CGFloat hlength = 160;
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(mainRect.size.width/2-wlength/2, mainRect.size.height/2-hlength/2, wlength, hlength)];
    contentView.backgroundColor = [UIColor whiteColor];
    
    // set subView
    UILabel *mainLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, wlength-20, 20)];
    mainLable.textColor = [UIColor orangeColor];
    mainLable.text = mtitle;
    [contentView addSubview:mainLable];
    
    UILabel *lineLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, wlength-20, 0.8)];
    lineLable.backgroundColor = [UIColor colorWithRed:249.0/255 green:157.0/255 blue:59.0/255 alpha:0.5];
    [contentView addSubview:lineLable];
    
    UILabel *subLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, wlength-20, 80)];
    subLable.textColor = [UIColor blackColor];
    subLable.numberOfLines = 3;
    subLable.textAlignment = NSTextAlignmentCenter;
    subLable.text = stitle;
    [contentView addSubview:subLable];
    
    BlockButton *doneBtn = [[BlockButton alloc] initWithFrame:CGRectMake(wlength/2-40, hlength-40, 80, 30)];
    [doneBtn setTitle:btitle forState:UIControlStateNormal];
    [doneBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    doneBtn.tBlock = block;
    [doneBtn addSubTarget];
    [contentView addSubview:doneBtn];
    contentView.layer.cornerRadius = 4;
    contentView.alpha = 0.9;
    
    [UNAlertView content:contentView backAlpha:0.5 touchClose:cando];
}

- (void)waitTitle:(NSString *)wtitle {
    CGRect mainRect = [UIScreen mainScreen].bounds;
    CGFloat wlength = 150;
    CGFloat hlength = 150;
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(mainRect.size.width/2-wlength/2, mainRect.size.height/2-hlength/2, wlength, hlength)];
    contentView.backgroundColor = [UIColor colorWithRed:113.0/255 green:113.0/255 blue:113.0/255 alpha:0.8];
    
    // set subView
    IMGActivityIndicator *indicator = [[IMGActivityIndicator alloc] initWithFrame:CGRectMake(wlength/2-50, hlength/2-70, 100, 100)];
    [contentView addSubview:indicator];
    
    UILabel *titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, hlength-40, wlength, 30)];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.font = [UIFont systemFontOfSize:14.0f];
    titleLab.text = wtitle;
    titleLab.textColor = [UIColor whiteColor];
    [contentView addSubview:titleLab];
    contentView.layer.cornerRadius = 4;
    contentView.alpha = 0.9;
    [UNAlertView content:contentView backAlpha:0.5 touchClose:NO];
}

#pragma -mark "stange demand"

- (void)mainTitle:(NSString *)mtitle
         subTitle:(NSString *)stitle
      cancelTitle:(NSString *)ctitle
   determineTitle:(NSString *)dtitle
            block:(TouchBlock)block
{
    CGRect mainRect = [UIScreen mainScreen].bounds;
    CGFloat wlength = 240;
    CGFloat hlength = 160;
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(mainRect.size.width/2-wlength/2, mainRect.size.height/2-hlength/2, wlength, hlength)];
    contentView.backgroundColor = [UIColor whiteColor];
    
    if (!([mtitle isEqualToString:@""] || [stitle isEqualToString:@""] || [ctitle isEqualToString:@""] || [dtitle isEqualToString:@""])) {
        // set subView
        UILabel *mainLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, wlength-20, 20)];
        mainLable.textColor = [UIColor orangeColor];
        mainLable.text = mtitle;
        [contentView addSubview:mainLable];
        
        UILabel *lineLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, wlength-20, 0.8)];
        lineLable.backgroundColor = [UIColor colorWithRed:249.0/255 green:157.0/255 blue:59.0/255 alpha:0.5];
        [contentView addSubview:lineLable];
        
        UILabel *subLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, wlength-20, 80)];
        subLable.textColor = [UIColor blackColor];
        subLable.numberOfLines = 3;
        subLable.textAlignment = NSTextAlignmentCenter;
        subLable.text = stitle;
        [contentView addSubview:subLable];
        
        BlockButton *cancelBtn = [[BlockButton alloc] initWithFrame:CGRectMake(wlength/2-90, hlength-40, 80, 30)];
        cancelBtn.tag = 0;
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [cancelBtn setTitle:ctitle forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [cancelBtn.layer setBorderWidth:1.0f];
        [cancelBtn.layer setBorderColor:[UIColor orangeColor].CGColor];
        cancelBtn.tBlock = block;
        [cancelBtn addSubTarget];
        [contentView addSubview:cancelBtn];
        
        BlockButton *comfirmBtn = [[BlockButton alloc] initWithFrame:CGRectMake(wlength/2+10, hlength-40, 80, 30)];
        comfirmBtn.tag = 1;
        comfirmBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [comfirmBtn setTitle:dtitle forState:UIControlStateNormal];
        [comfirmBtn setBackgroundColor:[UIColor orangeColor]];
        [comfirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        comfirmBtn.tBlock = block;
        [comfirmBtn addSubTarget];
        [contentView addSubview:comfirmBtn];
        contentView.layer.cornerRadius = 4;
        contentView.alpha = 0.9;
        
        [UNAlertView content:contentView backAlpha:0.5 touchClose:NO];
    }

}

#pragma -mark "alert title view"

- (void)mainAlertTitle:(NSString *)mtitle {
    CGRect mainRect = [UIScreen mainScreen].bounds;
    CGFloat wlength = 120;
    CGFloat hlength = 44;
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(mainRect.size.width/2-wlength/2, mainRect.size.height/2-hlength/2, wlength, hlength)];
    contentView.backgroundColor = [UIColor clearColor];
    contentView.layer.cornerRadius = 22;
    contentView.layer.borderWidth = 0.7;
    contentView.layer.borderColor = [UIColor blackColor].CGColor;
    
    UIView *bview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, wlength, hlength)];
    bview.backgroundColor = [UIColor blackColor];
    bview.alpha = 0.7;
    [contentView addSubview:bview];
    contentView.clipsToBounds = YES;
    
    if (![mtitle isEqualToString:@""]) {
        UILabel *subLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, wlength, hlength)];
        subLable.textColor = [UIColor whiteColor];
        subLable.textAlignment = NSTextAlignmentCenter;
        subLable.text = mtitle;
        [contentView addSubview:subLable];
        
        [UNAlertView content:contentView backAlpha:0 touchClose:YES];
    }
}

@end
