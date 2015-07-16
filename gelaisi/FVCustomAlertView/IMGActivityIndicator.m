//
//  IMGActivityIndicator.m
//  IMGActivityIndicator
//
//  Created by Maijid Moujaled on 11/12/14.
//  Copyright (c) 2014 Maijid Moujaled. All rights reserved.
//

#import "IMGActivityIndicator.h"

static const CGFloat IMGCircleLineWidth = 1.65;
static const CGFloat IMGDuration = 1.4; // Duration for every stroke cycle

// Helper Function to get center of CGRect
CGPoint CGRectGetCenter(CGRect rect)
{
    return CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
}

@interface IMGActivityIndicator ()

@property (nonatomic, strong) NSMutableArray *shapeLayers;
@property (nonatomic, strong) NSArray *strokeTimings;
@property (nonatomic, strong) CADisplayLink *timer;

@end

@implementation IMGActivityIndicator

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _strokeColor = [UIColor whiteColor];
        [self XcteLayers];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _strokeColor = [UIColor whiteColor];
        [self XcteLayers];
    }
    return self;
}

- (void)XcteLayers
{
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 ,CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    backgroundView.layer.borderColor = [UIColor blackColor].CGColor;
    backgroundView.backgroundColor = [UIColor clearColor];
    
    self.shapeLayers = [NSMutableArray new];
    
    // Draw the middle dot.
    UIBezierPath *dot =[UIBezierPath bezierPathWithArcCenter:CGRectGetCenter(backgroundView.frame)
                                                      radius:IMGCircleLineWidth
                                                  startAngle:-0.5 * M_PI
                                                    endAngle:1.5 * M_PI
                                                   clockwise:YES];
    
    CAShapeLayer *dotLayer = [CAShapeLayer layer];
    dotLayer.path = dot.CGPath;
    dotLayer.fillColor = [UIColor whiteColor].CGColor;
    [backgroundView.layer addSublayer:dotLayer];
    
    self.strokeTimings = @[@0.35, @0.50, @0.65, @0.80, @0.95];
    NSArray *radii = @[@16, @13, @10, @7, @4];
    
    // Draw our looping stroke lines
    for (int i = 0; i < 5; i++) {
        CAShapeLayer *circleLayer = [CAShapeLayer layer];
        CGFloat radius = [radii[i] floatValue];
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGRectGetCenter(backgroundView.frame)
                                                            radius:radius
                                                        startAngle:-0.5 * M_PI
                                                          endAngle:1.5 * M_PI
                                                         clockwise:YES];
        
        circleLayer.path = path.CGPath;
        circleLayer.strokeColor = self.strokeColor.CGColor;
        circleLayer.lineWidth = IMGCircleLineWidth;
        circleLayer.fillColor = nil;
        circleLayer.contentsScale = [UIScreen mainScreen].scale;
        
        [self.shapeLayers addObject:circleLayer];
        [backgroundView.layer addSublayer:circleLayer];
    }
    
    [self addSubview:backgroundView];
    [self loopAnimations];

    // Use a CADisplayLink timer to fire every time we need to reloop both stroke start and end animation.
    self.timer = [CADisplayLink displayLinkWithTarget:self selector:@selector(loopAnimations)];
    self.timer.frameInterval = 60 * 2 * IMGDuration;
    [self.timer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

/*
 *For every loop (in 3.33s) we add both our strokeStart and strokeEnd animations for the next looping cycle.
 */
- (void)loopAnimations
{
    for (int i = 0; i < 5; i++) {
        
        CAShapeLayer *circleLayer = self.shapeLayers[i];
        CGFloat timeDuration =  [self.strokeTimings[i] floatValue];
        
        CABasicAnimation *strokeStartAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
        strokeStartAnimation.fromValue = @0;
        strokeStartAnimation.toValue = @1.08;
        strokeStartAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        strokeStartAnimation.beginTime = CACurrentMediaTime() + timeDuration;
        strokeStartAnimation.duration = IMGDuration;
        [circleLayer addAnimation:strokeStartAnimation forKey:nil];
        
        CABasicAnimation *strokEndAnimation  = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        strokEndAnimation.fromValue = @0;
        strokEndAnimation.toValue = @1.08;
        strokEndAnimation.duration = IMGDuration;
        strokEndAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        strokEndAnimation.beginTime = CACurrentMediaTime() + timeDuration + IMGDuration;
        [circleLayer addAnimation:strokEndAnimation forKey:nil];
    }
}

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com 
