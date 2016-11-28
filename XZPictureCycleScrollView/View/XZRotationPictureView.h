//
//  XZRotationPictureView.h
//  XZPictureCycleScrollView
//
//  Created by msy on 16/11/23.
//  Copyright © 2016年 ZhouZ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, XZRotationPictureViewImageStyle) {
    XZRotationPictureViewImageStyleUrl,          // 网络图片
    XZRotationPictureViewImageStyleLocal         // 本地图片
};


typedef NS_ENUM(NSInteger, XZPageControlPosition) {
    XZPageControlPositionLeft,// 左侧
    XZPageControlPositionCenter,// 中间
    XZPageControlPositionRight// 右侧
};

@interface XZRotationPictureView : UIView

/**
 加载的图片类型，网络图片/本地图片
 */
@property (nonatomic) XZRotationPictureViewImageStyle imageStyle;

/**
 需要展示的图片
 */
@property (nonatomic,strong) NSArray *imageArray;

/**
 是否无限循环，默认为yes
 */
@property (nonatomic,assign) BOOL unlimitedLoop;

/**
 自动滚动间隔时间,默认2s
 */
@property (nonatomic, assign) CGFloat autoScrollTimeInterval;

/**
 pageControl的位置,默认为正中间
 */
@property (nonatomic) XZPageControlPosition pageControlPosion;

@end
