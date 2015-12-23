//
//  TRRegionViewController.m
//  TRSearchDeals
//
//  Created by tarena on 15/11/23.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "TRRegionViewController.h"
#import "TRMetaDataTool.h"
#import "TRRegion.h"
#import "TRTableViewCell.h"
#import "TRCityViewController.h"

@interface TRRegionViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UITableView *subTableView;
@property (nonatomic, strong) NSArray *regionsArray;

@end

@implementation TRRegionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //监听"城市改变"通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cityDidChange:) name:@"TRCityChange" object:nil];
}

- (void)cityDidChange:(NSNotification *)notification {
    NSString *cityName = notification.userInfo[@"TRSelectedCityName"];
    self.regionsArray = [TRMetaDataTool regionsByCityName:cityName];
    //刷新tableView
    [self.mainTableView reloadData];
    [self.subTableView reloadData];
    
}

- (IBAction)changeCity:(id)sender {
    //创建城市控制器对象
    TRCityViewController *cityViewController = [TRCityViewController new];
    //设置弹出类型
    cityViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    //显示出来
    [self presentViewController:cityViewController animated:YES completion:nil];
}

#pragma mark --- tableViewDataSourceDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.mainTableView) {
        //左边
        return self.regionsArray.count;
    } else {
        //右边
        //获取用户选择左边的那行的行号
        NSInteger selectedRow = [self.mainTableView indexPathForSelectedRow].row;
         TRRegion *region = self.regionsArray[selectedRow];
        return region.subregions.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //重用机制
    //设置cell属性
    if (tableView == self.mainTableView) {
        TRTableViewCell *cell = [TRTableViewCell cellWithTableView:tableView withImageName:@"bg_dropdown_leftpart" withSelectedImageName:@"bg_dropdown_left_selected"];
        //设置cell文本
        //V2:
        cell.region = self.regionsArray[indexPath.row];
        return cell;
    } else {
        TRTableViewCell *cell = [TRTableViewCell cellWithTableView:tableView withImageName:@"bg_dropdown_rightpart" withSelectedImageName:@"bg_dropdown_right_selected"];
        //设置右边cell的文本(子区域)
        NSInteger selectedRow = [self.mainTableView indexPathForSelectedRow].row;
        TRRegion *region = self.regionsArray[selectedRow];
        cell.textLabel.text = region.subregions[indexPath.row];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.mainTableView) {
        [self.subTableView reloadData];
        //情况一:没有子区域, 立即发送通知
        //获取该行的主区域对象
        TRRegion *region = self.regionsArray[indexPath.row];
        if (region.subregions.count == 0) {
            //发送通知(带参数:TRRegion)
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TRRegionChange" object:self userInfo:@{@"TRSelectedRegion":region}];
            //收回弹出控制器
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } else {
        //情况二:有子区域;发送通知(带参数:region;subRegionName)
        //获取左边和右边选中行号
        NSInteger leftSelectedRow = [self.mainTableView indexPathForSelectedRow].row;
        NSInteger rightSelectedRow = [self.subTableView indexPathForSelectedRow].row;
        //左边区域模型对象
        TRRegion *region = self.regionsArray[leftSelectedRow];
        //右边子区域的名字
        NSString *subRegionName = region.subregions[rightSelectedRow];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TRRegionChange" object:self userInfo:@{@"TRSelectedRegion":region, @"TRSelectedSubRegionName":subRegionName}];
        //收回弹出控制器
        [self dismissViewControllerAnimated:YES completion:nil];
    }
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
