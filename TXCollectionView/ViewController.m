//
//  ViewController.m
//  TXCollectionView
//
//  Created by taixiangwang on 15/5/21.
//  Copyright (c) 2015年 charles_wtx. All rights reserved.
//

#import "ViewController.h"
#import "LabelCollectionViewCell.h"
#import "CollectViewLayout.h"

#import "ClickImage.h"

@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegate,CollectViewLayoutDelegate>
@property (nonatomic, strong) NSMutableArray *labels;

@property (nonatomic,strong) NSMutableArray *cellArr;
@property (nonatomic) int cellIndex;
@property (nonatomic) BOOL isStopScroll;//监听scroll停止滑动

@property (weak, nonatomic) IBOutlet UIImageView *bigImgView;

@end

@implementation ViewController{
    UICollectionView *collectView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //bigImgView
    self.bigImgView.canClick = YES;
    
    self.cellIndex = 1;
    self.cellArr = [[NSMutableArray alloc]init];
    
    UIView *circleView = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-25, 100, 50, 50)];
    circleView.backgroundColor = [UIColor clearColor];
    circleView.layer.cornerRadius = 25;
    circleView.layer.borderWidth = 2;
    circleView.layer.borderColor = [UIColor grayColor].CGColor;
    [self.view addSubview:circleView];
    
    CGRect rect = CGRectMake(0, 100, self.view.frame.size.width, 50);
    CollectViewLayout *qhlayout = [[CollectViewLayout alloc]init];
    qhlayout.delegate = self;
    collectView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:qhlayout];
    
    collectView.backgroundColor = [UIColor clearColor];
    collectView.dataSource = self;
    collectView.delegate = self;
    //xib
    [collectView registerNib:[UINib nibWithNibName:@"LabelCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:ID];
    collectView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:collectView];
    
    
}
#pragma mark - qhlinedelegate

-(void)getCellIndex:(int)cellIndex{
    NSLog(@"选择了月份。。%d",cellIndex);
    
    self.cellIndex = cellIndex;
    [collectView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)labels
{
    if (_labels == nil) {
        self.labels = [NSMutableArray array];
        
        for (int i = 1; i <= 12*10; i++) {
            [self.labels addObject:[NSString stringWithFormat:@"%d", i]];
        }
    }
    
    return _labels;
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.labels.count;
}
static NSString *const ID = @"cell";
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LabelCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.tag = indexPath.row + 100;
    cell.numberLabel.text = self.labels[indexPath.row];
    cell.numberLabel.textColor = [UIColor blackColor];
    if (!self.isStopScroll) {
        if (indexPath.row == 0) {
            cell.numberLabel.textColor = [UIColor redColor];
        }
    }
    else{
        cell.numberLabel.textColor = [UIColor blackColor];
    }
    
    
    return cell;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.isStopScroll = YES;
    
    LabelCollectionViewCell *cell = (LabelCollectionViewCell *)[scrollView viewWithTag:self.cellIndex-1+100];
    
    cell.numberLabel.textColor = [UIColor redColor];
}

@end
