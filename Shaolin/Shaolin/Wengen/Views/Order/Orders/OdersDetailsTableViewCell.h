//
//  OdersDetailsTableViewCell.h
//  Shaolin
//
//  Created by 郭超 on 2020/4/21.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class OrderDetailsModel;

@interface OdersDetailsTableViewCell : UITableViewCell

@property(nonatomic, assign)OrderDetailsType orderDetailsType;

@property(nonatomic, strong)OrderDetailsModel *model;


@end

NS_ASSUME_NONNULL_END
