//
//  TRBaseCollectionViewController.h
//  TRSearchDeals
//
//  Created by tarena on 15/11/25.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRBaseCollectionViewController : UICollectionViewController
//给子类提供加载的接口(父类实现)
- (void)loadNewDeals;
//给子类提供设置发送请求参数接口(子类实现)
- (void)settingParams:(NSMutableDictionary *)params;






@end
