//
//  XZRotationPictureCell.h
//  XZPictureCycleScrollView
//
//  Created by msy on 16/11/23.
//  Copyright © 2016年 ZhouZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XZRotationPictureCell : UICollectionViewCell

// 选择图片类型后，这两者只用传一个值即可
@property (nonatomic,copy)NSString *imageName;// 本地图片，加载图片名称
@property (nonatomic,copy)NSString *imageUrl;// 网络图片，加载url
@end
