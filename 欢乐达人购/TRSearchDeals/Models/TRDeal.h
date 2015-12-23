//
//  TRDeal.h
//  TRSearchDeals
//
//  Created by tarena on 15/11/20.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRDeal : NSObject
/*规则一:模型类中属性变量名字要和服务器返回JSON中的key,一模一样
 规则二: 不允许包含任何的关键字(id例外)
 规则三: 如果有关键字, 在.m文件中就必须重写setValue:forUndefinedKey:(指定字典中关键字description和模型类.h中哪个属性进行绑定)
 */
//订单title
@property(nonatomic,strong) NSString *title;
//订单详细描述(关键字description)
@property(nonatomic,strong) NSString *desc;
//原价格(float:200.0000008)
@property(nonatomic,strong) NSNumber *list_price;
//团购价格
@property(nonatomic,strong) NSNumber *current_price;
//购买数量
@property(nonatomic, assign) int purchase_count;
//订单图片url
@property(nonatomic,strong) NSString *image_url;
//订单小图url
@property(nonatomic,strong) NSString *s_image_url;
//html5网页url
@property(nonatomic,strong) NSString *deal_h5_url;
//商户(商家)
@property(nonatomic,strong) NSArray *businesses;
//订单所属分类
@property(nonatomic,strong) NSArray *categories;












@end
