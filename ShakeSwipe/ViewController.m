
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


static const CGFloat kTime = 1.2;
static const CGFloat kWitdh = 0.5;
static const CGFloat kHeight = 0.4;
static const CGFloat kInitalSpringSpeed = 0;
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
                                                    if ( posValue > .25) {

                                                        if(!isMoving)
                                                        {
//                                                            NSLog(@"%f",motion.userAcceleration.x);
                                                            isMoving = YES;
                                                            [self moverWithOffset:motion.userAcceleration.x];
                                                        }
                                                    }
        }];
    }
    
    //create the first and second view
    _firstView = [[UIView alloc]initWithFrame:CGRectZero];
    _firstView.backgroundColor = [UIColor colorWithRed:0.32 green:0.26 blue:0.35 alpha:1];
    _firstView.tag = 99;
    
    _secondView = [[UIView alloc]initWithFrame:CGRectZero];
    _secondView.backgroundColor = [UIColor colorWithRed:0.91 green:0.3 blue:0.24 alpha:1];
    _secondView.tag = 100;
    
    [self.view addSubview:_firstView];
    [self.view addSubview:_secondView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self initalLayout];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self animateLeftWithView:_secondView];
    });
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
    NSLog(@"MOVING AGAIN");
    UIView *frontCard = [self topCard];
    MOVT direction = [self directionFromGyroX:offset];
    [self popCard:frontCard movement:direction];
}


#pragma mark - Helpers
- (UIView *)topCard
{
    NSLog(@"TOP VIEW");
    return  (UIView *)[self.view subviews].lastObject;
}

- (MOVT)directionFromGyroX:(double)value
{
    return value > 0 ? LEFT : RIGHT;
}

- (UIView *)viewUnderNeathView:(UIView *)view
{
    if(view == _firstView)
    {
        return  _secondView;
    }else
    {
        return _firstView;
    }
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

    [self animateScaleUpWithView:[self viewUnderNeathView:view]];
}



#pragma mark - Animations

- (void)animateScaleUpWithView:(UIView *)view
{
    view.transform = CGAffineTransformMakeScale(0.5, 0.5);
    [UIView animateWithDuration:kTime
                          delay:.4
         usingSpringWithDamping:.4
          initialSpringVelocity:5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         view.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}
- (void)animateLeftWithView:(UIView *)view
{
    NSLog(@"Move Left");
    [self setViewToLeft:view];
    [UIView animateWithDuration:kTime
                          delay:0
         usingSpringWithDamping:3
          initialSpringVelocity:kInitalSpringSpeed
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CATransform3D t = CATransform3DIdentity;
                         t = CATransform3DRotate(t, 15.0f * M_PI / 180.0f, 0, 0, 1);
                         view.layer.transform = t;
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         [self setViewToCenter:view];
                     }];
}

- (void)animateRightWithView:(UIView *)view
{
    NSLog(@"Move RIght");

    [self setViewToRight:view];
    [UIView animateWithDuration:kTime
                          delay:0
         usingSpringWithDamping:3
          initialSpringVelocity:kInitalSpringSpeed
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         CATransform3D t = CATransform3DIdentity;
                         t = CATransform3DRotate(t, -15.0f * M_PI / 180.0f, 0, 0, 1);
                         view.layer.transform = t;
                         [self.view layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         [self setViewToCenter:view];
                     }];

}



#pragma mark - New Set Of Constraints To Move views off screen

- (void)setViewToLeft:(UIView *)view
{
    UIView *superview = self.view;
    view.layer.transform = CATransform3DIdentity;
    [self.view exchangeSubviewAtIndex:2 withSubviewAtIndex:3];
    [view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(superview.mas_width).with.multipliedBy(kWitdh);
        make.height.equalTo(superview.mas_height).with.multipliedBy(kWitdh);
        make.right.equalTo(superview.mas_left);
        make.centerY.equalTo(superview.mas_centerY);
    }];
}

- (void)setViewToRight:(UIView *)view
{
    UIView *superview = self.view;
    view.layer.transform = CATransform3DIdentity;
    [self.view exchangeSubviewAtIndex:2 withSubviewAtIndex:3];
    [view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(superview.mas_width).with.multipliedBy(kWitdh);
        make.height.equalTo(superview.mas_height).with.multipliedBy(kWitdh);
        make.left.equalTo(superview.mas_right);
        make.centerY.equalTo(superview.mas_centerY);
    }];
}


- (void)setViewToCenter:(UIView *)view
{
    UIView *superview = self.view;
    view.layer.transform = CATransform3DIdentity;

    UIView *topView = view;
    [view removeFromSuperview];
    
    [self.view insertSubview:topView belowSubview:self.view.subviews.lastObject];

    [view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(superview.mas_width).with.multipliedBy(kWitdh);
        make.height.equalTo(superview.mas_height).with.multipliedBy(kWitdh);
        make.centerX.equalTo(superview.mas_centerX);
        make.centerY.equalTo(superview.mas_centerY);
        
    }];
    isMoving = NO;
}


#pragma mark - First Layout
- (void)initalLayout
{
    UIView *superview = self.view;
    [_firstView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(superview.mas_width).with.multipliedBy(kWitdh);
        make.height.equalTo(superview.mas_height).with.multipliedBy(kWitdh);
        make.centerX.equalTo(superview.mas_centerX);
        make.centerY.equalTo(superview.mas_centerY);
    }];
    
    [_secondView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(superview.mas_width).with.multipliedBy(kWitdh);
        make.height.equalTo(superview.mas_height).with.multipliedBy(kWitdh);
        make.centerX.equalTo(superview.mas_centerX);
        make.centerY.equalTo(superview.mas_centerY);
    }];
}
@end
