//
//  RGView.m
//  ShakeSwipe
//
//  Created by ROBERA GELETA on 3/24/15.
//  Copyright (c) 2015 ROBERA GELETA. All rights reserved.
//

#import "RGView.h"
#import <Masonry/Masonry.h>
@implementation RGView
{
    UIVisualEffectView *_effectView;
    UIImageView *_imageView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        UIBlurEffect *blureffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        _effectView  = [[UIVisualEffectView alloc]initWithEffect:blureffect];
        _effectView.frame = self.bounds;
        _imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        _imageView.image = [UIImage imageNamed:@"i4"];
        
        [self addSubview:_imageView];
        [self addSubview:_effectView];
        [self setupLayoutConstraints];
    }
    return self;
}


- (void)setupLayoutConstraints
{
    UIEdgeInsets padding = UIEdgeInsetsMake(0,0,0,0);
    UIView *superview = self;
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview.mas_top).with.offset(padding.top); //with is an optional semantic filler
        make.left.equalTo(superview.mas_left).with.offset(padding.left);
        make.bottom.equalTo(superview.mas_bottom).with.offset(-padding.bottom);
        make.right.equalTo(superview.mas_right).with.offset(-padding.right);
    }];
    
    [_effectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superview.mas_top).with.offset(padding.top); //with is an optional semantic filler
        make.left.equalTo(superview.mas_left).with.offset(padding.left);
        make.bottom.equalTo(superview.mas_bottom).with.offset(-padding.bottom);
        make.right.equalTo(superview.mas_right).with.offset(-padding.right);
    }];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
