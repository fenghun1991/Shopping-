//
//  RiteRegistrationFormViewController.h
//  Shaolin
//
//  Created by 王精明 on 2020/7/21.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RiteRegistrationFormViewController : RootViewController
/*!pujaType 1:水路法会 2 普通法会 3 全年佛事 4 建寺安僧*/
@property (nonatomic, copy) NSString *pujaType;
/*!法会活动code*/
@property (nonatomic, copy) NSString *pujaCode;


@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;
@end

NS_ASSUME_NONNULL_END
