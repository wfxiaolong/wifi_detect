//
//  TMWifiCell.m
//  gelaisi
//
//  Created by lxlong on 15/7/14.
//  Copyright (c) 2015年 lxlong. All rights reserved.
//

#import "TMWifiCell.h"

@implementation TMWifiCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:TMWIFICELLIDENTIFY];
    if (self) {
        self.accessoryType = UITableViewCellAccessoryNone;
        self.separatorInset = UIEdgeInsetsMake(0, 16.0f, 0, 0);
        [self setupView];
    }
    return self;
}

- (void)setupView {
#define HEIGHTFORCELL 50.0f
#define CELLOFFSET    10.0f
    
    self.icon = [UIImageView new];
    self.icon.image = [UIImage imageNamed:@"wifi_icon"];
    [self.contentView addSubview:self.icon];
    [self.icon autoSetDimensionsToSize:CGSizeMake(20, 20)];
    [self.icon autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    [self.icon autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:self.contentView withOffset:10.0f];
    
    self.topic = [UILabel new];
    self.topic.font = [UIFont systemFontOfSize:14.0f];
    self.topic.textColor = TMCOLOR(TM_BlackOne);
    [self.contentView addSubview:self.topic];
    [self.topic autoSetDimension:ALDimensionHeight toSize:20.0f];
    [self.topic autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.icon withOffset:CELLOFFSET];
    [self.topic autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentView withOffset:-CELLOFFSET];
    [self.topic autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:5.0f];
    
    self.stopic = [UILabel new];
    self.stopic.font = [UIFont systemFontOfSize:12.0f];
    self.stopic.textColor = TMCOLOR(TM_DarkGray);
    [self.contentView addSubview:self.stopic];
    [self.stopic autoSetDimension:ALDimensionHeight toSize:20.0f];
    [self.stopic autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:self.icon withOffset:CELLOFFSET];
    [self.stopic autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:self.contentView withOffset:-CELLOFFSET];
    [self.stopic autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView withOffset:-5.0f];
    
}

@end
