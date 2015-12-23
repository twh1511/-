//
//  TRBaseCollectionViewController.m
//  TRSearchDeals
//
//  Created by tarena on 15/11/25.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "TRBaseCollectionViewController.h"
#import "UIBarButtonItem+TRBarItem.h"
#import "TRNavLeftView.h"
#import "TRSortViewController.h"
#import "TRRegionViewController.h"
#import "TRCategoryViewController.h"
#import "TRCategory.h"
#import "TRRegion.h"
#import "TRSort.h"
#import "DPAPI.h"
#import "TRDeal.h"
#import "TRCollectionViewCell.h"
#import "UIScrollView+BottomRefreshControl.h"
#import "TRMetaDataTool.h"

@interface TRBaseCollectionViewController ()<DPRequestDelegate>
//服务器返回所有的订单数据
@property (nonatomic, strong) NSMutableArray *dealsArray;
//发送给服务器的page参数
@property (nonatomic, assign) int page;

@end

@implementation TRBaseCollectionViewController

static NSString * const reuseIdentifier = @"deal";

- (NSMutableArray *)dealsArray {
    if (!_dealsArray) {
        _dealsArray = [NSMutableArray array];
    }
    return _dealsArray;
}

- (id)init {
    //创建流水布局对象
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    //设置流水布局的itemSize大小
    layout.itemSize = CGSizeMake(305, 305);
    //设置item距离上下左右的边距
    layout.sectionInset = UIEdgeInsetsMake(15, 15, 15, 15);
    return [self initWithCollectionViewLayout:layout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    //设置主视图控制器的view背景为白色
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    // Register cell classes
    [self.collectionView registerNib:[UINib nibWithNibName:@"TRCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
    
    //创建刷新控件
    [self setupRefreshControl];
}

#pragma mark --- 创建刷新控件
- (void)setupRefreshControl {
    //创建UIRefreshControl对象
    UIRefreshControl *refreshControl = [UIRefreshControl new];
    //设置属性(文本; 垂直方向的偏移量)
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"正在等待加载更多订单..."];
    refreshControl.triggerVerticalOffset = 100;
    [refreshControl addTarget:self action:@selector(loadMoreDeals) forControlEvents:UIControlEventValueChanged];
    //加载到view上
    self.collectionView.bottomRefreshControl = refreshControl;
    
}

#pragma mark --- 加载团购订单
//加载更多团购
- (void)loadMoreDeals {
    self.page++;
    //再发送请求
    [self sendRequestToServer];
    
}
//加载新的团购(第一次)
- (void)loadNewDeals {
    self.page = 1;
    //再发送请求
    [self sendRequestToServer];
    
}
//发送请求给服务器
- (void)sendRequestToServer {
    //创建DPAPI对象
    DPAPI *api = [DPAPI new];
    //设置发送参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //调用子类实现方法(设置发送请求的参数)
    [self settingParams:params];
    
    //设置
    params[@"page"] = @(self.page);
    
    NSLog(@"发送参数:%@", params);
    
    //发送请求
    [api requestWithURL:@"v1/deal/find_deals" params:params delegate:self];
}

- (void)request:(DPRequest *)request didFinishLoadingWithResult:(id)result {
    NSLog(@"发送成功:%@", result);
    NSArray *dealsArray = [TRMetaDataTool parseResultFromServer:result];
//    NSArray *array = result[@"deals"];
//    
//    //返回已经转换成TRDeal模型对象的数组
//    NSArray *dealsArray = [self parseDealsWithArray:array];
    
    //情况一:没有上拉加载(新请求)
    if (self.page == 1) {
        [self.dealsArray removeAllObjects];
    }
    //将服务器返回的20条新的数组dealsArray加到self.dealsArray
    [self.dealsArray addObjectsFromArray:dealsArray];
    //刷新数据
    [self.collectionView reloadData];
    //停止动画
    [self.collectionView.bottomRefreshControl endRefreshing];
}

- (NSArray *)parseDealsWithArray:(NSArray *)array {
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *dealDic in array) {
        TRDeal *deal = [TRDeal new];
        [deal setValuesForKeysWithDictionary:dealDic];
        [mutableArray addObject:deal];
    }
    return [mutableArray copy];
}

- (void)request:(DPRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"发送失败:%@", error.userInfo);
    //停止动画
    [self.collectionView.bottomRefreshControl endRefreshing];
    
}

















- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //没有设定limit参数, 服务器默认返回20条
    return self.dealsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TRCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    //cell这个item的数据来源
    TRDeal *deal = self.dealsArray[indexPath.row];
    cell.deal = deal;
    
    return cell;
}


#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
