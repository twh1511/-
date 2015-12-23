//
//  TRAnnotation.m
//  TRSearchDeals
//
//  Created by tarena on 15/11/26.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "TRAnnotation.h"

@implementation TRAnnotation


//重写isEqual方法(默认规则不符合同一个商家,不同大头针对象地址的情况); 手动指定规则:判定两个大头针对象的位置是否一样(或者判定对象的title)
- (BOOL)isEqual:(TRAnnotation *)object {
    return [self.title isEqual:object.title];
}









@end
