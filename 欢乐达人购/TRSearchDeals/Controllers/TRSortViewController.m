//
//  TRSortViewController.m
//  TRSearchDeals
//
//  Created by tarena on 15/11/23.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "TRSortViewController.h"
#import "TRMetaDataTool.h"
#import "TRSort.h"

@interface TRSortViewController ()

@end

@implementation TRSortViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //设定三个常量
    CGFloat buttonHeight = 30;
    CGFloat buttonWidth  = 100;
    CGFloat buttonMargin = 15;
    
    //数据来源
    NSArray *sortsArray = [TRMetaDataTool sorts];
    
    for (int i = 0; i < sortsArray.count; i++) {
        //创建按钮
        UIButton *button = [UIButton new];
        button.frame = CGRectMake(buttonMargin, i * (buttonHeight + buttonMargin) + buttonMargin, buttonWidth, buttonHeight);
        //设置两个背景图片
        [button setBackgroundImage:[UIImage imageNamed:@"btn_filter_normal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"btn_filter_selected"] forState:UIControlStateHighlighted];
        //设定button的title
        TRSort *sort = sortsArray[i];
        [button setTitle:sort.label forState:UIControlStateNormal];
        //设置button文本颜色
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        //将循环次数设置给button的标签tag
        button.tag = i;
        //添加action
        [button addTarget:self action:@selector(clickSortButton:) forControlEvents:UIControlEventTouchUpInside];
        //添加到view
        [self.view addSubview:button];
    }
    //设定视图控制器contentSize
    self.preferredContentSize = CGSizeMake(2*buttonMargin+buttonWidth, sortsArray.count*(buttonHeight+buttonMargin)+buttonMargin);
}

- (void)clickSortButton:(UIButton *)button {
    //发送通知(带参数:排序模型对象)
    TRSort *sort = [TRMetaDataTool sorts][button.tag];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TRSortChange" object:self userInfo:@{@"TRSelectedSort":sort}];
    //收回弹出控制器
    [self dismissViewControllerAnimated:YES completion:nil];
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

@end
