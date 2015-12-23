//
//  TRMetaDataTool.m
//  TRSearchDeals
//
//  Created by tarena on 15/11/20.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "TRMetaDataTool.h"
#import "TRCategory.h"
#import "TRSort.h"
#import "TRCity.h"
#import "TRRegion.h"
#import "TRCityGroup.h"
#import "TRDeal.h"
#import "TRBusiness.h"

@implementation TRMetaDataTool

static NSArray *_categoryArray = nil;
+ (NSArray *)categories {
    if (!_categoryArray) {
        _categoryArray = [[self alloc] getAndParseWithPlistFile:@"categories.plist" withClass:[TRCategory class]];
    }
    return _categoryArray;
}

static NSArray *_citiesArray = nil;
+ (NSArray *)cities {
    if (!_citiesArray) {
        _citiesArray = [[self alloc] getAndParseWithPlistFile:@"cities.plist" withClass:[TRCity class]];
    }
    return _citiesArray;
}
//keyword: iOS Class as parameter


static NSArray *_sortsArray = nil;
+ (NSArray *)sorts {
    if (!_sortsArray) {
        //初始化排序数组
        _sortsArray = [[self alloc] getAndParseWithPlistFile:@"sorts.plist" withClass:[TRSort class]];
    }
    return _sortsArray;
}

static NSArray *_cityGroupsArray = nil;
+ (NSArray *)cityGroups {
    if (!_cityGroupsArray) {
        _cityGroupsArray = [[self alloc] getAndParseWithPlistFile:@"cityGroups.plist" withClass:[TRCityGroup class]];
    }
    return _cityGroupsArray;
}

- (NSArray *)getAndParseWithPlistFile:(NSString *)plistFile withClass:(Class)className {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:plistFile ofType:nil];
    
    NSArray *array = [NSArray arrayWithContentsOfFile:plistPath];
    NSMutableArray *mutableArray = [NSMutableArray array];
    
    for (NSDictionary *dic in array) {
//        TRSort *sort = [TRSort new];
        //创建一个实例变量
        id instance = [[className alloc] init];
        [instance setValuesForKeysWithDictionary:dic];
        [mutableArray addObject:instance];
    }
    return [mutableArray copy];
}


+ (NSArray *)regionsByCityName:(NSString *)cityName {
    //获取所有城市的数组(TRCity)
    NSArray *citiesArray = [self cities];
    
    TRCity *findedCity = [TRCity new];
    for (TRCity *city in citiesArray) {
        if ([city.name isEqualToString:cityName]) {
            findedCity = city;
            //跳出循环
            break;
        }
    }
    //从找到的城市对应的所有区域(NSDictionary->TRRegion)
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *regionDic in findedCity.regions) {
        TRRegion *region = [TRRegion new];
        [region setValuesForKeysWithDictionary:regionDic];
        [mutableArray addObject:region];
    }
    return [mutableArray copy];
}


+ (NSArray *)parseResultFromServer:(id)result {
    NSArray *array = result[@"deals"];
    
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *dealDic in array) {
        TRDeal *deal = [TRDeal new];
        [deal setValuesForKeysWithDictionary:dealDic];
        [mutableArray addObject:deal];
    }
    return [mutableArray copy];
}

+ (NSArray *)getBusinessesWithDeal:(TRDeal *)deal {
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSDictionary *businessDic in deal.businesses) {
        TRBusiness *business = [TRBusiness new];
        [business setValuesForKeysWithDictionary:businessDic];
        [mutableArray addObject:business];
    }
    
    return [mutableArray copy];
}

+ (id)categoryWithDeal:(TRDeal *)deal {
    //给定订单对象对应的数组中第一项分类名字
    NSString *categoryStr = [deal.categories firstObject];
    
    //获取所有的分类数据(categories.plist)
    NSArray *categoryArray = [self categories];
    //循环寻找属于哪个分类
    for (TRCategory *category in categoryArray) {
        //主分类
        if ([category.name isEqualToString:categoryStr]) {
            return category;
        }
        //子分类
        if ([category.subcategories containsObject:categoryStr]) {
            return category;
        }
    }
    
    return nil;
}









@end
