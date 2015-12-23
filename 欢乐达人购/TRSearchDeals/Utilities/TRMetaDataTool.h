//
//  TRMetaDataTool.h
//  TRSearchDeals
//
//  Created by tarena on 15/11/20.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TRDeal.h"
#import "TRCategory.h"

@interface TRMetaDataTool : NSObject

//返回所有分类的方法(数组:TRCategory)
+ (NSArray *)categories;

//返回所有排序的方法(数组:TRSort)
+ (NSArray *)sorts;

//返回所有城市的方法(数组:TRCity)
+ (NSArray *)cities;

//给定城市, 返回所有该城市的区域数组
+ (NSArray *)regionsByCityName:(NSString *)cityName;

//返回所有城市组的数组(数组:TRCityGroup)
+ (NSArray *)cityGroups;

//给定result,返回所有订单模型对象的数组(数组:TRDeal)
+ (NSArray *)parseResultFromServer:(id)result;

//给定某个订单对象,返回所有商家模型对象的数组(数组:TRBusiness)
+ (NSArray *)getBusinessesWithDeal:(TRDeal *)deal;
//给定某个订单对象, 返回该订单属于那个分类对象
+ (TRCategory *)categoryWithDeal:(TRDeal *)deal;












@end
