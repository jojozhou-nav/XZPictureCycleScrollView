//
//  XZViewController.m
//  XZPictureCycleScrollView
//
//  Created by msy on 16/11/23.
//  Copyright © 2016年 ZhouZ. All rights reserved.
//

#import "XZViewController.h"
#import "XZRotationPictureView.h"
#import "UIView+XZExtension.h"

@interface XZViewController ()

@end

@implementation XZViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    XZRotationPictureView *rotationView1 = [[XZRotationPictureView alloc] initWithFrame:CGRectMake(0, 50, self.view.xz_width, 250)];
    rotationView1.imageStyle = XZRotationPictureViewImageStyleLocal;
    rotationView1.imageArray = @[@"1.jpg",@"2.jpg",@"3.jpeg",@"4.jpg",@"5.jpg",@"6.jpg"];
    rotationView1.pageControlPosion = XZPageControlPositionRight;
    [self.view addSubview:rotationView1];
    
    
    
//    XZRotationPictureView *rotationView2 = [[XZRotationPictureView alloc] initWithFrame:CGRectMake(0, 10, self.view.xz_width, 250)];
//    rotationView2.imageStyle = XZRotationPictureViewImageStyleUrl;
//    // 加载url资源
//    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"InternetImageUrl" ofType:@"plist"];
//    NSMutableArray *data = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
//    rotationView2.imageArray = data;
//    [self.view addSubview:rotationView2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
