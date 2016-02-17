//
//  CollectViewLayout.m
//  TXCollectionView
//
//  Created by taixiangwang on 15/5/21.
//  Copyright (c) 2015年 charles_wtx. All rights reserved.
//

#import "CollectViewLayout.h"

@implementation CollectViewLayout

static const CGFloat ItemHW = 40;

- (instancetype)init
{
    if (self = [super init]) {
    }
    
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];
    self.itemSize = CGSizeMake(ItemHW, ItemHW);
    CGFloat inset = (self.collectionView.frame.size.width - ItemHW) * 0.5;
    self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset);
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.minimumLineSpacing = 5;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;// 时刻调用,重新布局
}

/**
 *  用来设置停止滚动那一刻的位置
 *
 *  @param proposedContentOffset 原本位置
 *  @param velocity              速度（正负）
 *
 */
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    // 1.计算出scrollView最后会停留的范围
    CGRect lastRect;
    lastRect.origin = proposedContentOffset;
    lastRect.size = self.collectionView.frame.size;
    
    // 计算屏幕最中间的x
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width * 0.5;
    
    
    // 2.取出这个范围内的所有属性
    NSArray *array = [self layoutAttributesForElementsInRect:lastRect];
    
    // 3.遍历所有属性
    CGFloat adjustOffsetX = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attrs in array) {
        if (ABS(attrs.center.x - centerX) < ABS(adjustOffsetX)) {
            adjustOffsetX = attrs.center.x - centerX;
            
        }
    }
    
    CGFloat cellXXX = proposedContentOffset.x + adjustOffsetX;
    
    [self getCellOrginx:cellXXX];
    return CGPointMake(proposedContentOffset.x + adjustOffsetX, proposedContentOffset.y);
}
//判断frame到哪里了 来知道是哪个cell

-(void)getCellOrginx:(CGFloat)offsetX{
    
    NSLog(@"offsetX %f",offsetX);
    
    int monsIndex = 0;
    monsIndex =(int)offsetX/45+1;
    NSLog(@"monsIndex %d",monsIndex);
    if ([self.delegate respondsToSelector:@selector(getCellIndex:)]) {
        [self.delegate getCellIndex:monsIndex];
    }
}
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    // 0.计算可见的矩形框
    CGRect visiableRect;
    visiableRect.size = self.collectionView.frame.size;
    visiableRect.origin = self.collectionView.contentOffset;
    
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    // 计算屏幕中央的x
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width * 0.5;
    
    //    NSLog(@"ceX ===  %f",centerX);
    for (UICollectionViewLayoutAttributes *attrs in array) {
        // 如果不在屏幕上,直接跳过
        if (!CGRectIntersectsRect(visiableRect, attrs.frame)) continue;
        
        // 每一个item的中点x
        CGFloat itemCenterX = attrs.center.x;
        CGFloat scale = 1 + 0.2 * (1 - (ABS(itemCenterX - centerX) / 150));
        attrs.transform = CGAffineTransformMakeScale(scale, scale);
        // 透明调节
        attrs.alpha = 0.4 + 0.4 * (1 - (ABS(itemCenterX - centerX) / 150));
        
        
    }
    
    return array;
}

@end
