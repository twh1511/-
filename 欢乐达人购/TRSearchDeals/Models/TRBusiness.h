//
//  TRBusiness.h
//  TRSearchDeals
//
//  Created by tarena on 15/11/26.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRBusiness : NSObject

@property(nonatomic,strong) NSString *name;
@property(nonatomic,assign) int id;
@property(nonatomic,strong) NSString *city;
@property(nonatomic,assign) float latitude;
@property(nonatomic,assign) float longitude;
@property(nonatomic,strong) NSString *url;
@property(nonatomic,strong) NSString *h5_url;







@end
