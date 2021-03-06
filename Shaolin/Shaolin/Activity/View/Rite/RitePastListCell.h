//
//  RitePastListCell.h
//  Shaolin
//
//  Created by ws on 2020/8/14.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RitePastModel;

@interface RitePastListCell : UITableViewCell

@property (nonatomic, strong) RitePastModel * cellModel;
@property (nonatomic, assign) BOOL isFirst;

@end

NS_ASSUME_NONNULL_END
