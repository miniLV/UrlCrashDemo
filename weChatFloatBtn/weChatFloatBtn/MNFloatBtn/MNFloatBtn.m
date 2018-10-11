//
//  MNFloatBtn.m
//  weChatFloatBtn
//
//  Created by 梁宇航 on 2018/10/11.
//  Copyright © 2018年 梁宇航. All rights reserved.
//

#import "MNFloatBtn.h"
#import "MNFloatConst.h"

@implementation MNFloatBtn{
    
    //点击的点，在整个界面中的坐标
    CGPoint _startPoint;
    
    //点击的点，在floatBtn中的坐标
    CGPoint _pointInSelf;
}

static MNFloatBtn *_floatBtn;

+ (void)show{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _floatBtn = [[MNFloatBtn alloc]initWithFrame:Frame(10, 200, floatBtnWH, floatBtnWH)];
    });
    
    if (!_floatBtn.superview) {
        
        [[UIApplication sharedApplication].keyWindow addSubview:_floatBtn];
        //让floatBtn在最上层(即便以后还有keywindow add subView，也会在 floatBtn下)
        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:_floatBtn];
    }
}


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        
        [self setBackgroundImage:MNImage(@"float_ball") forState:UIControlStateNormal];
//        self.backgroundColor = [UIColor orangeColor];
    }
    return self;
}

#pragma mark - UITouch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //按钮刚按下的时候，获取此时的起始坐标
    UITouch *touch = [touches anyObject];
    _startPoint = [touch locationInView:self.superview];
    _pointInSelf = [touch locationInView:self];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
   
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.superview];
    
    //1.计算移动的距离
    CGFloat centerX = currentPoint.x - _pointInSelf.x + self.frame.size.width * 0.5;
    CGFloat centerY = currentPoint.y - _pointInSelf.y + self.frame.size.height * 0.5;
    
    //2.设置越界范围
    //x坐标 = 30 ~ screenW - 30 (30 = btn宽)
    //y坐标 = 30 ~ screenH - 30
    CGFloat tempMargin = floatBtnWH * 0.5;
    CGFloat x = MAX(tempMargin, MIN(ScreenW - tempMargin , centerX));
    CGFloat y = MAX(tempMargin, MIN(ScreenH - tempMargin , centerY));

    self.center = CGPointMake(x, y);
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.superview];
    
    if (CGPointEqualToPoint(currentPoint, _startPoint)) {
        //说明相等 = 点击
        return;
    }else{
        //不等 = 拖动
    }
    
    if (currentPoint.x > ScreenW * 0.5) {
        //往右靠
        [UIView animateWithDuration:0.3 animations:^{
            self.center = CGPointMake(ScreenW - floatBtnWH * 0.5 - defaultMargin, self.center.y);
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            self.center = CGPointMake(floatBtnWH * 0.5 + defaultMargin, self.center.y);
        }];
    }
    
}

@end
