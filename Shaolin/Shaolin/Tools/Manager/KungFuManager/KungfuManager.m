//
//  KungfuManager.m
//  Shaolin
//
//  Created by edz on 2020/4/29.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "KungfuManager.h"

#import "EnrollmentModel.h"
#import "EnrollmentListModel.h"
#import "LevelModel.h"
#import "HotClassModel.h"
#import "CertificateModel.h"
#import "ScoreListModel.h"
#import "ScoreDetailModel.h"
#import "ClassListModel.h"
#import "InstitutionModel.h"
#import "ExaminationNoticeModel.h"
#import "ApplyListModel.h"

#import <AFNetworking.h>
#import "DefinedHost.h"

#import "DefinedURLs.h"
#import "DegreeNationalDataModel.h"
#import "EnrollmentAddressModel.h"

#import "ExamNoticeModel.h"

@interface KungfuManager()

@property(strong, nonatomic)AFHTTPSessionManager *manager;

@end

@implementation KungfuManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static KungfuManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

-(void)postHotCitySuccess:(SLSuccessDicBlock)success
                  failure:(SLFailureReasonBlock)failure
                   finish:(SLFinishedResultBlock)finish{
    [SLRequest postHttpRequestWithApi:KungFu_HotCity parameters:@{} success:success failure:failure finish:finish];
}

//-(void)classificationSuccess:(void (^)(NSURLSessionDataTask * task, id responseObject))success failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure {
//     NSString *url = [NSString stringWithFormat:@"%@%@",Found,Activity_Classification];
//     [[NetworkingHandler sharedInstance] POSTHandle:url head:nil parameters:nil progress:nil success:success failure:failure];
//}

-(void)classificationSuccess:(SLSuccessDicBlock)success
                     failure:(SLFailureReasonBlock)failure
                      finish:(SLFinishedResultBlock)finish{
    [SLRequest postHttpRequestWithApi:Activity_Classification parameters:@{} success:success failure:failure finish:finish];
}

/*
 * 分类查询适配活动 || 段 品阶 品查询适配活动
 */
//- (void)activityList:(NSDictionary *)params Success:(void (^)(NSURLSessionDataTask * task, id responseObject))success failure:(void (^)(NSURLSessionDataTask * task, NSError * error))failure {
//        NSString *url = [NSString stringWithFormat:@"%@%@",Found,Activity_ActivityList];
//        [[NetworkingHandler sharedInstance] POSTHandle:url head:nil parameters:params progress:nil success:success failure:failure];
//}

- (void)activityList:(NSDictionary *)params
             Success:(SLSuccessDicBlock)success
             failure:(SLFailureReasonBlock)failure
              finish:(SLFinishedResultBlock)finish{
    [SLRequest postHttpRequestWithApi:Activity_ActivityList parameters:params success:success failure:failure finish:finish];
}


/// 活动分类
-(void)getClassification:(NSDictionary *)param callback:(NSArrayCallBack)call{
    
    //    [self.manager POST:MKURL(Found, Activity_Classification) parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //
    //        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //
    //        if ([ModelTool checkResponseObject:dic]) {
    //
    //            NSArray *arr = [dic objectForKey:DATAS][DATAS];
    //            NSArray *dataList = [EnrollmentModel mj_objectArrayWithKeyValuesArray:arr];
    //            if (call) call(dataList);
    //        } else {
    //            if (call) call(nil);
    //        }
    //    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //
    //        NSLog(@"error : %@", error);
    //        if (call) call(nil);
    //    }];
    //
    
    [SLRequest postJsonRequestWithApi:Activity_Classification parameters:param success:^(NSDictionary * _Nullable resultDic) {
        
    } failure:^(NSString * _Nullable errorReason) {
        
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        NSDictionary * dic = resultDic;
        
        if ([ModelTool checkResponseObject:dic]) {
            
            NSArray *arr = [dic objectForKey:DATAS][DATAS];
            NSArray *dataList = [EnrollmentModel mj_objectArrayWithKeyValuesArray:arr];
            if (call) call(dataList);
        } else {
            if (call) call(nil);
        }
    }];
    
    
    
}

/// 分类查询适配活动 || 段 品阶 品查询适配活动
-(void)getActivityList:(NSDictionary *)param callback:(NSArrayCallBack)call{
    //    [self.manager POST:MKURL(Found, Activity_ActivityList) parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //
    //
    //        if ([ModelTool checkResponseObject:dic]) {
    //            NSArray *arr = [[dic objectForKey:DATAS] objectForKey:DATAS];
    //            NSArray *dataList = [EnrollmentListModel mj_objectArrayWithKeyValuesArray:arr];
    //
    //            NSInteger currentNum =[param[@"currentNum"] integerValue];
    //            NSInteger total = [dic[DATAS][@"total"] integerValue];
    //            if (currentNum >= total) {
    //                if (call) call(nil);
    //            }else{
    //                if (call) call(dataList);
    //            }
    //        }
    //    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //
    //        NSLog(@"error : %@", error);
    //        if (call) call(nil);
    //    }];
    
    
    [SLRequest postJsonRequestWithApi:Activity_ActivityList parameters:param success:^(NSDictionary * _Nullable resultDic) {
        
    } failure:^(NSString * _Nullable errorReason) {
        
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        NSDictionary * dic = resultDic;
        
        if ([ModelTool checkResponseObject:dic]) {
            NSArray *arr = [[dic objectForKey:DATAS] objectForKey:DATAS];
            NSArray *dataList = [EnrollmentListModel mj_objectArrayWithKeyValuesArray:arr];
            
            NSInteger currentNum =[param[@"currentNum"] integerValue];
            NSInteger total = [dic[DATAS][@"total"] integerValue];
            if (currentNum >= total) {
                if (call) call(nil);
            }else{
                if (call) call(dataList);
            }
        }
    }];
    
    
    
}

///段 、品、品阶
-(void)getLevelList:(NSDictionary *)param callbacl:(NSDictionaryCallBack)call{
    //    [self.manager POST:MKURL(Found, Activity_LEVEL_LEVELLIST) parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //           NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //
    //           if ([ModelTool checkResponseObject:dic]) {
    //
    //               NSLog(@"dic %@",dic);
    //               NSDictionary *dataDic = dic[DATAS];
    //               NSArray *duanArray = dataDic[@"duan"];
    //               NSArray *fradeArray = dataDic[@"frade"];
    //               NSArray *pinArray = dataDic[@"pin"];
    //
    //               NSArray *duanModelArray = [LevelModel mj_objectArrayWithKeyValuesArray:duanArray];
    //               NSArray *fradeModelArray = [LevelModel mj_objectArrayWithKeyValuesArray:fradeArray];
    //               NSArray *pinModelArray = [LevelModel mj_objectArrayWithKeyValuesArray:pinArray];
    //
    //               NSMutableDictionary *allDic = [NSMutableDictionary dictionary];
    //               [allDic setValue:duanModelArray forKey:@"duan"];
    //               [allDic setValue:fradeModelArray forKey:@"frade"];
    //               [allDic setValue:pinModelArray forKey:@"pin"];
    //
    //               for (LevelModel *model in duanModelArray) {
    //                   model.levelType = @"1";
    //                   [[ModelTool shareInstance]insert:model tableName:@"level"];
    //               }
    //
    //               for (LevelModel *model in fradeModelArray) {
    //                   model.levelType = @"2";
    //                   [[ModelTool shareInstance]insert:model tableName:@"level"];
    //               }
    //
    //               for (LevelModel *model in pinModelArray) {
    //                    model.levelType = @"3";
    //                   [[ModelTool shareInstance]insert:model tableName:@"level"];
    //               }
    //
    //               if (call) call(allDic);
    //           } else {
    //               if (call) call (nil);
    //           }
    //       }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //
    //           NSLog(@"error : %@", error);
    //           if (call) call(nil);
    //       }];
    //
    
    [SLRequest postJsonRequestWithApi:Activity_LEVEL_LEVELLIST parameters:param success:^(NSDictionary * _Nullable resultDic) {
        
    } failure:^(NSString * _Nullable errorReason) {
        
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        NSDictionary * dic = resultDic;
        if ([ModelTool checkResponseObject:dic]) {
            
            NSLog(@"dic %@",dic);
            NSDictionary *dataDic = dic[DATAS];
            NSArray *duanArray = dataDic[@"duan"];
            NSArray *fradeArray = dataDic[@"frade"];
            NSArray *pinArray = dataDic[@"pin"];
            
            NSArray *duanModelArray = [LevelModel mj_objectArrayWithKeyValuesArray:duanArray];
            NSArray *fradeModelArray = [LevelModel mj_objectArrayWithKeyValuesArray:fradeArray];
            NSArray *pinModelArray = [LevelModel mj_objectArrayWithKeyValuesArray:pinArray];
            
            NSMutableDictionary *allDic = [NSMutableDictionary dictionary];
            [allDic setValue:duanModelArray forKey:@"duan"];
            [allDic setValue:fradeModelArray forKey:@"frade"];
            [allDic setValue:pinModelArray forKey:@"pin"];
            
            for (LevelModel *model in duanModelArray) {
                model.levelType = @"1";
                [[ModelTool shareInstance]insert:model tableName:@"level"];
            }
            
            for (LevelModel *model in fradeModelArray) {
                model.levelType = @"2";
                [[ModelTool shareInstance]insert:model tableName:@"level"];
            }
            
            for (LevelModel *model in pinModelArray) {
                model.levelType = @"3";
                [[ModelTool shareInstance]insert:model tableName:@"level"];
            }
            
            if (call) call(allDic);
        } else {
            if (call) call (nil);
        }
    }];
}

///检查筛查所适用报名的位阶
-(void)activityCheckedLevel:(NSDictionary *)param callbacl:(NSObjectCallBack)call{
    
    //    NSString *url = [NSString stringWithFormat:@"%@?activityCode=%@", ADD(ACTIVITY_LEVEL_ACTIVITYCHECKEDLEVEL), param[@"activityCode"]];
    //
    //    [self.manager POST:url parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //
    //
    //        if ([ModelTool checkResponseObject:dic]){
    //
    //            NSDictionary *dataDic = [[dic objectForKey:DATAS] objectForKey:DATAS];
    //
    //            EnrollmentListModel *model = [EnrollmentListModel mj_objectWithKeyValues:dataDic];
    //            if (call) call(model);
    //
    //        }else{
    //            Message *message = [[Message alloc]init];
    //            message.isSuccess = NO;
    //            message.reason = dic[MSG];
    //            if (call) call(message);
    //        }
    //
    //    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        if (call) call(nil);
    //    }];
    //
    
    
    
    [SLRequest postHttpRequestWithApi:ACTIVITY_LEVEL_ACTIVITYCHECKEDLEVEL parameters:param success:^(NSDictionary * _Nullable resultDic) {
        
    } failure:^(NSString * _Nullable errorReason) {
        
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        NSDictionary * dic = resultDic;
        if ([ModelTool checkResponseObject:dic]){
            
            NSDictionary *dataDic = [[dic objectForKey:DATAS] objectForKey:DATAS];
            
            EnrollmentListModel *model = [EnrollmentListModel mj_objectWithKeyValues:dataDic];
            if (call) call(model);
            
        }else{
            Message *message = [[Message alloc]init];
            message.isSuccess = NO;
            message.reason = errorReason;
            if (call) call(message);
        }
    }];
    
}

///段品制活动详情
-(void)activityDetails:(NSDictionary *)param callbacl:(NSObjectCallBack)call{
    [SLRequest postHttpRequestWithApi:KungFu_applicationsEcho parameters:param success:^(NSDictionary * _Nullable resultDic) {
        
    } failure:^(NSString * _Nullable errorReason) {
        
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        NSDictionary * dic = resultDic;
        if ([ModelTool checkResponseObject:dic]){
            
            NSDictionary *dataDic = [[dic objectForKey:DATAS] objectForKey:DATAS];
            
            EnrollmentListModel *model = [EnrollmentListModel mj_objectWithKeyValues:dataDic];
            if (call) call(model);
            
        }else{
            Message *message = [[Message alloc]init];
            message.isSuccess = NO;
            message.reason = errorReason;
            if (call) call(message);
        }
    }];
}

-(void)getHotClassListAndCallback:(NSArrayCallBack)call {
    //    [self.manager POST:MKURL(Found, KungFu_HotClass) parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //
    //
    //        if ([ModelTool checkResponseObject:dic]) {
    //            NSArray *arr = [[dic objectForKey:DATAS] objectForKey:LIST];
    //            NSArray *dataList = [HotClassModel mj_objectArrayWithKeyValuesArray:arr];
    //            if (call) call(dataList);
    //        } else {
    //            if (call) call(nil);
    //        }
    //    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //
    //        NSLog(@"error : %@", error);
    //        if (call) call(nil);
    //    }];
    
    
    
    [SLRequest postHttpRequestWithApi:KungFu_HotClass parameters:@{} success:^(NSDictionary * _Nullable resultDic) {
        
    } failure:^(NSString * _Nullable errorReason) {
        
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        NSDictionary * dic = resultDic;
        if ([ModelTool checkResponseObject:dic]) {
            NSArray *arr = [[dic objectForKey:DATAS] objectForKey:LIST];
            NSArray *dataList = [HotClassModel mj_objectArrayWithKeyValuesArray:arr];
            if (call) call(dataList);
        } else {
            if (call) call(nil);
        }
    }];
    
    
}


-(void)getHotActivityListAndCallback:(NSArrayCallBack)call {
    
    //    [self.manager POST:MKURL(Found, KungFu_HotActivity) parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //
    //
    //        if ([ModelTool checkResponseObject:dic]) {
    //            NSArray *arr = [[dic objectForKey:DATAS] objectForKey:DATAS];
    //            NSArray *dataList = [EnrollmentListModel mj_objectArrayWithKeyValuesArray:arr];
    //            if (call) call(dataList);
    //        } else {
    //            if (call) call(nil);
    //        }
    //    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //
    //        NSLog(@"error : %@", error);
    //        if (call) call(nil);
    //    }];
    //
    
    [SLRequest postHttpRequestWithApi:KungFu_HotActivity parameters:@{} success:^(NSDictionary * _Nullable resultDic) {
        
    } failure:^(NSString * _Nullable errorReason) {
        
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        NSDictionary * dic = resultDic;
        if ([ModelTool checkResponseObject:dic]) {
            NSArray *arr = [[dic objectForKey:DATAS] objectForKey:DATAS];
            NSArray *dataList = [EnrollmentListModel mj_objectArrayWithKeyValuesArray:arr];
            if (call) call(dataList);
        } else {
            if (call) call(nil);
        }
    }];
}

- (void)getLevelAchievementsAndCallback:(NSDictionaryCallBack)call {
    //    [self.manager GET:MKURL(Found, KungFu_Achievements) parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //
    //        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //        NSDictionary * dataDic = [dic objectForKey:DATAS];
    //        call(dataDic);
    //
    //    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        NSLog(@"error : %@", error);
    //        if (call) call(nil);
    //    }];
    
    
    [SLRequest getRequestWithApi:KungFu_Achievements parameters:@{} success:^(NSDictionary * _Nullable resultDic) {
        
    } failure:^(NSString * _Nullable errorReason) {
        
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        NSDictionary * dic = resultDic;
        NSDictionary * dataDic = [dic objectForKey:DATAS];
        call(dataDic);
    }];
}

-(void)getCertificateAndCallback:(NSArrayCallBack)call {
    
    //    [self.manager GET:MKURL(Found, KungFu_Certificate) parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //
    //        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //        NSArray * dataList = [[dic objectForKey:DATAS] objectForKey:DATAS];
    //        NSArray * modelArray = [CertificateModel mj_objectArrayWithKeyValuesArray:dataList];
    //
    //        if (call) call(modelArray);
    //
    //    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        NSLog(@"error : %@", error);
    //        if (call) call(nil);
    //    }];
    //
    
    
    [SLRequest getRequestWithApi:KungFu_Certificate parameters:@{} success:^(NSDictionary * _Nullable resultDic) {
        
    } failure:^(NSString * _Nullable errorReason) {
        
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        NSDictionary * dic = resultDic;
        NSArray * dataList = [[dic objectForKey:DATAS] objectForKey:DATAS];
        NSArray * modelArray = [CertificateModel mj_objectArrayWithKeyValuesArray:dataList];
        
        if (call) call(modelArray);
    }];
    
    
    
}

-(void)getApplicationCertificate:(NSDictionary *)param callback:(MessageCallBack)call {
    
    //    NSString *url = MKURL(Found, KungFu_ApplicationCertificate);
    //    [[NetworkingHandler sharedInstance] POSTHandle:url head:nil parameters:param progress:nil success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
    //
    //        NSDictionary * dic = responseObject;
    //
    //        Message *message = [[Message alloc] init];
    //
    //        BOOL isSuccess = NO;
    //        if ([ModelTool checkResponseObject:dic]){
    //            isSuccess = YES;
    //        }else{
    //            isSuccess = NO;
    //        }
    //        message.isSuccess = isSuccess;
    //        message.reason = dic[MSG];
    //
    //        if (call) call(message);
    //    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
    //
    //        NSLog(@"error : %@", error);
    //        if (call) call(nil);
    //    }];
    //
    
    
    [SLRequest postHttpRequestWithApi:KungFu_ApplicationCertificate parameters:param success:^(NSDictionary * _Nullable resultDic) {
        
    } failure:^(NSString * _Nullable errorReason) {
        
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        NSDictionary * dic = resultDic;
        Message *message = [[Message alloc] init];
        
        BOOL isSuccess = NO;
        if ([ModelTool checkResponseObject:dic]){
            isSuccess = YES;
        }else{
            isSuccess = NO;
        }
        message.isSuccess = isSuccess;
        message.reason = dic[MSG];
        
        if (call) call(message);
    }];
    
    
}

-(void)getScoreList:(NSDictionary *)params callback:(NSArrayCallBack)call {
    //    [self.manager GET:MKURL(Found, KungFu_ScoreList) parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //
    //        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //        if ([ModelTool checkResponseObject:dic]) {
    //            NSArray * dataList = [[dic objectForKey:DATAS] objectForKey:@"data"];
    //            NSArray * modelArray = [ScoreListModel mj_objectArrayWithKeyValuesArray:dataList];
    //            if (call) call(modelArray);
    //        } else {
    //            if (call) call(nil);
    //        }
    //    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        NSLog(@"error : %@", error);
    //        if (call) call(nil);
    //    }];
    
    
    [SLRequest getRequestWithApi:KungFu_ScoreList parameters:params success:^(NSDictionary * _Nullable resultDic) {
        
    } failure:^(NSString * _Nullable errorReason) {
        
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        NSDictionary * dic = resultDic;
        if ([ModelTool checkResponseObject:dic]) {
            NSArray * dataList = [[dic objectForKey:DATAS] objectForKey:@"data"];
            NSArray * modelArray = [ScoreListModel mj_objectArrayWithKeyValuesArray:dataList];
            if (call) call(modelArray);
        } else {
            if (call) call(nil);
        }
    }];
    
}

//成绩详情查询
-(void)getScoreDetailWithParams:(NSDictionary *)params callbacl:(MessageCallBack)call {
    //    [self.manager GET:MKURL(Found, KungFu_ScoreDetail) parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //        if ([ModelTool checkResponseObject:dic]) {
    //            NSDictionary * dataDic = [dic objectForKey:DATAS];
    //            ScoreDetailModel *model = [ScoreDetailModel mj_objectWithKeyValues:dataDic];
    //            if (call) call(model);
    //        } else {
    //            if (call) call(nil);
    //        }
    //    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        NSLog(@"error : %@", error);
    //        if (call) call(nil);
    //    }];
    
    [SLRequest getRequestWithApi:KungFu_ScoreDetail parameters:params success:^(NSDictionary * _Nullable resultDic) {
        
    } failure:^(NSString * _Nullable errorReason) {
        
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        Message *message = [[Message alloc] init];
        NSDictionary * dic = resultDic;
        if ([ModelTool checkResponseObject:dic]) {
            NSDictionary * dataDic = [dic objectForKey:DATAS];
            ScoreDetailModel *model = [ScoreDetailModel mj_objectWithKeyValues:dataDic];
            message.extensionDic = @{
                @"ScoreDetailModel" : model,
            };
            if (call) call(message);
        } else {
            message.reason = errorReason;
            if (call) call(message);
        }
    }];
    
    
}

-(void)getClassWithDic:(NSDictionary *)dic success:(SLSuccessDicBlock)success failure:(SLFailureReasonBlock)failure finish:(SLFinishedResultBlock)finish {
  
    [SLRequest postHttpRequestWithApi:KungFu_ClassList parameters:dic success:success failure:failure finish:finish];
}

-(void)getClassRecommendWithDic:(NSDictionary *)dic success:(SLSuccessDicBlock)success failure:(SLFailureReasonBlock)failure finish:(SLFinishedResultBlock)finish {
    
    [SLRequest postHttpRequestWithApi:KungFu_ClasDetail_Recomment parameters:dic success:success failure:failure finish:finish];
}

-(void)getInstitutionListWithDic:(NSDictionary *)dic ListAndCallback:(NSArrayCallBack)call {
    //    [[NetworkingHandler sharedInstance] POSTHandle:MKURL(Found, KungFu_InstitutionList) head:nil parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
    //
    //        if ([ModelTool checkResponseObject:responseObject]) {
    //            NSArray *arr = [[responseObject objectForKey:DATAS] objectForKey:DATAS];
    //            NSArray *dataList = [InstitutionModel mj_objectArrayWithKeyValuesArray:arr];
    //            NSInteger currentTotal = [dic[@"currentTotal"] integerValue];
    //            NSInteger total = [responseObject[DATAS][@"total"] integerValue];
    //            if (currentTotal>=total) {
    //                if (call) call(nil);
    //            }else{
    //                if (call) call(dataList);
    //            }
    //
    //        } else {
    //            if (call) call(nil);
    //        }
    //    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
    //        NSLog(@"error : %@", error);
    //        if (call) call(nil);
    //    }];
    
    
    
    [SLRequest postHttpRequestWithApi:KungFu_InstitutionList parameters:dic success:^(NSDictionary * _Nullable resultDic) {
        
    } failure:^(NSString * _Nullable errorReason) {
        
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        NSDictionary * dic = resultDic;
        if ([ModelTool checkResponseObject:dic]) {
            NSArray *arr = [[dic objectForKey:DATAS] objectForKey:DATAS];
            NSArray *dataList = [InstitutionModel mj_objectArrayWithKeyValuesArray:arr];
            NSInteger currentTotal = [dic[@"currentTotal"] integerValue];
            NSInteger total = [dic[DATAS][@"total"] integerValue];
            if (currentTotal>=total) {
                if (call) call(nil);
            }else{
                if (call) call(dataList);
            }
            
        } else {
            if (call) call(nil);
        }
    }];
    
    
}

-(void)applicationsSaveWithDic:(NSDictionary *)dic callback:(MessageCallBack)call {
    
    //    [[NetworkingHandler sharedInstance] POSTHandle:MKURL(Found, KungFu_ApplicationsSave) head:nil parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
    //        NSDictionary * dic;
    //        if ([responseObject isKindOfClass:[NSDictionary class]] == YES) {
    //            dic = responseObject;
    //        }else{
    //           dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //        }
    //
    //        Message *message = [[Message alloc]init];
    //        BOOL isSuccess = NO;
    //        if ([ModelTool checkResponseObject:dic]){
    //            isSuccess = YES;
    //            message.extensionDic = dic[DATAS][DATAS];
    //        }else{
    //            isSuccess = NO;
    //        }
    //        message.isSuccess = isSuccess;
    //        message.reason = dic[MSG];
    //
    //        if (call) call(message);
    //
    //    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
    //        NSLog(@"error : %@", error);
    //        if (call) call(nil);
    //    }];
    
    
    
    [SLRequest postJsonRequestWithApi:KungFu_ApplicationsSave parameters:dic success:^(NSDictionary * _Nullable resultDic) {
        
    } failure:^(NSString * _Nullable errorReason) {
        
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        NSDictionary * dic = resultDic;
        Message *message = [[Message alloc]init];
        BOOL isSuccess = NO;
        if ([ModelTool checkResponseObject:dic]){
            isSuccess = YES;
            message.extensionDic = dic[DATAS][DATAS];
        }else{
            isSuccess = NO;
            message.reason = errorReason;
        }
        message.isSuccess = isSuccess;
        
        
        if (call) call(message);
    }];
    
    
}

-(void)getMyapplicationsWithParameters:(NSDictionary *)parameter AndCallback:(NSArrayCallBack)call {
    
    //    [self.manager GET:MKURL(Found, KungFu_MyApplications) parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //
    //        if ([ModelTool checkResponseObject:dic]) {
    //            NSArray *arr = [[dic objectForKey:DATAS] objectForKey:DATAS];
    //            NSArray *dataList = [ApplyListModel mj_objectArrayWithKeyValuesArray:arr];
    //            if (call) call(dataList);
    //        } else {
    //            if (call) call(nil);
    //        }
    //    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //
    //        NSLog(@"error : %@", error);
    //        if (call) call(nil);
    //    }];
    
    
    [SLRequest getRequestWithApi:KungFu_MyApplications parameters:parameter success:^(NSDictionary * _Nullable resultDic) {
        
    } failure:^(NSString * _Nullable errorReason) {
        
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        NSDictionary * dic = resultDic;
        if ([ModelTool checkResponseObject:dic]) {
            NSArray *arr = [[dic objectForKey:DATAS] objectForKey:DATAS];
            NSArray *dataList = [ApplyListModel mj_objectArrayWithKeyValuesArray:arr];
            if (call) call(dataList);
        } else {
            if (call) call(nil);
        }
    }];
    
    
    
}

-(void)getApplicationsDetailWithDic:(NSDictionary *)dic AndCallback:(NSDictionaryCallBack)call {
    
    //    [self.manager GET:MKURL(Found, KungFu_applicationsDetail) parameters:dic headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //
    //        if ([ModelTool checkResponseObject:dic]) {
    //            NSDictionary *result = [dic objectForKey:DATAS];
    //
    //            if (call) call(result);
    //        } else {
    //            if (call) call(nil);
    //        }
    //    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //
    //        NSLog(@"error : %@", error);
    //        if (call) call(nil);
    //    }];
    //
    
    
    [SLRequest getRequestWithApi:KungFu_applicationsDetail parameters:dic success:^(NSDictionary * _Nullable resultDic) {
        
    } failure:^(NSString * _Nullable errorReason) {
        
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        NSDictionary * dic = resultDic;
        if ([ModelTool checkResponseObject:dic]) {
            NSDictionary *result = [dic objectForKey:DATAS];
            
            if (call) call(result);
        } else {
            if (call) call(nil);
        }
    }];
    
    
    
}


-(void)getSearchApplicationsListWithDic:(NSDictionary *)dic callback:(NSArrayCallBack)call {
    
    //    [self.manager GET:MKURL(Found, KungFu_applicationsSearch) parameters:dic headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //
    //        if ([ModelTool checkResponseObject:dic]) {
    //            NSArray *arr = [[dic objectForKey:DATAS] objectForKey:DATAS];
    //            NSArray *dataList = [ApplyListModel mj_objectArrayWithKeyValuesArray:arr];
    //            if (call) call(dataList);
    //        } else {
    //            if (call) call(nil);
    //        }
    //    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        NSLog(@"error : %@", error);
    //        if (call) call(nil);
    //    }];
    
    
    [SLRequest getRequestWithApi:KungFu_applicationsSearch parameters:dic success:^(NSDictionary * _Nullable resultDic) {
        
    } failure:^(NSString * _Nullable errorReason) {
        
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        NSDictionary * dic = resultDic;
        
        if ([ModelTool checkResponseObject:dic]) {
            NSArray *arr = [[dic objectForKey:DATAS] objectForKey:DATAS];
            NSArray *dataList = [ApplyListModel mj_objectArrayWithKeyValuesArray:arr];
            if (call) call(dataList);
        } else {
            if (call) call(nil);
        }
    }];
    
    
    
}

-(void)getExaminationNoticeListWithDic:(NSDictionary *)dic callback:(NSDictionaryCallBack)call {
    //    [self.manager GET:MKURL(Found, KungFu_examinationNotice) parameters:dic headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //        if (call) call(dic);
    //    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        NSLog(@"error : %@", error);
    //        if (call) call(nil);
    //    }];
    //
    
    [SLRequest getRequestWithApi:KungFu_examinationNotice parameters:dic success:^(NSDictionary * _Nullable resultDic) {
        
    } failure:^(NSString * _Nullable errorReason) {
        
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        NSDictionary * dic = resultDic;
        
        if (call) call(dic);
    }];
    
    
}

-(void)getStartExaminationAndCallback:(NSDictionaryCallBack)call {
    //    [self.manager GET:MKURL(Found, KungFu_Examination) parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //
    //        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //        if (call) call(dic);
    //
    //    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        NSLog(@"error : %@", error);
    //        if (call) call(nil);
    //    }];
    
    
    [SLRequest getRequestWithApi:KungFu_Examination parameters:@{} success:^(NSDictionary * _Nullable resultDic) {
        
    } failure:^(NSString * _Nullable errorReason) {
        
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        NSDictionary * dic = resultDic;
        
        if (call) call(dic);
    }];
}

-(void)getSubmitExaminationWithDic:(NSDictionary *)dic callback:(NSDictionaryCallBack)call {
    //    [self.manager POST:MKURL(Found, KungFu_ExaminationSubmit) parameters:dic headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //
    //
    //
    //        if (call) call(dic);
    //    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //
    //        NSLog(@"error : %@", error);
    //        if (call) call(nil);
    //    }];
    //
    
    [SLRequest postHttpRequestWithApi:KungFu_ExaminationSubmit parameters:dic success:^(NSDictionary * _Nullable resultDic) {
        
    } failure:^(NSString * _Nullable errorReason) {
        
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        NSDictionary * dic = resultDic;
        
        if (call) call(dic);
    }];
    
}


-(void)getSaveExaminationWithDic:(NSDictionary *)dic callback:(MessageCallBack)call {
    
    //    [[NetworkingHandler sharedInstance] POSTHandle:MKURL(Found, KungFu_ExaminationSave) head:nil parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
    //
    //        if (call) call(nil);
    //
    //    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
    //        NSLog(@"error : %@", error);
    //        if (call) call(nil);
    //    }];
    //
    
    [SLRequest postHttpRequestWithApi:KungFu_ExaminationSave parameters:dic success:^(NSDictionary * _Nullable resultDic) {
        
    } failure:^(NSString * _Nullable errorReason) {
        
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
        if (call) call(nil);
    }];
}

-(void)setCourseReadHistory:(NSDictionary *)dict callback:(NSDictionaryCallBack)call {
    //    [[NetworkingHandler sharedInstance] POSTHandle:MKURL(Found, KungFu_SetCourseReadHistory) head:nil parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
    //        if (call) call(responseObject);
    //    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
    //        NSLog(@"error : %@", error);
    //        if (call) call(nil);
    //    }];
    
    
    [SLRequest postHttpRequestWithApi:KungFu_SetCourseReadHistory parameters:dict success:^(NSDictionary * _Nullable resultDic) {
        
    } failure:^(NSString * _Nullable errorReason) {
        
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
        if (call) call(resultDic);
    }];
    
    
}



-(void)getClassDetailWithDic:(NSDictionary *)dic success:(SLSuccessDicBlock)success failure:(SLFailureReasonBlock)failure finish:(SLFinishedResultBlock)finish {

    [SLRequest postHttpRequestWithApi:KungFu_ClassDetail parameters:dic success:success failure:failure finish:finish];
}

-(void)getClassCollectWithDic:(NSDictionary *)dic callback:(MessageCallBack)call {
    //    [self.manager POST:MKURL(Found, KungFu_ClassCollect) parameters:dic headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //        Message *message = [[Message alloc]init];
    //        BOOL isSuccess = NO;
    //        if ([ModelTool checkResponseObject:dic]){
    //            isSuccess = YES;
    //        }else{
    //            isSuccess = NO;
    //        }
    //        message.isSuccess = isSuccess;
    //        message.reason = dic[MSG];
    //
    //        if (call) call(message);
    //    }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //
    //        NSLog(@"error : %@", error);
    //        if (call) call(nil);
    //    }];
    
    
    [SLRequest postHttpRequestWithApi:KungFu_ClassCollect parameters:dic success:^(NSDictionary * _Nullable resultDic) {
        
    } failure:^(NSString * _Nullable errorReason) {
        
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        NSDictionary *dic = resultDic;
        Message *message = [[Message alloc]init];
        BOOL isSuccess = NO;
        if ([ModelTool checkResponseObject:dic]){
            isSuccess = YES;
        }else{
            isSuccess = NO;
        }
        message.isSuccess = isSuccess;
        message.reason = dic[MSG];
        
        if (call) call(message);
    }];
    
}

- (void)postClassCancelCollectWithDic:(NSDictionary *)dic callback:(MessageCallBack)call{
    
}

-(void)mechanismSignUpWithDic:(NSDictionary *)dic callback:(MessageCallBack)call {
    
    //    [[NetworkingHandler sharedInstance] POSTHandle:MKURL(Found, KungFu_MECHANISM_MECHANISMSIGNUP) head:nil parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
    //        NSDictionary * dic;
    //        if ([responseObject isKindOfClass:[NSDictionary class]] == YES) {
    //            dic = responseObject;
    //        }else{
    //           dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //        }
    //
    //        Message *message = [[Message alloc]init];
    //        BOOL isSuccess = NO;
    //        if ([ModelTool checkResponseObject:dic]){
    //            isSuccess = YES;
    //        }else{
    //            isSuccess = NO;
    //        }
    //        message.isSuccess = isSuccess;
    //        message.reason = dic[MSG];
    //
    //        if (call) call(message);
    //
    //    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
    //        NSLog(@"error : %@", error);
    //        if (call) call(nil);
    //    }];
    
    
    
    [SLRequest postHttpRequestWithApi:KungFu_MECHANISM_MECHANISMSIGNUP parameters:dic success:^(NSDictionary * _Nullable resultDic) {
        
    } failure:^(NSString * _Nullable errorReason) {
        
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        NSDictionary *dic = resultDic;
        Message *message = [[Message alloc]init];
        BOOL isSuccess = NO;
        if ([ModelTool checkResponseObject:dic]){
            isSuccess = YES;
        }else{
            isSuccess = NO;
        }
        message.isSuccess = isSuccess;
        message.reason = dic[MSG];
        
        if (call) call(message);
    }];
    
}

///考试凭证
-(void)checkProof:(NSDictionary *)param callback:(NSDictionaryCallBack)call{
    //    [[NetworkingHandler sharedInstance] POSTHandle:MKURL(Found, URL_GET_USER_PAY_CHECKPROOF) head:nil parameters:param progress:nil success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
    //
    //        NSDictionary * dic;
    //        if ([responseObject isKindOfClass:[NSDictionary class]] == YES) {
    //            dic = responseObject;
    //        }else{
    //           dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //        }
    //        if ([ModelTool checkResponseObject:dic]){
    //            NSDictionary *dataDic = dic[DATAS][DATAS];
    //
    //           if (call) call(dataDic);
    //        } else {
    //           if (call) call(nil);
    //        }
    //
    //    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
    //        NSLog(@"error : %@", error);
    //        call(nil);
    //    }];
    //
    
    
    [SLRequest postHttpRequestWithApi:URL_GET_USER_PAY_CHECKPROOF parameters:param success:^(NSDictionary * _Nullable resultDic) {
        
    } failure:^(NSString * _Nullable errorReason) {
        
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        NSDictionary *dic = resultDic;
        if ([ModelTool checkResponseObject:dic]){
            NSDictionary *dataDic = dic[DATAS][DATAS];
            
            if (call) call(dataDic);
        } else {
            if (call) call(nil);
        }
    }];
    
}


-(void)getUserInfoWithOrderCode:(NSString *)orderCode callback:(NSDictionaryCallBack)call {
    
    //    [[NetworkingHandler sharedInstance] POSTHandle:MKURL(Found, KungFu_OrderDetailUserInfo) head:nil parameters:@{@"orderCode":orderCode} progress:nil success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
    //
    //        NSDictionary * dic;
    //        if ([responseObject isKindOfClass:[NSDictionary class]] == YES) {
    //            dic = responseObject;
    //        }else{
    //           dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //        }
    //        if ([ModelTool checkResponseObject:dic]){
    //            NSDictionary *dataDic = dic[DATAS];
    //
    //           if (call) call(dataDic);
    //        } else {
    //           if (call) call(nil);
    //        }
    //
    //    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
    //        NSLog(@"error : %@", error);
    //        call(nil);
    //    }];
    //
    
    [SLRequest postHttpRequestWithApi:KungFu_OrderDetailUserInfo parameters:@{@"orderCode":orderCode} success:^(NSDictionary * _Nullable resultDic) {
        
    } failure:^(NSString * _Nullable errorReason) {
        
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        NSDictionary *dic = resultDic;
        if ([ModelTool checkResponseObject:dic]){
            NSDictionary *dataDic = dic[DATAS];
            
            if (call) call(dataDic);
        } else {
            if (call) call(nil);
        }
    }];
    
}

-(void)getVideoAuthWithVideoId:(NSString *)videoId callback:(NSDictionaryCallBack)call
{
    //    [self.manager GET:MKURL(Found, KungFu_VideoAuth) parameters:@{@"vodid":videoId} headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //
    //        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //        if ([ModelTool checkResponseObject:dic]){
    //            NSDictionary *dataDic = dic[DATAS];
    //
    //           if (call) call(dataDic[DATAS]);
    //        } else {
    //           if (call) call(nil);
    //        }
    //
    //    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        NSLog(@"error : %@", error);
    //        if (call) call(nil);
    //    }];
    
    [SLRequest getRequestWithApi:KungFu_VideoAuth parameters:@{@"vodid":videoId} success:^(NSDictionary * _Nullable resultDic) {
        
    } failure:^(NSString * _Nullable errorReason) {
        
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        NSDictionary * dic = resultDic;
        if ([ModelTool checkResponseObject:dic]){
            NSDictionary *dataDic = dic[DATAS];
            
            if (call) call(dataDic[DATAS]);
        } else {
            if (call) call(nil);
        }
    }];
    
}


///获取 学历数组
-(void)getEducationDataCallback:(NSArrayCallBack)call{
    
    //    [[NetworkingHandler sharedInstance] POSTHandle:MKURL(Found, COMMON_EDUCATIONDATA) head:nil parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
    //
    //        NSDictionary * dic;
    //        if ([responseObject isKindOfClass:[NSDictionary class]] == YES) {
    //            dic = responseObject;
    //        }else{
    //            dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //        }
    //        if ([ModelTool checkResponseObject:dic]){
    //            NSDictionary *dataDic = dic[DATAS];
    //
    //            NSArray *dataArray = [DegreeNationalDataModel mj_objectArrayWithKeyValuesArray: dataDic[DATAS]];
    //
    //            if (call) call(dataArray);
    //        } else {
    //            if (call) call(nil);
    //        }
    //
    //
    //    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
    //        NSLog(@"error : %@", error);
    //        call(nil);
    //    }];
    //
    
    
    [SLRequest postHttpRequestWithApi:COMMON_EDUCATIONDATA parameters:@{} success:^(NSDictionary * _Nullable resultDic) {
        
    } failure:^(NSString * _Nullable errorReason) {
        
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        NSDictionary *dic = resultDic;
        if ([ModelTool checkResponseObject:dic]){
            NSDictionary *dataDic = dic[DATAS];
            
            NSArray *dataArray = [DegreeNationalDataModel mj_objectArrayWithKeyValuesArray: dataDic[DATAS]];
            
            if (call) call(dataArray);
        } else {
            if (call) call(nil);
        }
    }];
    
    
}

///获取 民族数组
-(void)getNationDataCallback:(NSArrayCallBack)call{
    
    //    [[NetworkingHandler sharedInstance] POSTHandle:MKURL(Found, COMMON_NATIONDATA) head:nil parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nullable task, id  _Nullable responseObject) {
    //
    //        NSDictionary * dic;
    //        if ([responseObject isKindOfClass:[NSDictionary class]] == YES) {
    //            dic = responseObject;
    //        }else{
    //            dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
    //        }
    //        if ([ModelTool checkResponseObject:dic]){
    //            NSDictionary *dataDic = dic[DATAS];
    //
    //            NSArray *dataArray = [DegreeNationalDataModel mj_objectArrayWithKeyValuesArray: dataDic[DATAS]];
    //
    //            if (call) call(dataArray);
    //        } else {
    //            if (call) call(nil);
    //        }
    //
    //
    //    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nullable error) {
    //        NSLog(@"error : %@", error);
    //        call(nil);
    //    }];
    //
    
    [SLRequest postHttpRequestWithApi:COMMON_NATIONDATA parameters:@{} success:^(NSDictionary * _Nullable resultDic) {
        
    } failure:^(NSString * _Nullable errorReason) {
        
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        NSDictionary *dic = resultDic;
        if ([ModelTool checkResponseObject:dic]){
            NSDictionary *dataDic = dic[DATAS];
            
            NSArray *dataArray = [DegreeNationalDataModel mj_objectArrayWithKeyValuesArray: dataDic[DATAS]];
            
            if (call) call(dataArray);
        } else {
            if (call) call(nil);
        }
    }];
}

/// 获取 公告列表
-(void)getActivityAnnouncement:(NSDictionary *)param Callback:(NSDictionaryCallBack)call{
    [SLRequest postHttpRequestWithApi:ACTIVITY_ANNOINCEMENT parameters:param success:^(NSDictionary * _Nullable resultDic) {
        
    } failure:^(NSString * _Nullable errorReason) {
        
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        NSDictionary *dic = resultDic;
        if ([ModelTool checkResponseObject:dic]){
            NSDictionary *dataDic = dic[DATAS];
            
            NSArray *dataArray = [ExamNoticeModel mj_objectArrayWithKeyValuesArray: dataDic[DATAS]];
            
            NSMutableDictionary *resulrMutableDic = [NSMutableDictionary dictionary];
            [resulrMutableDic setValue:dataArray forKey:@"dataArray"];
            [resulrMutableDic setValue:dataDic[@"total"] forKey:@"total"];

            if (call) call(resulrMutableDic);
        } else {
            if (call) call(nil);
        }
    }];
}

/// 标记已读
-(void)activityAnnouncementMarkRead:(NSDictionary *)param Callback:(MessageCallBack)call{
    [SLRequest postHttpRequestWithApi:ACTIVITY_ANNOINCEMENTMARKREAD parameters:param success:^(NSDictionary * _Nullable resultDic) {
        
    } failure:^(NSString * _Nullable errorReason) {
        
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        if (call) call(nil);
    }];
}

-(void)activityAnnouncementUnReadNumberCallback:(NSDictionaryCallBack)call{
    [SLRequest postHttpRequestWithApi:ACTIVITY_ANNOINCEMENTUNREADNUMBER parameters:@{} success:^(NSDictionary * _Nullable resultDic) {
        
    } failure:^(NSString * _Nullable errorReason) {
        
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        NSDictionary *dic = resultDic;
        if ([ModelTool checkResponseObject:dic]){
            NSDictionary *dataDic = dic[DATAS];
            if (call) call(dataDic);
        } else {
            if (call) call(nil);
        }
    }];
}

- (void)getSubjectList:(NSDictionary *)params success:(SLSuccessDicBlock)success failure:(SLFailureReasonBlock)failure finish:(SLFinishedResultBlock)finish {
    
    
    [SLRequest postJsonRequestWithApi:Kungfu_SubjectList parameters:params success:success failure:failure finish:finish];
}


@end
