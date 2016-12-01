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

@interface XZRotationPictureView ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    CGPoint beginOffset;
}

@property (nonatomic,weak)UICollectionView *mainView;
@property (nonatomic, weak) UICollectionViewFlowLayout *layout;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, weak) StyledPageControl *pageControl;
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, assign) NSInteger realIndexItem;
@end

@implementation XZRotationPictureView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setDefaultData];
        [self creatScrollView];
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
    return self.unlimitedLoop? self.imageArray.count+1 : self.imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *realIndexPath = indexPath;
    if (indexPath.row == self.totalCount) { // 在最后一个后面添加第一个cell
        realIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
    }
    NSLog(@"--realIndexPath.item----%ld",(long)realIndexPath.item);

    _realIndexItem = realIndexPath.item;
    
    XZRotationPictureCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:realIndexPath];
//    long itemIndex = [self pageIndexWithCurrentCellIndex:indexPath.item];
    if (self.imageStyle == XZRotationPictureViewImageStyleUrl) {
        cell.imageUrl = self.imageArray[realIndexPath.item];
    }else{
        cell.imageName = self.imageArray[realIndexPath.item];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *realIndexPath = indexPath;
    if (indexPath.row == self.totalCount) { // 在最后一个后面添加第一个cell
        realIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
    }
    if (self.clickItemOperationBlock) {
        self.clickItemOperationBlock(realIndexPath.item);
    }
}


#pragma mark - 图片数组
// 图片数组
- (void)setImageArray:(NSArray *)imageArray
{
    _imageArray = imageArray;
    
    _totalCount =  imageArray.count;
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
// 当前的页数
- (int)currentPageIndex
{
    int index = (_mainView.contentOffset.x + _layout.itemSize.width) / _layout.itemSize.width;
    return MAX(0, index);
}
// 当前的cell对应数组中的第几张图
- (int)pageIndexWithCurrentCellIndex:(NSInteger)index
{
    return (int)index % self.imageArray.count;
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        CGFloat offsetX = scrollView.contentOffset.x;
        
        //向左滑
        if (offsetX >= scrollView.contentSize.width - scrollView.bounds.size.width) { // 滚动到最后一页
            // 重置滚动开始的偏移量
            beginOffset.x = 0;
            offsetX = beginOffset.x;
            // 设置滚动到第一页
            [scrollView setContentOffset:CGPointMake(beginOffset.x, 0.f) animated:NO];
            
        }
        
        // 向右滑
        if (offsetX < 0) {// 滚动到第一页
            // 重置滚动开始的偏移量
            beginOffset.x = scrollView.contentSize.width-scrollView.bounds.size.width;
            offsetX = beginOffset.x;
            // 设置滚动到最后一页
            [scrollView setContentOffset:CGPointMake(beginOffset.x, 0.f) animated:NO];
            
        }
        
        NSInteger tempIndex = offsetX/scrollView.bounds.size.width + 0.5;
        if (tempIndex >= self.totalCount) {
            tempIndex = 0;
        }
        if (tempIndex != [self currentPageIndex]) {
            _pageControl.currentPage = tempIndex;
        }
//
//    }
//    else {
//        CGFloat offsetY = scrollView.contentOffset.y;
//        //向上滑
//        if (offsetY > scrollView.contentSize.height - scrollView.bounds.size.height) { // 滚动到最后一页
//            beginOffset.y = 0;
//            offsetY = beginOffset.y;
//            [scrollView setContentOffset:CGPointMake(0.f, beginOffset.y) animated:NO];
//            
//        }
//        
//        // 向下滑
//        if (offsetY < 0) {// 滚动到第一页
//            beginOffset.y = scrollView.contentSize.height-scrollView.bounds.size.height;
//            offsetY = beginOffset.y;
//            [scrollView setContentOffset:CGPointMake(0.f, beginOffset.y) animated:NO];
//            
//        }
//        
//        NSInteger tempIndex = offsetY/scrollView.bounds.size.height + 0.5;
//        if (tempIndex >= _pages) {
//            tempIndex = 0;
//        }
//        if (tempIndex != _currentPage) {
//            self.currentPage = tempIndex;
//        }
//        
//    }

    
    
//    int indexOnPageControl = [self pageIndexWithCurrentCellIndex:[self currentPageIndex]];
//    _pageControl.currentPage = indexOnPageControl;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    beginOffset = scrollView.contentOffset;

    [self invalidateTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self setTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:self.mainView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
//    int itemIndex = (_mainView.contentOffset.x + _layout.itemSize.width * 0.5) / _layout.itemSize.width;
//    int indexOnPageControl = itemIndex%self.imageArray.count;
    
    if (self.itemDidScrollOperationBlock) {
        self.itemDidScrollOperationBlock(_realIndexItem);
    }
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
    
    [self.mainView setContentOffset:CGPointMake(self.mainView.contentOffset.x + self.mainView.bounds.size.width, 0.f) animated:YES];
    
//    int currentIndex = [self currentPageIndex];// 当前页数
//    int targetIndex = currentIndex + 1;// 目标页数
//    if (targetIndex == _totalCount) {
//        if (self.unlimitedLoop) {// 如果需要无线轮播，进行下面的方法
////            targetIndex = _totalCount * 0.5;
//            targetIndex = 0;
//            [self.mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
//        }
//        return;
//    }
//    [self.mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
//    
//    // 控制选中的pageControl
//    _pageControl.currentPage = [self pageIndexWithCurrentCellIndex:currentIndex];
    
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
        [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    
}

@end
