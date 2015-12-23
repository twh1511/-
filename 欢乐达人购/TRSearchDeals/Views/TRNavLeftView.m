//
//  TRNavLeftView.m
//  TRSearchDeals
//
//  Created by tarena on 15/11/23.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "TRNavLeftView.h"

@implementation TRNavLeftView

+ (id)navView {
    //从xib文件中读取
    return [[[NSBundle mainBundle] loadNibNamed:@"TRNavLeftView" owner:nil options:nil] firstObject];
}

//防止横屏拉伸效果(读取)
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        self.autoresizingMask = UIViewAutoresizingNone;
    }
    return self;
}







@end
