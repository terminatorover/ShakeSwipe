//
//  AnimCheckViewController.m
//  ShakeSwipe
//
//  Created by ROBERA GELETA on 3/24/15.
//  Copyright (c) 2015 ROBERA GELETA. All rights reserved.
//

#import "AnimCheckViewController.h"
#import <Masonry/Masonry.h>


static const CGFloat kTime = 1.2;
static const CGFloat kWitdh = 0.7;
static const CGFloat kInitalSpringSpeed = 0;
@interface AnimCheckViewController ()

@end

@implementation AnimCheckViewController
{
    UIView *_subview;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _subview = [[UIView alloc]initWithFrame:CGRectZero];
    _subview.backgroundColor = [UIColor colorWithRed:0.15 green:0.68 blue:0.38 alpha:1];
    [self.view addSubview:_subview];
    

    UIView *supview = self.view;
    [_subview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(supview.mas_centerX);
        make.centerY.equalTo(supview.mas_centerY);
        make.width.equalTo(supview.mas_width).with.multipliedBy(.7);
        make.height.equalTo(supview.mas_height).with.multipliedBy(.5);
    }];
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)animateLeftWithView:(UIView *)view
{
    NSLog(@"Move Left");
    [self setViewToLeft:view];
    [UIView animateWithDuration:kTime
                          delay:0
         usingSpringWithDamping:kWitdh
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

- (void)setViewToCenter:(UIView *)view
{
    UIView *superview = self.view;
    view.layer.transform = CATransform3DIdentity;
    

    
    [view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(superview.mas_width).with.multipliedBy(kWitdh);
        make.height.equalTo(superview.mas_height).with.multipliedBy(kWitdh);
        make.centerX.equalTo(superview.mas_centerX);
        make.centerY.equalTo(superview.mas_centerY);
        
    }];

}
- (IBAction)animateAgain:(id)sender {
     [self animateLeftWithView:_subview];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
