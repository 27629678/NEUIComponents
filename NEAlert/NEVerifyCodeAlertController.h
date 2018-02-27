//
//  NEVerifyCodeAlertController.h
//  VerifyCodeDemo
//
//  Created by hzyuxiaohua on 25/02/2018.
//  Copyright © 2018 hzyuxiaohua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NEVerifyCodeAlertController : UIAlertController

+ (instancetype)alertControllerWithTitle:(NSString *)title;

- (void)updateVerifyCodeImage:(UIImage *)image;

- (void)setCancelButtonTitle:(NSString *)title handler:(void(^)(UIAlertAction *sender))handler;

- (void)setVerifyButtonTitle:(NSString *)title handler:(void(^)(UIAlertAction *sender, NSString *code))handler;

- (void)setRefreshVerifyCodeButtonHandler:(void(^)(UIButton *sender, NEVerifyCodeAlertController *alert))handler;

@end
