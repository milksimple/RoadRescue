//
//  JXLoginViewController.m
//  RoadRescue
//
//  Created by mac on 16/6/7.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "JXLoginViewController.h"
#import "MBProgressHUD+MJ.h"
#import "JXHttpTool.h"
#import <SMS_SDK/SMSSDK.h>
#import "JXAccountTool.h"

@interface JXLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *telephoneField;

@property (weak, nonatomic) IBOutlet UITextField *verifiField;
/** 获取验证码按钮 */
@property (nonatomic, weak) UIButton *getVerifiButton;
/** 同意协议按钮 */
@property (weak, nonatomic) IBOutlet UIButton *agreeButton;
/** 定时器 */
@property (nonatomic, strong) NSTimer *timer;
/** 倒计时 */
@property (nonatomic, assign) NSInteger timeout;

@end

@implementation JXLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.timeout = 60;
    
    // 初始化textField样式
    [self setupTextField];
    
    // 初始化获取验证码按钮
    [self setupVerfiButton];
    
    [self setupNav];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.timer invalidate];
    self.timer = nil;
}

/**
 *  初始化textField样式
 */
- (void)setupTextField {
    self.telephoneField.leftViewMode = UITextFieldViewModeAlways;
    self.telephoneField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 44)];
    
    self.verifiField.leftViewMode = UITextFieldViewModeAlways;
    self.verifiField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 44)];
}

/**
 *  初始化获取验证码按钮
 */
- (void)setupVerfiButton {
    self.verifiField.rightViewMode = UITextFieldViewModeAlways;
    UIButton *getVerifiButton = [[UIButton alloc] init];
    getVerifiButton.layer.cornerRadius = 5;
    getVerifiButton.backgroundColor = [UIColor lightGrayColor];
    getVerifiButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [getVerifiButton setTitle:@"点击获取验证码" forState:UIControlStateNormal];
    getVerifiButton.frame = CGRectMake(0, 0, 120, 30);
    self.verifiField.rightView = getVerifiButton;
    self.getVerifiButton = getVerifiButton;
    
    [getVerifiButton addTarget:self action:@selector(getVerifiButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupNav {
    self.navigationItem.title = @"请输入手机号";
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.titleLabel.textColor = [UIColor whiteColor];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    
    self.navigationController.navigationBar.barTintColor = JXMiOrangeColor;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}

- (void)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 *  获取验证码被点击
 */
- (void)getVerifiButtonClicked {
    if (self.telephoneField.text.length == 0) {
        [MBProgressHUD showError:@"请填写手机号"];
        return;
    }
    
    // button不可用
    self.getVerifiButton.enabled = NO;
    // button显示倒计时
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    
    // 获取验证码
    [self getVerificationCode];
}

/**
 *  获取验证码
 */
- (void)getVerificationCode {
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.telephoneField.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
        if (!error) {
            [MBProgressHUD showSuccess:@"验证码已发送"];
        }
        else {
            [MBProgressHUD showError:@"验证码发送失败，请1分钟后重试"];
        }
    }];
}

/**
 *  倒计时
 */
- (void)countDown {
    _timeout --;
    
    [self.getVerifiButton setTitle:[NSString stringWithFormat:@"重新获取验证码(%zds)", _timeout] forState:UIControlStateNormal];
    if (_timeout <= 0) { // 停止倒计时
        _timeout = 60;
        [self.timer invalidate];
        self.timer = nil;
        self.getVerifiButton.enabled = YES;
        [self.getVerifiButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
}

- (IBAction)agreeButtonClicked:(UIButton *)sender {
    sender.selected = !sender.isSelected;
}

- (IBAction)serviceButtonClicked {
    
}

- (IBAction)registerButtonClicked {
    // 0.判断信息是否填写完整
    if (self.telephoneField.text.length == 0 || self.verifiField.text.length == 0) {
        [MBProgressHUD showError:@"请将信息填写完整"];
        return;
    }
    
    if (self.agreeButton.selected == NO) {
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"请同意服务协议" message:@"请仔细阅读6号救援服务协议，并选择同意" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cfmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertVC addAction:cfmAction];
        [self presentViewController:alertVC animated:YES completion:nil];
        return;
    }
    
    // 1.验证验证码
    [MBProgressHUD showMessage:@"正在注册"];
    
    [SMSSDK commitVerificationCode:self.verifiField.text phoneNumber:self.telephoneField.text zone:@"86" result:^(NSError *error) {
        if (!error) { // 验证成功,可以开始注册
            JXLog(@"验证成功");
            NSMutableDictionary *paras = [NSMutableDictionary dictionary];
            paras[@"mobile"] = self.telephoneField.text;
            [JXHttpTool post:[NSString stringWithFormat:@"%@/register", JXServerName] params:paras success:^(id json) {
                [MBProgressHUD hideHUD];
                
                JXLog(@"注册成功 - %@", json);
                BOOL success = [json[@"success"] boolValue];
                if (success) { // 注册成功
                    [MBProgressHUD showSuccess:@"开始下单吧！"];
                    
                    // 存储token
                    JXAccount *account = [[JXAccount alloc] init];
                    account.telephone = paras[@"mobile"];
                    account.token = json[@"data"][@"token"];
                    [JXAccountTool saveAccount:account];
                    
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
                else { // 注册失败
                    [MBProgressHUD showError:json[@"msg"]];
                }
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showError:@"网络连接失败"];
                JXLog(@"注册请求失败 - %@", error);
            }];
        }
        else { // 验证失败,不需要请求注册
            [MBProgressHUD hideHUD];
            [MBProgressHUD showError:[NSString stringWithFormat:@"%@", error.userInfo[@"commitVerificationCode"]]];
            JXLog(@"验证失败-错误信息:%@",error);
        }
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    [self.view endEditing:YES];
}
@end
