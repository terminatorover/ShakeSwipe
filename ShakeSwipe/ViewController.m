
//  ViewController.m
//  ShakeSwipe
//
//  Created by ROBERA GELETA on 3/24/15.
//  Copyright (c) 2015 ROBERA GELETA. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>
#import <Masonry/Masonry.h>

@interface ViewController ()
@property (nonatomic) CMMotionManager *motionManager;


@property UIView *firstView ;
@property UIView *secondView;

@end

@implementation ViewController

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
                                                        NSLog(@"%f",motion.userAcceleration.x);
//                                                        [weakSelf.navigationController popViewControllerAnimated:YES];
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
    
    NSArray *subviews = [self.view subviews];
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

- (void)animateLeftWithView:(UIView *)view
{
    
}

- (void)animateRightWithView:(UIView *)view
{
    
}

- (void)setViewToCenter:(UIView *)view
{
    view.center = self.view.center;
}

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
