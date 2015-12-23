//
//  TRTableViewCell.h
//  TRSearchDeals
//
//  Created by tarena on 15/11/24.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRRegion.h"
#import "TRCategory.h"

@interface TRTableViewCell : UITableViewCell

@property(nonatomic,strong) TRRegion *region;
@property(nonatomic,strong) TRCategory *category;


//给定cell默认背景图片和选中背景图片, 返回已经创建好得cell
+ (id)cellWithTableView:(UITableView *)tableView withImageName:(NSString *)imageName withSelectedImageName:(NSString *)selectedName;








@end
