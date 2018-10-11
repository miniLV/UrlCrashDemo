//
//  MNFloatConst.h
//  weChatFloatBtn
//
//  Created by 梁宇航 on 2018/10/11.
//  Copyright © 2018年 梁宇航. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface MNFloatConst : NSObject

extern CGFloat const floatBtnWH;
extern CGFloat const defaultMargin;

//屏幕宽高
#define ScreenH  [[UIScreen mainScreen] bounds].size.height
#define ScreenW  [[UIScreen mainScreen] bounds].size.width

// iPhone X
#define  LL_iPhoneX (ScreenW == 375.f && ScreenH == 812.f ? YES : NO)

// Status bar height.
#define  LL_StatusBarHeight      (LL_iPhoneX ? 44.f : 20.f)

// Status bar & navigation bar height.
#define  DefaultNaviHeight  (LL_iPhoneX ? 88.f : 64.f)

//图片方法(直接字符串赋值)
#define MNImage(imgName)  [UIImage imageNamed:imgName]

//创建frame
#define Frame(x,y,width,height) CGRectMake(x, y, width, height)


@end
