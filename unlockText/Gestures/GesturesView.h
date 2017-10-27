//
//  GesturesView.h
//  unlockText
//
//  Created by 尹星 on 2017/10/27.
//  Copyright © 2017年 尹星. All rights reserved.
//

#import <UIKit/UIKit.h>

//回传选择的id
typedef void (^GestureBlock)(NSArray *selectedID);
//判断是否解锁成功
typedef void (^UnlockBlock)(BOOL isSuccess);
//设置手势失败
typedef void (^SettingBlock)();

@interface GesturesView : UIView

@property (nonatomic, copy) GestureBlock             gestureBlock;
@property (nonatomic, copy) UnlockBlock            unlockBlock;
@property (nonatomic, copy) SettingBlock           settingBlock;

@property (nonatomic, assign) BOOL         settingGesture;

@end
