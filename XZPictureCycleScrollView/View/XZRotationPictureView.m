//
//  XZRotationPictureView.m
//  XZPictureCycleScrollView
//
//  Created by msy on 16/11/23.
//  Copyright © 2016年 ZhouZ. All rights reserved.
//

#import "XZRotationPictureView.h"
#import "XZRotationPictureCell.h"
#import "UIView+XZExtension.h"
#import "StyledPageControl.h"

#define kCellIdentifier @"XZRotationPictureCell"

@interface XZRotationPictureView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,weak)UICollectionView *mainView;
@property (nonatomic, weak) UICollectionViewFlowLayout *layout;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, weak) StyledPageControl *pageControl;
@property (nonatomic, weak) NSTimer *timer;
@end

@implementation XZRotationPictureView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self creatScrollView];
        [self setDefaultData];
    }
    return self;
}

#pragma mark - 设置常量
// 设置常量
- (void)setDefaultData
{
    self.unlimitedLoop = YES;
    self.pageControlPosion = XZPageControlPositionCenter;
    self.autoScrollTimeInterval = 2.0;
}


#pragma mark - 创建基本控件
- (void)setPageControl
{
    StyledPageControl *pageControl = [[StyledPageControl alloc] init];
    pageControl.numberOfPages = self.imageArray.count;
    [pageControl setPageControlStyle:PageControlStyleDefault];
    pageControl.userInteractionEnabled = NO;
    [pageControl setCoreSelectedColor:[UIColor yellowColor]];;
    [pageControl setCoreNormalColor:[UIColor redColor]];
    pageControl.currentPage = 0;
    [self addSubview:pageControl];
    _pageControl = pageControl;
    NSInteger controlW = [self pageControlWidth];
    [pageControl setFrame:CGRectMake((self.xz_width - controlW)/2,self.frame.size.height-20,controlW,20)];
    
}

- (void)creatScrollView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = self.frame.size;
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _layout = layout;
    
    UICollectionView *mainView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.xz_width, self.xz_height) collectionViewLayout:layout];
    mainView.backgroundColor = [UIColor lightGrayColor];
    mainView.pagingEnabled = YES;
    mainView.showsHorizontalScrollIndicator = NO;
    mainView.showsVerticalScrollIndicator = NO;
    [mainView registerClass:[XZRotationPictureCell class] forCellWithReuseIdentifier:kCellIdentifier];
    mainView.dataSource = self;
    mainView.delegate = self;
    [self addSubview:mainView];
    _mainView = mainView;
    
}


#pragma mark - UICollectionView代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.totalCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XZRotationPictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    long itemIndex = indexPath.item % self.imageArray.count;

    if (self.imageStyle == XZRotationPictureViewImageStyleUrl) {
        cell.imageUrl = self.imageArray[itemIndex];
    }else{
        cell.imageName = self.imageArray[itemIndex];
    }
    return cell;
}

#pragma mark - 图片数组
// 图片数组
- (void)setImageArray:(NSArray *)imageArray
{
    _imageArray = imageArray;
    
    _totalCount =  self.unlimitedLoop? imageArray.count*500:imageArray.count;
    [self setTimer];
    
    [self setPageControl];
    
}

#pragma mark - 指示器参数
// 指示器的宽度
- (NSInteger) pageControlWidth
{
    return [_pageControl sizeForNumberOfAllPages:self.imageArray.count].width;
}



// 设置指示器的位置
- (void)setPageControlPosion:(XZPageControlPosition)pageControlPosion
{
    _pageControlPosion = pageControlPosion;
    
    NSInteger controlW = [self pageControlWidth];
    
    switch (pageControlPosion) {
        case XZPageControlPositionLeft:
            [_pageControl setFrame:CGRectMake(0,self.frame.size.height-20,controlW,20)];
            break;
        case XZPageControlPositionCenter:
            [_pageControl setFrame:CGRectMake((self.xz_width - controlW)/2,self.frame.size.height-20,controlW,20)];
            break;
        case XZPageControlPositionRight:
            [_pageControl setFrame:CGRectMake(self.xz_width - controlW,self.frame.size.height-20,controlW,20)];
            break;
        default:
            break;
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int currentIndex = (_mainView.contentOffset.x + _layout.itemSize.width * 0.5) / _layout.itemSize.width;// 当前页数
    int indexOnPageControl = currentIndex % self.imageArray.count;
    _pageControl.currentPage = indexOnPageControl;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self invalidateTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self setTimer];
}


#pragma mark - 时间参数

- (void)setAutoScrollTimeInterval:(CGFloat)autoScrollTimeInterval
{
    _autoScrollTimeInterval = autoScrollTimeInterval;
}


// 创建timer
- (void)setTimer
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTimeInterval target:self selector:@selector(autoScrollImage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    _timer = timer;
}

- (void)invalidateTimer
{
    [_timer invalidate];
    _timer = nil;
}

#pragma mark - 轮播参数
// 自动滚动
- (void)autoScrollImage
{
    int currentIndex = (_mainView.contentOffset.x + _layout.itemSize.width * 0.5) / _layout.itemSize.width;// 当前页数
    int targetIndex = currentIndex + 1;// 目标页数
    if (targetIndex == _totalCount) {
        if (self.unlimitedLoop) {// 如果需要无线轮播，进行下面的方法
            targetIndex = _totalCount * 0.5;
            [self.mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        }
        return;
    }
     [self.mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];

    // 控制选中的pageControl
    int indexOnPageControl = currentIndex % self.imageArray.count;
    _pageControl.currentPage = indexOnPageControl;

}

// 是否循环滚动
- (void)setUnlimitedLoop:(BOOL)unlimitedLoop
{
    _unlimitedLoop = unlimitedLoop;
}

#pragma mark - 初始化控件
// 初始化控件
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _mainView.frame = self.bounds;
    if (_mainView.contentOffset.x == 0) {
        [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_totalCount * 0.5 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    
}

@end
