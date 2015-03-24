
//  ViewController.m
//  ShakeSwipe
//
//  Created by ROBERA GELETA on 3/24/15.
//  Copyright (c) 2015 ROBERA GELETA. All rights reserved.
//




#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>
#import <Masonry/Masonry.h>

typedef NS_ENUM(NSUInteger, MOVT) {
    LEFT,
    RIGHT,
};


static const CGFloat kTime = 4.5;

@interface ViewController ()
@property (nonatomic) CMMotionManager *motionManager;


@property UIView *firstView ;
@property UIView *secondView;

@end

@implementation ViewController
{
    BOOL isMoving;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    if(self.motionManager.deviceMotionAvailable)
    {
        __weak typeof(self) weakSelf = self;
        [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue]
                                                withHandler:^(CMDeviceMotion *motion, NSError *error) {

                                                    double posValue = fabs(motion.userAcceleration.x);
//                                                    NSLog(@"%f",motion.userAcceleration.x);
                                                    if ( posValue > .15) {
//                                                        NSLog(@"%f",motion.userAcceleration.x);
                                                        if(!isMoving)
                                                        {
                                                            isMoving = YES;
                                                            [self moverWithOffset:motion.userAcceleration.x];
                                                        }
                                                    }
        }];
    }
    
    //create the first and second view
    _firstView = [[UIView alloc]initWithFrame:CGRectZero];
    _firstView.backgroundColor = [UIColor colorWithRed:0.32 green:0.26 blue:0.35 alpha:1];
    
    _secondView = [[UIView alloc]initWithFrame:CGRectZero];
    _secondView.backgroundColor = [UIColor colorWithRed:0.91 green:0.3 blue:0.24 alpha:1];
    
    [self.view addSubview:_firstView];
    [self.view addSubview:_secondView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self initalLayout];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (CMMotionManager *)motionManager
{
    if(!_motionManager)
    {
        _motionManager = [[CMMotionManager alloc]init];
        _motionManager.gyroUpdateInterval = 3.0;

    }
    return _motionManager;
}


#pragma mark - Main Mover
- (void)moverWithOffset:(double)offset
{
    UIView *frontCard = [self topCard];
    MOVT direction = [self directionFromGyroX:offset];
    [self popCard:frontCard movement:direction];
}


#pragma mark - Helpers
- (UIView *)topCard
{
    return  (UIView *)[self.view subviews].lastObject;
}

- (MOVT)directionFromGyroX:(double)value
{
    return value > 0 ; YES ; NO;
}

#pragma mark - Movement Handling 
/**
 *  Pop's the top card off screen and stacks it under neath the new top card
 *
 *  @param view - is the view to be poped off
 */
- (void)popCard:(UIView *)view movement:(MOVT)direction
{
    switch (direction) {
        case LEFT:
            [self animateLeftWithView:view];
            break;
        case RIGHT:
            [self animateRightWithView:view];
            break;
    }
}

#pragma mark - Animations
- (void)animateLeftWithView:(UIView *)view
{
    NSLog(@"Move Left");
    CGPoint mainViewCenter = self.view.center;
    CGSize mainViewBounds = self.view.bounds.size;
    
    CGPoint offscreenLeftCenter = CGPointMake(mainViewCenter.x - mainViewBounds.width, mainViewCenter.y);
    [UIView animateWithDuration:kTime
                          delay:0
         usingSpringWithDamping:.4
          initialSpringVelocity:6
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CATransform3D t = CATransform3DIdentity;
                         t = CATransform3DRotate(t, 45.0f * M_PI / 180.0f, 0, 0, 1);
                         view.layer.transform = t;
                         view.center = offscreenLeftCenter;
                     }
                     completion:^(BOOL finished) {
                         [self setViewToCenter:view];
                     }];
}

- (void)animateRightWithView:(UIView *)view
{
    NSLog(@"Move RIght");
    CGPoint mainViewCenter = self.view.center;
    CGSize mainViewBounds = self.view.bounds.size;
    
    CGPoint offscreenLeftCenter = CGPointMake(mainViewCenter.x +  mainViewBounds.width, mainViewCenter.y);
    [UIView animateWithDuration:kTime
                          delay:0
         usingSpringWithDamping:.4
          initialSpringVelocity:6
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CATransform3D t = CATransform3DIdentity;
                         t = CATransform3DRotate(t, -45.0f * M_PI / 180.0f, 0, 0, 1);
                         view.layer.transform = t;
                         view.center = offscreenLeftCenter;
                     }
                     completion:^(BOOL finished) {
                         [self setViewToCenter:view];
                     }];

}

- (void)setViewToCenter:(UIView *)view
{
    UIView *superview = self.view;
    view.layer.transform = CATransform3DIdentity;
    [self.view exchangeSubviewAtIndex:2 withSubviewAtIndex:3];
    [view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(superview.mas_width).with.multipliedBy(.4);
        make.height.equalTo(superview.mas_height).with.multipliedBy(.4);
        make.centerX.equalTo(superview.mas_centerX);
        make.centerY.equalTo(superview.mas_centerY);

    }];
    NSLog(@"You can move now");
    isMoving = NO;
}


#pragma mark - First Layout
- (void)initalLayout
{
    UIView *superview = self.view;
    [_firstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(superview.mas_width).with.multipliedBy(.4);
        make.height.equalTo(superview.mas_height).with.multipliedBy(.4);
        make.centerX.equalTo(superview.mas_centerX);
        make.centerY.equalTo(superview.mas_centerY);
    }];
    
    [_secondView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(superview.mas_width).with.multipliedBy(.4);
        make.height.equalTo(superview.mas_height).with.multipliedBy(.4);
        make.centerX.equalTo(superview.mas_centerX);
        make.centerY.equalTo(superview.mas_centerY);
    }];
}
@end
