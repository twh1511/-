//
//  TRCategoryViewController.m
//  TRSearchDeals
//
//  Created by tarena on 15/11/24.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "TRCategoryViewController.h"
#import "TRMetaDataTool.h"
#import "TRTableViewCell.h"
#import "TRCategory.h"

@interface TRCategoryViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UITableView *subTableView;
@property (nonatomic, strong) NSArray *categoriesArray;
@end

@implementation TRCategoryViewController
- (NSArray *)categoriesArray {
    if (!_categoriesArray) {
        _categoriesArray = [TRMetaDataTool categories];
    }
    return _categoriesArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //作业:数据来源[TRMetaDataTool categories];
}

#pragma mark --- TableViewDataSourceDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.mainTableView) {
        return self.categoriesArray.count;
    } else {
        NSInteger selectedRow = [self.mainTableView indexPathForSelectedRow].row;
        TRCategory *category = self.categoriesArray[selectedRow];
        return category.subcategories.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.mainTableView) {
        TRTableViewCell *cell = [TRTableViewCell cellWithTableView:tableView withImageName:@"bg_dropdown_leftpart" withSelectedImageName:@"bg_dropdown_left_selected"];
        //设置cell的属性(重写setCategory方法)
        cell.category = self.categoriesArray[indexPath.row];
        return cell;
    } else {
        TRTableViewCell *cell = [TRTableViewCell cellWithTableView:tableView withImageName:@"bg_dropdown_rightpart" withSelectedImageName:@"bg_dropdown_right_selected"];
        NSInteger selectedRow = [self.mainTableView indexPathForSelectedRow].row;
        TRCategory *category = self.categoriesArray[selectedRow];
        cell.textLabel.text = category.subcategories[indexPath.row];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.mainTableView) {
        //加载右边tableView
        [self.subTableView reloadData];
        //情况一: 没有子分类;发送通知(TRCategory)
        TRCategory *category = self.categoriesArray[indexPath.row];
        if (category.subcategories.count == 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TRCategoryChange" object:self userInfo:@{@"TRSelectedCategory" : category}];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }

    } else {
        //情况二: 有子分类;发送通知(TRCategory; 子分类名字)
        //左边和右边选择的行号
        NSInteger leftSelectedRow = [self.mainTableView indexPathForSelectedRow].row;
        NSInteger rightSelectedRow = [self.subTableView indexPathForSelectedRow].row;
        TRCategory *category = self.categoriesArray[leftSelectedRow];
        NSString *subCategoryName = category.subcategories[rightSelectedRow];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TRCategoryChange" object:self userInfo:@{@"TRSelectedCategory": category, @"TRSelectedSubCategoryName":subCategoryName}];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    

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
