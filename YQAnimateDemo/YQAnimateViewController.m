//
//  BezierViewController.m
//  AnimationDemo
//
//  Created by 俞琦 on 2017/2/20.
//  Copyright © 2017年 俞琦. All rights reserved.
//

#import "YQAnimateViewController.h"

@interface YQAnimateViewController ()
@property (nonatomic, weak) CAShapeLayer *layer;
@end

@implementation YQAnimateViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [UIColor greenColor].CGColor;
    layer.lineCap = kCALineCapRound;
    layer.lineJoin = kCALineJoinRound;
    layer.lineWidth = 4;
    layer.frame = self.view.bounds;
    layer.path = [self classOneBezierPath].CGPath;
//    [layer setValue:@(M_PI) forKeyPath:@"transform.rotation.z"];

    [self.view.layer addSublayer:layer];
    self.layer = layer;
    
    UIButton *animateBtn = [UIButton new];
    animateBtn.frame = CGRectMake(self.view.bounds.size.width - 100, self.view.bounds.size.height - 50, 100, 50);
    [animateBtn setTitle:@"开始动画" forState:UIControlStateNormal];
    [animateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [animateBtn addTarget:self action:@selector(startAnimate) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:animateBtn];
    
    UISlider *slider = [UISlider new];
    slider.frame = CGRectMake(0, self.view.bounds.size.height - 50, self.view.bounds.size.width - 100, 50);
    [slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:slider];
}


- (void)startAnimate
{
    [self.layer addAnimation:[self animationGroup] forKey:@"animate"];
}

- (void)sliderValueChange:(UISlider *)slider
{
    self.layer.strokeStart = slider.value;
}

#pragma mark - path
// 圆形
- (UIBezierPath *)circlePath
{
    return [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 100, 100)];
}

// 矩形
- (UIBezierPath *)rectanglePath
{
    return [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, 100, 100)];
}

// 有圆角的矩形
- (UIBezierPath *)roundedPath
{
    return [UIBezierPath bezierPathWithRoundedRect:CGRectMake(100, 100, 100, 100) cornerRadius:5];
}

// 圆弧
- (UIBezierPath *)arcPath
{
    return [UIBezierPath bezierPathWithArcCenter:CGPointMake(100, 100) radius:50 startAngle:M_PI_2 endAngle:M_PI_2*3 clockwise:YES];
}

// 一级贝塞尔
- (UIBezierPath *)classOneBezierPath
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(20, 100)];
    [path addQuadCurveToPoint:CGPointMake(220, 100) controlPoint:CGPointMake(120, 200)];
    return path;
}

// 二级贝塞尔
- (UIBezierPath *)classTwoBezierPath
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(20, 100)];
    [path addCurveToPoint:CGPointMake(220, 100) controlPoint1:CGPointMake(120, 20) controlPoint2:CGPointMake(120, 180)];
    return path;
}

// 画图
- (UIBezierPath *)DIYPath
{
    UIBezierPath *DIYPath = [UIBezierPath bezierPath];
    
    [DIYPath moveToPoint:CGPointMake(100, 100)];
    [DIYPath addLineToPoint:CGPointMake(100, 200)];
    [DIYPath addLineToPoint:CGPointMake(80, 170)];
    [DIYPath moveToPoint:CGPointMake(100, 200)];
    [DIYPath addLineToPoint:CGPointMake(120, 170)];
    
    return DIYPath;
}


#pragma mark - BasicAnimate
// key 为 path的animate
- (CABasicAnimation *)pathBasicAnimate
{
    CABasicAnimation *animate = [CABasicAnimation animationWithKeyPath:@"path"];
    animate.removedOnCompletion = NO;
    animate.duration = 1;
    animate.fillMode = kCAFillModeForwards;
    animate.toValue = (__bridge id _Nullable)([self classTwoBezierPath].CGPath);
    return animate;
}

// key 为 position的animate
- (CABasicAnimation *)positionBasicAnimate
{
    CABasicAnimation *animate = [CABasicAnimation animationWithKeyPath:@"position"];
    animate.removedOnCompletion = NO;
    animate.duration = 1;
    animate.fillMode = kCAFillModeForwards;
    animate.toValue = [NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2 + 100, self.view.frame.size.height/2)];
    return animate;
}

// key 为 transform.rotation.z 的animate
- (CABasicAnimation *)rotationBasicAnimate
{
    CABasicAnimation *animate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animate.removedOnCompletion = NO;
    animate.duration = 1;
    animate.fillMode = kCAFillModeForwards;
    animate.toValue = @(M_PI*2);
    return animate;
}

// key 为strokeStart的animate
- (CABasicAnimation *)strokeStartBasicAnimate
{
    CABasicAnimation *animate = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    animate.removedOnCompletion = NO;
    animate.duration = 1;
    animate.repeatCount = HUGE;
    animate.fillMode = kCAFillModeForwards;
    animate.toValue = @1;
    return animate;
}

#pragma mark - KeyframeAnimation
- (CAKeyframeAnimation *)keyframeAnimation
{
    CAKeyframeAnimation *keyframeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    keyframeAnimation.duration = 3;
    keyframeAnimation.values = @[(__bridge id)[self classOneBezierPath].CGPath,
                                 (__bridge id)[self classTwoBezierPath].CGPath,
                                (__bridge id)[self arcPath].CGPath,
                                (__bridge id)[self DIYPath].CGPath];
    keyframeAnimation.keyTimes = @[@(0.25), @(0.5), @(0.75), @(1)];
    keyframeAnimation.fillMode = kCAFillModeForwards;
    keyframeAnimation.removedOnCompletion = NO;
    return keyframeAnimation;
}

#pragma mark - CAAnimationGroup
- (CAAnimationGroup *)animationGroup
{
    CABasicAnimation *animate = [CABasicAnimation animationWithKeyPath:@"position"];
    animate.removedOnCompletion = NO;
    animate.fillMode = kCAFillModeForwards;
    animate.toValue = [NSValue valueWithCGPoint:CGPointMake(self.view.frame.size.width/2 + 100, self.view.frame.size.height/2)];
    
    
    CAKeyframeAnimation *keyframeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    keyframeAnimation.values = @[(__bridge id)[self classOneBezierPath].CGPath,
                                 (__bridge id)[self classTwoBezierPath].CGPath,
                                 (__bridge id)[self arcPath].CGPath,
                                 (__bridge id)[self DIYPath].CGPath];
    keyframeAnimation.keyTimes = @[@(0.25), @(0.5), @(0.75), @(1)];
    keyframeAnimation.fillMode = kCAFillModeForwards;
    keyframeAnimation.removedOnCompletion = NO;
    
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[animate, keyframeAnimation];
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    group.duration = 3;
    return group;
}
@end
