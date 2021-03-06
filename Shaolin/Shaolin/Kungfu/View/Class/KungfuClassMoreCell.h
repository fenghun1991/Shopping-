//
//  KungfuClassMoreCell.h
//  Shaolin
//
//  Created by ws on 2020/5/13.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ClassListModel;
@interface KungfuClassMoreCell : UITableViewCell
@property (nonatomic, strong) NSArray *classListArray;

@property (nonatomic, copy) void(^ cellSelectBlock)(ClassListModel *model);

@end

NS_ASSUME_NONNULL_END
