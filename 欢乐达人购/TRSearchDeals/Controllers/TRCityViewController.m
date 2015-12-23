//
//  TRCityViewController.m
//  TRSearchDeals
//
//  Created by tarena on 15/11/24.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "TRCityViewController.h"
#import "TRMetaDataTool.h"
#import "TRCityGroup.h"

@interface TRCityViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *cityGroupsArray;

@end

@implementation TRCityViewController
- (NSArray *)cityGroupsArray {
    if (!_cityGroupsArray) {
        _cityGroupsArray = [TRMetaDataTool cityGroups];
    }
    return _cityGroupsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (IBAction)closeCityList:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark --- TableViewDataSourceDelegate
//self.cityGroupsArray下标 ---> section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cityGroupsArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    TRCityGroup *cityGroup = self.cityGroupsArray[section];
    return cityGroup.cities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    //设置cell的textLabel的文本
    TRCityGroup *cityGroup = self.cityGroupsArray[indexPath.section];
    cell.textLabel.text = cityGroup.cities[indexPath.row];
    
    return cell;
}
//设置section的header文本
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    TRCityGroup *cityGroup = self.cityGroupsArray[section];
    return cityGroup.title;
}
//设置tableView的右边索引
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    //self.cityGroupsArray --> title所有组成的数组
    return [self.cityGroupsArray valueForKeyPath:@"title"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //获取点中的城市名字
    TRCityGroup *cityGroup = self.cityGroupsArray[indexPath.section];
    NSString *cityName = cityGroup.cities[indexPath.row];
    //发送通知(带参数)
    [[NSNotificationCenter defaultCenter] postNotificationName:@"TRCityChange" object:self userInfo:@{@"TRSelectedCityName" : cityName}];
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
