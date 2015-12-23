//
//  TRSearchViewController.m
//  TRSearchDeals
//
//  Created by tarena on 15/11/25.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "TRSearchViewController.h"
#import "UIBarButtonItem+TRBarItem.h"

@interface TRSearchViewController ()<UISearchBarDelegate>

@end

@implementation TRSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加返回item
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"icon_back" withHighlightedImageName:@"icon_back_highlighted" withTarget:self withAction:@selector(clickBackItem)];
    //添加searchBar
    UISearchBar *searchBar = [UISearchBar new];
    searchBar.placeholder = @"请输入搜索关键词";
    searchBar.delegate = self;
    self.navigationItem.titleView = searchBar;
}

- (void)clickBackItem {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --- SearchDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    //发送请求
    [self loadNewDeals];
    //键盘收回去
    [searchBar resignFirstResponder];
}

//实现父类提供设置参数的方法
- (void)settingParams:(NSMutableDictionary *)params {
    //city
    params[@"city"] = self.cityName;
    //获取searchBar
    UISearchBar *bar = (UISearchBar *)self.navigationItem.titleView;
    //keyword
    params[@"keyword"] = bar.text;
}








/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
