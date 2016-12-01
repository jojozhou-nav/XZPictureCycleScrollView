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
@property (nonatomic,weak)UIWebView *webView;
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
    
    // 设定位置和大小
    CGRect frame = CGRectMake(0,0,self.xz_width,self.xz_height);
    UIWebView *webView = [[UIWebView alloc] initWithFrame:frame];
    webView.userInteractionEnabled = NO;//用户不可交互
    [self addSubview:webView];
    _webView = webView;
}

- (void)setImageName:(NSString *)imageName
{
    _imageName = imageName;
    
    
    if ([imageName hasSuffix:@"gif"]) {
        _imageView.hidden = YES;
        _webView.hidden = NO;
        
//        frame.size = [UIImage imageNamed:@"play.gif"].size;
        // 读取gif图片数据
        NSData *gif = [NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:imageName ofType:nil]];
        // view生成
        [_webView loadData:gif MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
       
    }else{
        _imageView.hidden = NO;
        _webView.hidden = YES;
        
        self.imageView.image = [UIImage imageNamed:imageName];
    }
}


- (void)setImageUrl:(NSString *)imageUrl
{
    _imageUrl = imageUrl;
    _imageView.hidden = NO;
    _webView.hidden = YES;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"placeImage"]];
}

@end
