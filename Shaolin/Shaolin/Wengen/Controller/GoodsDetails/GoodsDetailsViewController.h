//
//  GoodsDetailsViewController.h
//  Shaolin
//
//  Created by 郭超 on 2020/3/25.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class WengenGoodsModel;

@interface GoodsDetailsViewController : RootViewController

@property(nonatomic, strong)WengenGoodsModel *goodsModel;

@end

NS_ASSUME_NONNULL_END
