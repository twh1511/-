//
//  UIBarButtonItem+TRBarItem.h
//  TRSearchDeals
//
//  Created by tarena on 15/11/23.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (TRBarItem)

//返回一个已经创建好的UIBarButtonItem对象
+ (UIBarButtonItem *)itemWithImageName:(NSString *)imageName withHighlightedImageName:(NSString *)hlImageName withTarget:(id)target withAction:(SEL)action;






@end
