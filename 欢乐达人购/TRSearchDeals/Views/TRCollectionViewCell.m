//
//  TRCollectionViewCell.m
//  TRSearchDeals
//
//  Created by tarena on 15/11/25.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import "TRCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@interface TRCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *listPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *purchaseCountLabel;
@end

@implementation TRCollectionViewCell

- (void)setDeal:(TRDeal *)deal {
    //cell背景图片
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_dealcell"]];
    
    //图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:deal.image_url] placeholderImage:[UIImage imageNamed:@"placeholder_deal"]];
    
    //title
    self.titleLabel.text = deal.title;
    //描述
    self.descriptionLabel.text = deal.desc;
    //团购价格
    self.currentPriceLabel.text = [NSString stringWithFormat:@"¥%@", deal.current_price];
    //原价格
    self.listPriceLabel.text = [NSString stringWithFormat:@"¥%@", deal.list_price];
    //已售多少
    self.purchaseCountLabel.text = [NSString stringWithFormat:@"已售%d", deal.purchase_count];
}










@end
