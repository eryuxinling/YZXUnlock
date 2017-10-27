//
//  GesturesViewController.m
//  unlockText
//
//  Created by 尹星 on 2017/10/26.
//  Copyright © 2017年 尹星. All rights reserved.
//

#import "GesturesViewController.h"
#import "GesturesView.h"

#define SELF_WIDTH self.view.bounds.size.width
#define SELF_HEIGHT self.view.bounds.size.height
#define RGBCOLOR(x,y,z) [UIColor colorWithRed:(x) / 255.0 green:(y) / 255.0 blue:(z) / 255.0 alpha:1]

@interface GesturesViewController ()
//手势解锁页面
@property (nonatomic, strong) GesturesView             *gesturesView;
//设置手势解锁，确定按钮
@property (weak, nonatomic) IBOutlet UIButton *confirmBut;
//设置手势解锁，取消按钮
@property (weak, nonatomic) IBOutlet UIButton *cancelBut;
//手势解锁提示文本
@property (weak, nonatomic) IBOutlet UILabel *hintLabel;
//设置手势成功id
@property (nonatomic, copy) NSArray             *selectedID;

@end

@implementation GesturesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBCOLOR(60.0, 62.0, 65.0);
    [self p_initView];
}

- (void)p_initView
{
    [self.view addSubview:self.gesturesView];
    //设置手势解锁，显示取消，确定按钮
    if (self.settingGesture) {
        self.confirmBut.hidden = NO;
        self.cancelBut.hidden = NO;
    }
}

- (IBAction)buttonPressed:(UIButton *)sender {
    if (sender == self.confirmBut) {//设置手势，确定是保存手势密码到本地，并显示首页
        [[NSUserDefaults standardUserDefaults] setObject:self.selectedID forKey:@"GestureUnlock"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"touchIDLoginSuccess" object:nil];
    }else {//设置手势，取消返回上一页
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark - 懒加载
- (GesturesView *)gesturesView
{
    if (!_gesturesView) {
        _gesturesView = [[GesturesView alloc] initWithFrame:CGRectMake(40, SELF_HEIGHT / 2.0 - (SELF_WIDTH - 80.0) / 2.0, SELF_WIDTH - 80.0, SELF_WIDTH - 80.0)];
        _gesturesView.backgroundColor = [UIColor clearColor];
        _gesturesView.settingGesture = self.settingGesture;
        __weak typeof(self) weak_self = self;
        //设置手势，记录设置的密码，待确定后确定
        _gesturesView.gestureBlock = ^(NSArray *selectedID) {
            weak_self.selectedID = selectedID;
            weak_self.hintLabel.hidden = YES;
        };
        //判断解锁状态
        _gesturesView.unlockBlock = ^(BOOL isSuccess) {
            weak_self.hintLabel.hidden = NO;
            if (!isSuccess) {
                weak_self.hintLabel.text = @"解锁失败";
                weak_self.hintLabel.textColor = [UIColor redColor];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weak_self dismissViewControllerAnimated:YES completion:nil];
                });
            }else {
                weak_self.hintLabel.textColor = [UIColor greenColor];
                weak_self.hintLabel.text = @"解锁成功";
            }
        };
        //设置失败
        _gesturesView.settingBlock = ^() {
            weak_self.hintLabel.hidden = NO;
            weak_self.hintLabel.text = @"手势密码不得少于4个点";
            weak_self.hintLabel.textColor = [UIColor redColor];
        };
    }
    return _gesturesView;
}

@end
