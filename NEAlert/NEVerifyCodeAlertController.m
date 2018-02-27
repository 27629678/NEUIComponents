//
//  NEVerifyCodeAlertController.m
//  VerifyCodeDemo
//
//  Created by hzyuxiaohua on 25/02/2018.
//  Copyright © 2018 hzyuxiaohua. All rights reserved.
//

#import "NEVerifyCodeAlertController.h"

@interface NEVerifyCodeAlertController ()

@property (nonatomic, strong) UIButton *refreshButton;

@property (nonatomic, copy) NSString *cancelTitle;
@property (nonatomic, copy) NSString *confirmTitle;

@property (nonatomic, weak) void(^cancelAction)(id sender);
@property (nonatomic, weak) void(^confirmAction)(id sender, NSString *code);
@property (nonatomic, weak) void(^refreshAction)(id sender, NEVerifyCodeAlertController *alert);

@end

@implementation NEVerifyCodeAlertController

+ (instancetype)alertControllerWithTitle:(NSString *)title
{
    NEVerifyCodeAlertController *alert =
    [NEVerifyCodeAlertController alertControllerWithTitle:title
                                                  message:nil
                                           preferredStyle:UIAlertControllerStyleAlert];
    
    __weak __typeof(alert) weakalert = alert;
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        [weakalert configureTextfield:textField];
    }];
    
    return alert;
}

- (void)updateVerifyCodeImage:(UIImage *)image
{
    [self.refreshButton setImage:image forState:UIControlStateNormal];
    [self.refreshButton setImage:image forState:UIControlStateHighlighted];
}

- (void)setCancelButtonTitle:(NSString *)title handler:(void (^)(UIAlertAction *))handler
{
    self.cancelTitle = title;
    self.cancelAction = handler;
}

- (void)setVerifyButtonTitle:(NSString *)title handler:(void (^)(UIAlertAction *, NSString *))handler
{
    self.confirmTitle = title;
    self.confirmAction = handler;
}

- (void)setRefreshVerifyCodeButtonHandler:(void (^)(UIButton *, NEVerifyCodeAlertController *))handler
{
    self.refreshAction = handler;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    __weak __typeof(self) weakself = self;
    
    // 2. add cancel btn
    if (self.cancelTitle.length > 0) {
        UIAlertAction *cancel =
        [UIAlertAction actionWithTitle:self.cancelTitle style:UIAlertActionStyleDefault handler:
         ^(UIAlertAction *action) {
             if (weakself.cancelAction) {
                 weakself.cancelAction(action);
             }
         }];
        [self addAction:cancel];
    }
    
    // 3. add confirm btn
    UIAlertAction *confirm =
    [UIAlertAction actionWithTitle:self.confirmTitle ? : @"OK"
                             style:UIAlertActionStyleDefault
                           handler:
     ^(UIAlertAction * _Nonnull action) {
         UITextField *textField = weakself.textFields.firstObject;
         
         NSCAssert(!!textField, @"");
         if (weakself.confirmAction) {
             weakself.confirmAction(action, textField.text);
         }
     }];
    
    [self addAction:confirm];
}

#pragma mark - private

- (void)configureTextfield:(UITextField *)textField
{
    textField.placeholder = @"请输入右侧的验证码";
    
    textField.rightView = self.refreshButton;
    textField.rightViewMode = UITextFieldViewModeAlways;
    
    // text input traits
    [textField setReturnKeyType:UIReturnKeyContinue];
    [textField setKeyboardType:UIKeyboardTypeASCIICapable];
    [textField setAutocorrectionType:UITextAutocorrectionTypeNo];
}

- (void)refreshButtonAction:(id)sender
{
    if (!self.refreshAction) {
        return;
    }
    
    __weak __typeof(self) weakself = self;
    self.refreshAction(sender, weakself);
}

#pragma mark - getter

- (UIButton *)refreshButton
{
    if (!_refreshButton) {
        _refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_refreshButton setFrame:CGRectMake(0, 0, 107, 20)];
        [_refreshButton addTarget:self
                           action:@selector(refreshButtonAction:)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _refreshButton;
}

@end
