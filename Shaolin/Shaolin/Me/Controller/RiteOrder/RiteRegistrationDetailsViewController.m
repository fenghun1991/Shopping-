//
//  RiteRegistrationDetailsViewController.m
//  Shaolin
//
//  Created by 郭超 on 2020/7/29.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RiteRegistrationDetailsViewController.h"
#import "KungfuWebViewController.h"

#import "ApplyListModel.h"

#import "ActivityManager.h"
#import "DefinedHost.h"
#import "NSString+Size.h"

#import "RiteRegistrationDetailsModel.h"

#import "RiteRegistrationDetailTableViewCell.h"

#import "RiteContactInformationTableViewCell.h"

@interface RiteRegistrationDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) RiteRegistrationDetailsModel * detailModel;

//@property (nonatomic, strong) NSArray * titleList;
@property (nonatomic, strong) NSMutableArray * titleList;
@property (nonatomic, strong) NSMutableArray * contentList;

@property (nonatomic, strong) UIView * tableFooterView;

@end

@implementation RiteRegistrationDetailsViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    [self requestApplyDetailInfo];
}

-(void) initUI
{
    self.titleLabe.text = @"报名详情";
    self.view.backgroundColor = [UIColor hexColor:@"FAFAFA"];
    self.tableView.hidden = YES;
    
    [self.view addSubview:self.tableView];
}

- (void)activityDetail
{
    NSString *url;
    
    NSString *token = [SLAppInfoModel sharedInstance].access_token;
    
    
     //1:水路法会 2 普通法会 3 全年佛事 4 建寺安僧
    NSInteger pujaType = [self.detailModel.pujaType integerValue];
    
    if (pujaType == 4) {
        url = URL_H5_RiteBuild(self.detailModel.pujaType, self.detailModel.pujaCode, token);
    }else{
        url = URL_H5_RiteSL(self.detailModel.pujaType, self.detailModel.pujaCode, token);
    }
    
    
    KungfuWebViewController *webVC = [[KungfuWebViewController alloc] initWithUrl:url type:KfWebView_activityDetail];
    [self.navigationController pushViewController:webVC animated:YES];
}


- (void) requestApplyDetailInfo {
    MBProgressHUD * hud = [ShaolinProgressHUD defaultLoadingWithText:@"加载中"];
    
    [[ActivityManager sharedInstance]postRiteRegistrationDetails:@{@"orderCode":self.orderCode} Success:^(NSDictionary * _Nullable resultDic) {
        
        NSLog(@"resultDic : %@", resultDic);
        
        RiteRegistrationDetailsModel *model = [RiteRegistrationDetailsModel mj_objectWithKeyValues:resultDic];
        
        [self.titleList addObject:[self getFormattingString:@"活动标题"]];
        
         [self.titleList addObject:[self getFormattingString:@"类型"]];
        
        
        if (model.buddhismStartTime.length && model.buddhismEndTime.length) {
            [self.titleList addObject:[self getFormattingString:@"佛事日期"]];
        }
        
        if (model.actuallyPaidMoney.length) {
            [self.titleList addObject:[self getFormattingString:@"功德金"]];

        }
        
        if (model.dateOfDeath.length && model.superName.length) {
            
            [self.titleList addObject:[self getFormattingString:@"超度者姓名"]];
            [self.titleList addObject:[self getFormattingString:@"超度者出生日期"]];
            [self.titleList addObject:[self getFormattingString:@"超度者死亡日期"]];
            [self.titleList addObject:[self getFormattingString:@"阳上人姓名"]];
            
            
          
        }
        
        if (model.disasterName.length) {
            [self.titleList addObject:[self getFormattingString:@"消灾者姓名"]];

        }
        
        [self.titleList addObject:[self getFormattingString:@"斋主姓名"]];

        
        if (model.greetings.length ) {
            [self.titleList addObject:[self getFormattingString:@"祝福语"]];
        }
        
        [self.titleList addObject:[self getFormattingString:@"联系电话"]];
        [self.titleList addObject:[self getFormattingString:@"联系地址"]];
        [self.titleList addObject:[self getFormattingString:@"联系方式"]];
        
        if (model.lordNeeds.length) {
            [self.titleList addObject:[self getFormattingString:@"斋主需求"]];
        }
        
        self.detailModel = model;
        
    } failure:^(NSString * _Nullable errorReason) {
        
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        [hud hideAnimated:YES];
    }];
}

#pragma mark - delegate && dataSources

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.contentList) {
        return 0;
    }
    return self.titleList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * titleStr = self.titleList[indexPath.row];
    UITableViewCell *cell;
    if ([titleStr isEqualToString:@"联系方式："]) {
        RiteContactInformationTableViewCell *informationCell = [tableView dequeueReusableCellWithIdentifier:@"RiteContactInformationTableViewCell"];
        if (indexPath.row < self.contentList.count) {
            NSString * contentStr = self.contentList[indexPath.row];
            if (NotNilAndNull(contentStr)) {
                [informationCell setTitleStr:titleStr];
                [informationCell setContentStr:contentStr];
            }
        }
        cell = informationCell;
        
    }else{
        RiteRegistrationDetailTableViewCell *detailCell = [tableView dequeueReusableCellWithIdentifier:@"RiteRegistrationDetailTableViewCell"];
        
        
        if (indexPath.row < self.contentList.count) {
            NSString * contentStr = self.contentList[indexPath.row];
            if (NotNilAndNull(contentStr)) {
                [detailCell setTitleStr:titleStr];
                [detailCell setContentStr:contentStr];
            }
        }
        
        cell = detailCell;
    }
    
    
    [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *titleStr = self.titleList[indexPath.row];
    NSString *contentStr = self.contentList[indexPath.row];

    if([titleStr containsString:SLLocalizedString(@"联系地址")] ||[titleStr containsString:SLLocalizedString(@"斋主需求")]){
      CGFloat height =  [contentStr textSizeWithFont:kRegular(15)
        constrainedToSize:CGSizeMake(ScreenWidth - 90 - 30 -16, CGFLOAT_MAX)
            lineBreakMode:NSLineBreakByWordWrapping].height +14;
        
        return height;
    }
    if ([titleStr containsString:SLLocalizedString(@"超度者出生日期")] || [titleStr containsString:SLLocalizedString(@"超度者死亡日期")] ) {
        return 57;
    }
    
    if ([titleStr containsString:SLLocalizedString(@"联系方式")]) {
        return 75;
    }
    
    return 35;
}


#pragma mark - setter && getter
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 15, kWidth, kHeight - NavBar_Height - 15) style:(UITableViewStylePlain)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = UIColor.clearColor;
        
        
        _tableView.tableFooterView = self.tableFooterView;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RiteRegistrationDetailTableViewCell class])bundle:nil] forCellReuseIdentifier:@"RiteRegistrationDetailTableViewCell"];
        
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RiteContactInformationTableViewCell class])bundle:nil] forCellReuseIdentifier:@"RiteContactInformationTableViewCell"];
        
    }
    return _tableView;
}

-(void)setDetailModel:(RiteRegistrationDetailsModel *)detailModel {
    
    _detailModel = detailModel;
    //1:水路法会 2 普通法会 3 全年佛事 4 建寺安僧
    //    NSInteger pujaType = [detailModel.pujaType integerValue];
    NSString *classificationStr = detailModel.puJaClassificationName;
    
    [self.contentList addObject:[self getNotNilString:detailModel.pujaName]];
    [self.contentList addObject:classificationStr];
    
    if (detailModel.buddhismStartTime.length && detailModel.buddhismEndTime.length) {
        [self.contentList addObject:[NSString stringWithFormat:@"%@ - %@", detailModel.buddhismStartTime, detailModel.buddhismEndTime]];
    }
    
    if (detailModel.actuallyPaidMoney.length) {
        NSString *actuallyPaidMoney =  [self getNotNilString:detailModel.actuallyPaidMoney];
        [self.contentList addObject:[NSString stringWithFormat:@"%.2f元", [actuallyPaidMoney floatValue]]];
    }
    
    if (detailModel.dateOfDeath.length && detailModel.superName.length) {
        
        
        [self.contentList addObject:[self getNotNilString:detailModel.superName]];
        [self.contentList addObject:[self getNotNilString:detailModel.birthDate]];
        [self.contentList addObject:[self getNotNilString:detailModel.dateOfDeath]];
        [self.contentList addObject:[self getNotNilString:detailModel.liveName]];
    }
    
    if (detailModel.disasterName.length) {
        [self.contentList addObject:[self getNotNilString:detailModel.disasterName]];
    }
    
    [self.contentList addObject:[self getNotNilString:detailModel.zhaizhuName]];
    
    if (detailModel.greetings.length ) {
        [self.contentList addObject:[self getNotNilString:detailModel.greetings]];
    }
    [self.contentList addObject:[self getNotNilString:detailModel.contactNumber]];
    [self.contentList addObject:[self getNotNilString:detailModel.contactAddress]];
    [self.contentList addObject:[NSString stringWithFormat:@"%@|%@", detailModel.puJaContactPerson, detailModel.puJaContactPhone]];
    
    if (detailModel.lordNeeds.length) {
        [self.contentList addObject:[self getNotNilString:detailModel.lordNeeds]];
    }
    
    
    self.tableView.hidden = NO;
    
    [self.tableView reloadData];
}

-(NSString *)getNotNilString:(NSString *)text {
    return NotNilAndNull(text)?text:@"";
}

-(NSString *)getFormattingString:(NSString *)text {
    return [NSString stringWithFormat:@"%@：", SLLocalizedString(text)];
}


-(NSString *)getTimeString:(NSString *)startTime endTime:(NSString *)endTime
{
    
    NSString * result = @"";
    
    NSString * startTimeStr = [self getNotNilString:startTime];
    startTimeStr = [[startTimeStr componentsSeparatedByString:@" "] firstObject];
    startTimeStr = [startTimeStr stringByReplacingOccurrencesOfString:@"-" withString:@"."];
    result = startTimeStr;
    
    if (endTime.length > 0) {
        NSString * endTimeStr = [self getNotNilString:endTime];
        endTimeStr = [[endTimeStr componentsSeparatedByString:@" "] firstObject];
        endTimeStr = [endTimeStr stringByReplacingOccurrencesOfString:@"-" withString:@"."];
        
        result = [NSString stringWithFormat:@"%@-%@", startTimeStr, endTimeStr];
    }
    
    return result;
}

-(NSArray *)titleList {
    if (!_titleList) {
        _titleList = [NSMutableArray array];
        
    }
    return _titleList;
}

-(NSMutableArray *)contentList {
    if (!_contentList) {
        _contentList = [NSMutableArray new];
    }
    return _contentList;
}

-(UIView *)tableFooterView {
    if (!_tableFooterView) {
        _tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
        
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(17,10,80,21);
        label.text = [self getFormattingString:@"法会详情"];
        label.textColor = [UIColor hexColor:@"333333"];
        label.font = kRegular(15);
        
        [_tableFooterView addSubview:label];
        
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(label.right+15, 6, 85, 28)];
        
        [button setTitle:SLLocalizedString(@"查看详情") forState:UIControlStateNormal];
        
        
        [button setTitleColor:[UIColor hexColor:@"8E2B25"] forState:UIControlStateNormal];
        button.titleLabel.font = kRegular(15);
        button.layer.borderWidth = 0.5f;
        button.layer.borderColor = [UIColor hexColor:@"8E2B25"].CGColor;
        button.layer.cornerRadius = 14;
        [button addTarget:self action:@selector(activityDetail) forControlEvents:UIControlEventTouchUpInside];
        
        [_tableFooterView addSubview:button];
    }
    return _tableFooterView;
}

#pragma mark - device
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

@end
