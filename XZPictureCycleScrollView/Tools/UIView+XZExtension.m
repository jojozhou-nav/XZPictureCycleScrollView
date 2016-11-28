//
//  UIView+XZExtension.m
//  XZPictureCycleScrollView
//
//  Created by msy on 16/11/23.
//  Copyright © 2016年 ZhouZ. All rights reserved.
//

#import "UIView+XZExtension.h"

@implementation UIView (XZExtension)

- (CGFloat)xz_width
{
    return self.frame.size.width;
}
- (void)setXz_width:(CGFloat)xz_width
{
    CGRect tempF = self.frame;
    tempF.size.width = xz_width;
    self.frame = tempF;
}



- (CGFloat)xz_height
{
    return self.frame.size.height;
}
- (void)setXz_height:(CGFloat)xz_height
{
    CGRect tempF = self.frame;
    tempF.size.height = xz_height;
    self.frame = tempF;
}


- (CGFloat)xz_x
{
    return self.frame.origin.x;
}
- (void)setXz_x:(CGFloat)xz_x
{
    CGRect tempF = self.frame;
    tempF.origin.x = xz_x;
    self.frame = tempF;
}


- (CGFloat)xz_y
{
    return self.frame.origin.y;
}
- (void)setXz_y:(CGFloat)xz_y
{
    CGRect tempF = self.frame;
    tempF.origin.y = xz_y;
    self.frame = tempF;
}

@end
