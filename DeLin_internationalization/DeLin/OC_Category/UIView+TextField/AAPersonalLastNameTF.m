//
//  AAPersonalTF.m
//  DeLin
//
//  Created by 安建伟 on 2019/12/4.
//  Copyright © 2019 com.thingcom. All rights reserved.
//

#import "AAPersonalLastNameTF.h"

#define DURATION_TIME 0.3

@implementation AAPersonalLastNameTF

-(instancetype)initWithFrame:(CGRect)frame withPlaceholderText:(NSString *)lastName{
    self = [super init];
    if (self) {
        
        self.PlaceholderText = lastName;
        
        UITextField *inputLastNameTF = [[UITextField alloc]init];
        inputLastNameTF.textColor = [UIColor whiteColor];
        inputLastNameTF.tintColor = [UIColor whiteColor];
        //ios13适配KVC
        self.inputLastNameTF.attributedPlaceholder = [self placeholder:lastName];
        inputLastNameTF.font = [UIFont systemFontOfSize:18]; //SYS_FONT(18);
        self.lastNameTFFrame = CGRectMake(CGRectGetMinX(frame), 0 , frame.size.width, frame.size.height);
        inputLastNameTF.frame = self.lastNameTFFrame;
        
        inputLastNameTF.delegate = self;
        self.inputLastNameTF = inputLastNameTF;
        [self.inputLastNameTF setReturnKeyType:UIReturnKeyNext];
        [self addSubview:inputLastNameTF];
        
        //自定义boder的样式
        [inputLastNameTF setBorderWithTop:YES Left:YES Bottom:YES Right:YES BorderColor:[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0] BorderWidth:1];
        //上移动 label的Frame
        self.labelView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.lastNameTFFrame) + 20 , CGRectGetMinY(self.lastNameTFFrame) + yAutoFit(20), yAutoFit(100) , yAutoFit(18))];
        self.labelView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1.0];
        //建立图层 防止点击labelView背景不响应事件
        [self insertSubview:self.labelView atIndex:0];
        
        CGRect frameLabel = CGRectMake(CGRectGetMinX(self.labelView.bounds) + 5 , CGRectGetMinY(self.labelView.bounds) + 5 , self.labelView.bounds.size.width , self.labelView.bounds.size.height);
        self.textLabel = [self makeWithFrame:frameLabel];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.adjustsFontSizeToFitWidth = YES;
        self.textLabel.font = [UIFont systemFontOfSize:15.f];
        [self.labelView addSubview:self.textLabel];
        [self bringSubviewToFront:self.inputLastNameTF];
        
    }
    return self;
}

- (NSMutableAttributedString *)placeholder:(NSString *)text{
    if (text.length == 0) {
        return nil;
    }
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor grayColor]}];
    return att;
}

-(UILabel *)makeWithFrame:(CGRect)frame
{
    UILabel *label = [UILabel new];
    label.frame = CGRectMake(frame.origin.x , frame.origin.y ,frame.size.width, frame.size.height);
    label.textColor = [UIColor grayColor];
    label.text = self.PlaceholderText;
    return label;
}


-(void)addBeginAnimationWithLabel:(UIView *)label
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DURATION_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CGRect frame = label.frame;
        CABasicAnimation *aniBounds = [CABasicAnimation animationWithKeyPath:@"bounds"];
        aniBounds.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, CGRectGetWidth(frame), 0)];
        aniBounds.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        
        CABasicAnimation *aniScale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        aniScale.fromValue = [NSNumber numberWithFloat:1.0];
        aniScale.toValue = [NSNumber numberWithFloat:0.6];
        
        CABasicAnimation *aniPosition = [CABasicAnimation animationWithKeyPath:@"position"];
        aniPosition.fromValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetMinX(frame), label.frame.origin.y)];
        aniPosition.toValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetMinX(frame), label.frame.origin.y - 13)];
        
        CABasicAnimation *aniAnchorPoint = [CABasicAnimation animationWithKeyPath:@"anchorPoint"];
        aniAnchorPoint.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, 1)];
        aniAnchorPoint.toValue = [NSValue valueWithCGPoint:CGPointMake(0, 1)];
        
        CAAnimationGroup *anis = [CAAnimationGroup animation];
        anis.animations = @[aniBounds,aniPosition,aniScale,aniAnchorPoint];
        anis.duration = DURATION_TIME;
        anis.removedOnCompletion = NO;
        anis.fillMode = kCAFillModeForwards;
        [label.layer addAnimation:anis forKey:nil];
    });
}

-(void)lastNameTFBeginEditing
{
    //改变图层显示效果
    [self insertSubview:self.labelView atIndex:2];
    [self addBeginAnimationWithLabel:self.labelView];
}

-(void)addEndAnimationWithLabel:(UIView *)label
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DURATION_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        CGRect frame = label.frame;
        CABasicAnimation *aniBounds = [CABasicAnimation animationWithKeyPath:@"bounds"];
        aniBounds.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, CGRectGetWidth(frame), 0)];
        aniBounds.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
        
        CABasicAnimation *aniAnchorPoint = [CABasicAnimation animationWithKeyPath:@"anchorPoint"];
        aniAnchorPoint.toValue = [NSValue valueWithCGPoint:CGPointMake(0, 1)];
        aniAnchorPoint.fromValue = [NSValue valueWithCGPoint:CGPointMake(0, 1)];
        
        CABasicAnimation *aniPosition = [CABasicAnimation animationWithKeyPath:@"position"];
        aniPosition.toValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetMinX(frame), label.frame.origin.y)];
        aniPosition.fromValue = [NSValue valueWithCGPoint:CGPointMake(CGRectGetMinX(frame), label.frame.origin.y -13)];
        
        CABasicAnimation *aniScale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        aniScale.fromValue = [NSNumber numberWithFloat:0.6];
        aniScale.toValue = [NSNumber numberWithFloat:1.0];
        
        CAAnimationGroup *anis = [CAAnimationGroup animation];
        anis.animations = @[aniBounds,aniPosition,aniScale,aniAnchorPoint];
        anis.duration = DURATION_TIME;
        anis.removedOnCompletion = NO;
        anis.fillMode = kCAFillModeForwards;
        [label.layer addAnimation:anis forKey:nil];
        
        //恢复图层效果
        [self insertSubview:self.labelView atIndex:0];
    });
}

-(void)lastNameTFEndEditing
{
    [self addEndAnimationWithLabel:self.labelView];
}

@end
