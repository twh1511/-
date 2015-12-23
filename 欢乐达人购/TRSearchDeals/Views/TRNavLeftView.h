//
//  TRNavLeftView.h
//  TRSearchDeals
//
//  Created by tarena on 15/11/23.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRNavLeftView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@property (weak, nonatomic) IBOutlet UIButton *imageButton;

//返回从xib加载的自定义的视图
+ (id)navView;


@end
