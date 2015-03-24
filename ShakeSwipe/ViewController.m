
//  ViewController.m
//  ShakeSwipe
//
//  Created by ROBERA GELETA on 3/24/15.
//  Copyright (c) 2015 ROBERA GELETA. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>
@interface ViewController ()
@property (nonatomic) CMMotionManager *motionManager;
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
@end
