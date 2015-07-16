//
//  TMFrostedMenuCell.m
//  Jingtemai
//
//  Created by Jasper on 15/4/15.
//  Copyright (c) 2015年 jasper. All rights reserved.
//

#import "TMFrostedMenuCell.h"
#import "UtilToolkit.h"
@interface TMFrostedMenuCell()

@property (nonatomic, readwrite)UIImageView *menuImageView;
@property (nonatomic, readwrite)UILabel    *titleL;

@end

@implementation TMFrostedMenuCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.menuImageView = [UIImageView new];
    self.titleL = [UILabel new];
    self.titleL.font = [UIFont systemFontOfSize:16.0f];
    
    [self.contentView addSubview:self.menuImageView];
    [self.contentView addSubview:self.titleL];
    
    UIView *spacer1 = [UIView new];
    UIView *spacer2 = [UIView new];
    [self.contentView addSubview:spacer1];
    [self.contentView addSubview:spacer2];
    NSArray *arr = @[spacer1,self.menuImageView, self.titleL, spacer2];
    [arr autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:10 insetSpacing:NO matchedSizes:NO];
    [spacer1 autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:spacer2];
    [self.menuImageView autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.contentView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    if (animated) {
        [UIView animateWithDuration:0.5 animations:^{
            if (selected) {
                self.menuImageView.highlighted = selected;
                self.titleL.textColor = TMCOLOR(TM_Red);
            } else {
                self.menuImageView.highlighted = selected;
                self.titleL.textColor = TMCOLOR(TM_Black);
            }
        }];
    } else {
        if (selected) {
            self.menuImageView.highlighted = selected;
            self.titleL.textColor = TMCOLOR(TM_Red);
        } else {
            self.menuImageView.highlighted = selected;
            self.titleL.textColor = TMCOLOR(TM_Black);
        }
    }

    
}

- (void)configCell:(NSDictionary*)dict {
    if (dict == nil) {
        return;
    }
    self.menuImageView.image = [UIImage imageNamed:dict[@"image"]];
    self.menuImageView.highlightedImage = [UIImage imageNamed:dict[@"highlightedImage"]];
    self.titleL.text = dict[@"title"];
}
@end
