//
//  XZRotationPictureCell.m
//  XZPictureCycleScrollView
//
//  Created by msy on 16/11/23.
//  Copyright © 2016年 ZhouZ. All rights reserved.
//

#import "XZRotationPictureCell.h"
#import "UIView+XZExtension.h"
#import "UIImageView+WebCache.h"

@interface XZRotationPictureCell ()
@property (nonatomic,weak) UIImageView *imageView;
@end

@implementation XZRotationPictureCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setScrollImageView];
    }
    return self;
}

- (void)setScrollImageView
{
    UIImageView *img = [[UIImageView alloc] init];
    img.frame = CGRectMake(0, 0, self.xz_width, self.xz_height);
    img.backgroundColor = [UIColor redColor];
    [self addSubview:img];
    // 让图片不变形，自适应大小
    img.contentMode = UIViewContentModeScaleAspectFill;
    img.clipsToBounds = YES;
    self.imageView = img;
}

- (void)setImageName:(NSString *)imageName
{
    _imageName = imageName;
    self.imageView.image = [UIImage imageNamed:imageName];
}


- (void)setImageUrl:(NSString *)imageUrl
{
    _imageUrl = imageUrl;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"placeImage"]];
}

@end
