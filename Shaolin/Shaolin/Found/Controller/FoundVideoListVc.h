//
//  FoundVideoListVc.h
//  Shaolin
//
//  Created by edz on 2020/3/26.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RootViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FoundVideoListVc : RootViewController
@property(nonatomic,copy) NSString *videoId;
@property(nonatomic,copy) NSString *fieldId;
@property(nonatomic,copy) NSString *tabbarStr;
@property (nonatomic,copy) NSString *typeStr;
@end

NS_ASSUME_NONNULL_END
