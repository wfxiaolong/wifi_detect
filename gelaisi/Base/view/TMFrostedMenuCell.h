//
//  TMFrostedMenuCell.h
//  Jingtemai
//
//  Created by Jasper on 15/4/15.
//  Copyright (c) 2015年 jasper. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString * const kReuseTMFrostedMenuCellIndentifier = @"TMFrostedMenuCell";
@interface TMFrostedMenuCell : UITableViewCell

@property (nonatomic, readonly)UIImageView *menuImageView;
@property (nonatomic, readonly)UILabel    *titleL;


- (void)configCell:(NSDictionary*)dict;
@end
