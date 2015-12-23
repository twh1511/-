//
//  TRTableViewCell.m
//  TRSearchDeals
//
//  Created by tarena on 15/11/24.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "TRTableViewCell.h"

@implementation TRTableViewCell

+ (id)cellWithTableView:(UITableView *)tableView withImageName:(NSString *)imageName withSelectedImageName:(NSString *)selectedName {
    //重用机制
    static NSString *identifier = @"cell";
    TRTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TRTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    //设置cell两个背景图片
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:selectedName]];
    
    return cell;
}

//重写setRegion方法(设置cell其他属性)
//cell.region = self.regionsArray[indexPath.row];
- (void)setRegion:(TRRegion *)region {
    //文本
    self.textLabel.text = region.name;
    //右箭头
    if (region.subregions.count > 0) {
        self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_cell_rightArrow"]];
    } else {
        self.accessoryView = nil;
    }
}

//重写setCategory方法
- (void)setCategory:(TRCategory *)category {
    //title
    self.textLabel.text = category.name;
    //左边两个图片
    self.imageView.image = [UIImage imageNamed:category.small_icon];
    self.imageView.highlightedImage = [UIImage imageNamed:category.small_highlighted_icon];
    //右边箭头
    if (category.subcategories.count > 0) {
        self.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_cell_rightArrow"]];
    } else {
        self.accessoryView = nil;
        
    }
    
}










@end
