//
//  TRDeal.m
//  TRSearchDeals
//
//  Created by tarena on 15/11/20.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "TRDeal.h"

@implementation TRDeal

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    //判定key如果是description, 指定字典的value给desc属性
    if ([key isEqualToString:@"description"]) {
        self.desc = value;
    }
    
}





@end
