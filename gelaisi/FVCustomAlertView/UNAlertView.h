//
//  UNAlertView.h
//  UnionSys
//
//  Created by linxiaolong on 15/2/28.
//  Copyright (c) 2015年 linxiaolong. All rights reserved.
//

#import "FVCustomAlertView.h"

typedef void (^TouchBlock)(NSInteger tag);

@interface BlockButton : UIButton

@property (nonatomic, copy) TouchBlock tBlock;

@end

@interface UNAlertView : FVCustomAlertView

/// base confirm alert view

- (void)mainTitle:(NSString *)mtitle
         subTitle:(NSString *)stitle
         btnTitle:(NSString *)btitle
       touchClose:(BOOL)cando
            block:(TouchBlock)block;

/// the wait alertView

- (void)waitTitle:(NSString *)wtitle;

/// the confirm alert view with wait

- (void)mainTitle:(NSString *)mtitle
         subTitle:(NSString *)stitle
      cancelTitle:(NSString *)ctitle
   determineTitle:(NSString *)dtitle
            block:(TouchBlock)block;

/// return the custom animate

- (void)creatCAnimate;

/// title AlertView

- (void)mainAlertTitle:(NSString *)mtitle;

@end

typedef NS_ENUM(NSInteger, ChoiceButtonType) {
    CancelButton = 0,
    ComfirmButton = 1,
};
