//
//  CollectViewLayout.h
//  TXCollectionView
//
//  Created by taixiangwang on 15/5/21.
//  Copyright (c) 2015年 charles_wtx. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CollectViewLayout;
@protocol CollectViewLayoutDelegate <NSObject>

-(void)getCellIndex:(int)cellIndex;

@end

@interface CollectViewLayout : UICollectionViewFlowLayout


@property (nonatomic,assign) id<CollectViewLayoutDelegate>delegate;
@end
