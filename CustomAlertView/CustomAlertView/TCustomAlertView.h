//
//  TUserAlertView.h
//  TUser
//
//  Created by Duzj on 2018/5/30.
//

#import <UIKit/UIKit.h>

#pragma mark  - TCustomAlertAction

@interface TCustomAlertAction : NSObject

+ (instancetype)actionWithTitle:(nullable NSString *)title titleColor:(nullable UIColor*)titleColor handler:(void (^ __nullable)(TCustomAlertAction *action))handler;

@end

#pragma mark  - TUserAlertView

@interface TCustomAlertView : UIView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message;

- (void)addAction:(TCustomAlertAction *)action;

- (void)show;

@end

