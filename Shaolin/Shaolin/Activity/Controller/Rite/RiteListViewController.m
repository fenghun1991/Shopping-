//
//  RiteListViewController.m
//  Shaolin
//
//  Created by ws on 2020/7/21.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RiteListViewController.h"
#import "RiteRegistrationFormViewController.h"
#import "KungfuWebViewController.h"

#import "WengenBannerModel.h"
#import "RiteModel.h"
#import "ActivityManager.h"
#import "DefinedHost.h"

#import "KungfuHomeBannerCell.h"
#import "RiteMarqueeCell.h"
#import "RiteJoinCell.h"
#import "RiteCell.h"
#import "RiteFilterCell.h"

#import "RiteModel.h"

#import "SLDateRangeView.h"
#import "SLRiteFilterView.h"
#import "NSDate+BRPickerView.h"
#import "NSDate+LGFDate.h"

#import "RiteRegistrationFormViewController.h"

#import "RitePastListViewController.h"

static NSString *const filterCellId = @"RiteFilterCell";
static NSString *const bannerCellId = @"KungfuHomeBannerCell";
static NSString *const marqueeCellId = @"RiteMarqueeCell";
static NSString *const joinCellId = @"RiteJoinCell";
static NSString *const riteCellId = @"RiteCell";

static NSInteger bannerIndex = 0;
static NSInteger marqueeIndex = 1;
static NSInteger longRiteJoinIndex = 2;
static NSInteger filterIndex = 3;
static NSInteger riteIndex = 4;

@interface RiteListViewController () <UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource,UIScrollViewDelegate>

@property (nonatomic, strong) UITableView   * homeTableView;

@property (nonatomic, strong) NSArray * bannerList;
@property (nonatomic, strong) NSArray * marqueeList;
@property (nonatomic, strong) NSMutableArray * riteList;

@property (nonatomic, strong) SLDateRangeView * dateRangeView;
//@property (nonatomic, strong) SLRiteFilterView * filterView;

@property (nonatomic, copy) NSString * timeRangeStr;
@property (nonatomic, copy) NSString * typeStr;

@property (nonatomic, assign) CGFloat tableOffsetY;

@property (nonatomic, copy) NSString * startYear;
@property (nonatomic, copy) NSString * startMonth;
@property (nonatomic, copy) NSString * endYear;
@property (nonatomic, copy) NSString * endMonth;

@property (nonatomic, strong) NSMutableArray * yearsRange;
@property (nonatomic, assign) NSInteger pageNum;
@end

@implementation RiteListViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
    self.navigationController.navigationBar.hidden = YES;
    [self.homeTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageNum = 1;
    
    [self initUI];
    
    [self requestBanner];
    [self requestMarquee];
    [self requestRiteList];
    [self requestTimeRange];
}


- (void) initUI {
    
    [self.view addSubview:self.homeTableView];
    
    [self.homeTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(self.view);
    }];
}

- (void)setShowMarquee:(BOOL)isShowMarquee{
    if (isShowMarquee){
        bannerIndex = 0;
        marqueeIndex = 1;
        longRiteJoinIndex = 2;
        filterIndex = 3;
        riteIndex = 4;
    } else {
        bannerIndex = 0;
        marqueeIndex = 1e6;
        longRiteJoinIndex = 1;
        filterIndex = 2;
        riteIndex = 3;
    }
}
#pragma mark - request

- (void)requestBanner {
    
    [[DataManager shareInstance] getBanner:@{@"module":@"4", @"fieldId":@"-1"} Callback:^(NSArray *result) {
        self.bannerList = [NSArray arrayWithArray:result];
        [self.homeTableView reloadData];
    }];
}

- (void)requestMarquee {
    self.marqueeList = @[];
    [ActivityManager getMarqueeList:^(NSDictionary * _Nullable resultDic) {
        NSArray *array = (NSArray *)resultDic;
        if (array && [array isKindOfClass:[NSArray class]]) {
            self.marqueeList = [WengenBannerModel mj_objectArrayWithKeyValuesArray:array];
            [self setShowMarquee:YES];
        } else {
            [self setShowMarquee:NO];
        }
        [self.homeTableView reloadData];
    } failure:^(NSString * _Nullable errorReason) {
        [self setShowMarquee:NO];
        [self.homeTableView reloadData];
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        
    }];
}

- (void)requestTimeRange {
    [ActivityManager getRiteRangeAndsuccess:^(NSDictionary * _Nullable resultDic) {
        
        int startDate = [resultDic[@"initialTime"] intValue];
        int endDate = [resultDic[@"endingTime"] intValue];
        if (!startDate) {
            startDate = [self.startYear intValue];
        }
        if (!endDate) {
            endDate = startDate + 2;
        }
        [self.yearsRange removeAllObjects];
        
        for (int i = startDate; i <= endDate; i++) {
            [self.yearsRange addObject:[NSString stringWithFormat:@"%d",i]];
        }
        
    } failure:^(NSString * _Nullable errorReason) {
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
    }];
}

- (void)requestRiteList {
    
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];

    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:@{
        @"pageSize":@(30),
        @"pageNum":@(self.pageNum)
    }];
    
    if (self.startYear && self.startMonth && self.endYear && self.endMonth) {
        NSString * startDate = [NSString stringWithFormat:@"%@-%@",self.startYear,[self converWithMonth:self.startMonth]];
        NSString * endDate = [NSString stringWithFormat:@"%@-%@",self.endYear,[self converWithMonth:self.endMonth]];
        [params setValue:startDate forKey:@"startDate"];
        [params setValue:endDate forKey:@"endDate"];
    }
    
    NSString * typeCode = @"";
    if (self.typeStr && ![self.typeStr isEqualToString:@"全部"]) {
        if ([self.typeStr isEqualToString:@"近期"]) {
            typeCode = @"1";
        }
        if ([self.typeStr isEqualToString:@"往期"]) {
            typeCode = @"2";
        }
        [params setValue:typeCode forKey:@"type"];
    }
    
    [ActivityManager getRiteListWithParams:params success:^(NSDictionary * _Nullable resultDic) {
        
        NSArray * data = resultDic[@"data"];
        NSArray * dataList = [RiteModel mj_objectArrayWithKeyValuesArray:data];
        
        [self.riteList addObjectsFromArray:dataList];
        [self.homeTableView reloadData];
        
    } failure:^(NSString * _Nullable errorReason) {
        
        [ShaolinProgressHUD singleTextAutoHideHud:errorReason];
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        [hud hideAnimated:YES];
        [self.homeTableView.mj_header endRefreshing];
        [self.homeTableView.mj_footer endRefreshing];
    }];
}

- (void)reloadTimeRange {
    
    /*
        时间范围在选择时，时间按钮上的文字实时改变
        时间选择器收起时，如果开始时间大于结束时间，时间按钮上的文字就调换
     */
    RiteFilterCell * filterCell = [self.homeTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:filterIndex]];
    
    if ([self.startYear intValue] > [self.endYear intValue]) {
        // 开始年份大于结束年份，调换年月
        NSString * tempYear = self.endYear;
        self.endYear = self.startYear;
        self.startYear = tempYear;
        
        NSString * tempMonth = self.endMonth;
        self.endMonth = self.startMonth;
        self.startMonth = tempMonth;
    }
    if ([self.startYear intValue] == [self.endYear intValue]) {
        if ([self.startMonth intValue] > [self.endMonth intValue]) {
            // 年份相同，判断月份，调换月份
            NSString * temp = self.endMonth;
            self.endMonth = self.startMonth;
            self.startMonth = temp;
        }
    }
    [filterCell resetTimeBtn];

    self.timeRangeStr = [NSString stringWithFormat:@"%@.%@-%@.%@",self.startYear,[self converWithMonth:self.startMonth],self.endYear,[self converWithMonth:self.endMonth]];
    filterCell.timeRangeStr = self.timeRangeStr;
    
    [self.homeTableView.mj_header beginRefreshing];
}

#pragma mark - scrollerViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.tableOffsetY = scrollView.contentOffset.y;
}


- (void)pushRiteLongViewController{
    NSString *strState = [SLAppInfoModel sharedInstance].verifiedState;
    if (IsNilOrNull(strState) || [strState isEqualToString:@"0"] || [strState isEqualToString:@"3"]) {
        [ShaolinProgressHUD singleTextAutoHideHud:SLLocalizedString(@"您还没有实名认证，请前往\"我的\"进行实名认证")];
        return;
    }
    if ([strState isEqualToString:@"2"]) {
        [ShaolinProgressHUD singleTextAutoHideHud:SLLocalizedString(@"实名认证正在审核中，请耐心等待")];
        return;
    }
    
    RiteRegistrationFormViewController *vc = [[RiteRegistrationFormViewController alloc] init];
    vc.pujaType = @"3";
    
    NSDate *minDate = [NSDate date];
    NSDate *maxDate = [minDate lgf_DateByAddingYears:1];
    NSString *startTime = [NSDate br_stringFromDate:minDate dateFormat:@"yyyy-MM-dd"];;
    NSString *endTime = [NSDate br_stringFromDate:maxDate dateFormat:@"yyyy-MM-dd"];;
    
    vc.startTime = startTime;
    vc.endTime = endTime;
    
    vc = [RitePastListViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    
    
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - delegate && dataSources
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return riteIndex + 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == riteIndex) {
        return self.riteList.count;
    }
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WEAKSELF
    if (indexPath.section == bannerIndex) {
        KungfuHomeBannerCell * cell = [tableView dequeueReusableCellWithIdentifier:bannerCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.bannerList = self.bannerList;

        cell.bannerTapBlock = ^(NSInteger index) {
            WengenBannerModel *banner = weakSelf.bannerList[index];
            // banner事件
            [[SLAppInfoModel sharedInstance] bannerEventResponseWithBannerModel:banner];
        };
        
        return cell;
    }
    
    if (indexPath.section == marqueeIndex) {
        RiteMarqueeCell * cell = [tableView dequeueReusableCellWithIdentifier:marqueeCellId];
        cell.bannerTapBlock = ^(NSInteger index) {
            WengenBannerModel *banner = weakSelf.marqueeList[index];
            // banner事件
            [[SLAppInfoModel sharedInstance] bannerEventResponseWithBannerModel:banner];
        };
        cell.marqueeList = self.marqueeList;
        return cell;
    }
    
    if (indexPath.section == longRiteJoinIndex) {
        RiteJoinCell * cell = [tableView dequeueReusableCellWithIdentifier:joinCellId];
        cell.reservationHandleBlock = ^{
            [weakSelf pushRiteLongViewController];
        };
        cell.donateHandleBlock = ^{
//            [weakSelf ]
            NSLog(@"点击了功德募捐");
        };
        
        return cell;
    }
    
    if (indexPath.section == filterIndex) {
        RiteFilterCell * cell = [tableView dequeueReusableCellWithIdentifier:filterCellId];
        cell.timeRangeStr = self.timeRangeStr;
        cell.typeStr = self.typeStr;
        
        cell.timeFilterHandle = ^{
            
            CGRect rect = [weakSelf.homeTableView rectForRowAtIndexPath:indexPath];
            CGPoint pickerPoint = CGPointMake(rect.origin.x, rect.origin.y + 40 + NavBar_Height + 48 - self.tableOffsetY);
            
            weakSelf.dateRangeView.startYears = weakSelf.yearsRange;
            weakSelf.dateRangeView.endYears = weakSelf.yearsRange;
            [weakSelf.dateRangeView showWithPickerOrigin:pickerPoint
                                               startYear:weakSelf.startYear
                                              startMonth:weakSelf.startMonth
                                                 endYear:weakSelf.endYear
                                                endMonth:weakSelf.endMonth];
        };
        
        cell.stateFilterHandle = ^(NSString * _Nonnull typeStr) {
            if (![weakSelf.typeStr isEqualToString:typeStr]) {
                weakSelf.typeStr = typeStr;
                [weakSelf.homeTableView.mj_header beginRefreshing];
            }
        };

        return cell;
    }
    
    RiteCell * cell = [tableView dequeueReusableCellWithIdentifier:riteCellId];
    if (self.riteList.count) {
        RiteModel * model = self.riteList[indexPath.row];
        cell.cellModel = model;
        cell.positionType = RiteCellPositionCenter;
        
        if (indexPath.row == 0) {
            cell.positionType = RiteCellPositionFirst;
        }
        if (indexPath.row == self.riteList.count - 1) {
            cell.positionType = RiteCellPositionLast;
        }
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == marqueeIndex) {
//        [self.sexPickerView show];
//
//        RiteLongRegistrationFormViewController *vc = [[RiteLongRegistrationFormViewController alloc] init];
//        vc.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//
//    if (indexPath.section == longRiteJoinIndex) {
//        [self pushRiteLongViewController];
//    }
    
    if (indexPath.section == riteIndex) {
        
        RiteModel * model = self.riteList[indexPath.row];
        KungfuWebViewController *webVC;
        
        switch ([model.pujaType intValue]) {
            // 1:水路法会 2 普通法会 3 全年佛事 4 建寺安僧
            case 1:{
                webVC = [[KungfuWebViewController alloc] initWithUrl:URL_H5_RiteSL(model.pujaType, model.pujaCode, [SLAppInfoModel sharedInstance].access_token) type:KfWebView_rite];
                webVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:webVC animated:YES];
            }
                break;
            case 2:{
                webVC = [[KungfuWebViewController alloc] initWithUrl:URL_H5_RiteSL(model.pujaType, model.pujaCode, [SLAppInfoModel sharedInstance].access_token) type:KfWebView_rite];
                webVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:webVC animated:YES];
            }
                break;
            case 3:{
                [self pushRiteLongViewController];
            }
                break;
            case 4:{
                webVC = [[KungfuWebViewController alloc] initWithUrl:URL_H5_RiteBuild(model.pujaType, model.pujaCode, [SLAppInfoModel sharedInstance].access_token) type:KfWebView_rite];
                webVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:webVC animated:YES];
            }
                break;
            default:
                break;
        }
        
        if (webVC){
            [webVC hideWebViewScrollIndicator];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == bannerIndex) {
        return 154;
    }
    
    if (indexPath.section == marqueeIndex) {
        return 30;
    }
    
    if (indexPath.section == longRiteJoinIndex) {
        return 85;
    }
    
    if (indexPath.section == filterIndex) {
        return 40;
    }
    
    if (indexPath.section == riteIndex) {
        if (tableView.rowHeight < 102) {
            return 102;
        }
        return tableView.rowHeight;
    }
    return .001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (!self.riteList.count && section == riteIndex) {
        return 160;
    }
    return .001;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return .001;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (!self.riteList.count && section == riteIndex) {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 160)];
        
        UIImageView * imgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"categorize_nogoods"]];
        UILabel * label = [UILabel new];
        label.font = kMediumFont(15);
        label.textColor = [UIColor hexColor:@"333333"];
        label.text = @"暂无法会";
        
        [view addSubview:imgv];
        [view addSubview:label];
        
        [imgv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(view);
            make.size.mas_equalTo(CGSizeMake(60, 60));
        }];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(imgv);
            make.top.mas_equalTo(imgv.mas_bottom).mas_offset(10);
            make.height.mas_equalTo(20);
        }];
        return view;
        
    } else {
        return [UIView new];
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}


#pragma mark - getter && setter

-(UITableView *)homeTableView {
    WEAKSELF
    if (!_homeTableView) {
        _homeTableView = [[UITableView alloc]initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
        _homeTableView.delegate = self;
        _homeTableView.dataSource = self;
        _homeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _homeTableView.showsVerticalScrollIndicator = NO;
        _homeTableView.backgroundColor = UIColor.whiteColor;
                
        _homeTableView.emptyDataSetSource = self;
        _homeTableView.emptyDataSetDelegate = self;
        
        [_homeTableView registerNib:[UINib nibWithNibName:NSStringFromClass([RiteCell class]) bundle:nil] forCellReuseIdentifier:riteCellId];
        
        [_homeTableView registerClass:[KungfuHomeBannerCell class] forCellReuseIdentifier:bannerCellId];
        [_homeTableView registerClass:[RiteMarqueeCell class] forCellReuseIdentifier:marqueeCellId];
        [_homeTableView registerClass:[RiteJoinCell class] forCellReuseIdentifier:joinCellId];
        [_homeTableView registerClass:[RiteFilterCell class] forCellReuseIdentifier:filterCellId];
        
        _homeTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakSelf.pageNum = 1;
            [weakSelf.riteList removeAllObjects];
            [weakSelf requestRiteList];
        }];

        _homeTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            weakSelf.pageNum++;
            [weakSelf requestRiteList];
        }];
        
    }
    return _homeTableView;
}


-(NSMutableArray *)riteList {
    if (!_riteList) {
        _riteList = [NSMutableArray new];
    }
    return _riteList;
}

-(SLDateRangeView *)dateRangeView {
    WEAKSELF
    if (!_dateRangeView) {
        _dateRangeView = [[SLDateRangeView alloc] init];
//        _dateRangeView.changeBlock = ^(NSString * _Nonnull startYear, NSString * _Nonnull startMonth, NSString * _Nonnull endYear, NSString * _Nonnull endMonth) {
//
//            /*
//             滚动时不给self.startYear等属性赋值，只是改变时间范围按钮的文字
//             收起时才赋值并重新请求数据
//             */
//            RiteFilterCell * filterCell = [weakSelf.homeTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:filterIndex]];
//
//            weakSelf.timeRangeStr = [NSString stringWithFormat:@"%@.%@-%@.%@",startYear,[weakSelf converWithMonth:startMonth],endYear,[weakSelf converWithMonth:endMonth]];
//            filterCell.timeRangeStr = weakSelf.timeRangeStr;
//
//        };
        _dateRangeView.finishBlock = ^(NSString * _Nonnull startYear, NSString * _Nonnull startMonth, NSString * _Nonnull endYear, NSString * _Nonnull endMonth) {

            // 收起时
            if (![weakSelf.startYear isEqualToString:startYear]
                || ![weakSelf.startMonth isEqualToString:startMonth]
                || ![weakSelf.endYear isEqualToString:endYear]
                || ![weakSelf.endMonth isEqualToString:endMonth]) {
                
                weakSelf.startYear = startYear;
                weakSelf.startMonth = startMonth;
                weakSelf.endYear = endYear;
                weakSelf.endMonth = endMonth;
                
                [weakSelf reloadTimeRange];
            }
        };
    }
    return _dateRangeView;
}

//-(SLRiteFilterView *)filterView {
//    WEAKSELF
//    if (!_filterView) {
//        _filterView = [[SLRiteFilterView alloc] init];
//        _filterView.typeFilterHandle = ^(NSString * _Nonnull typeName) {
//
//            NSString * temp = weakSelf.typeStr;
//
//            weakSelf.typeStr = typeName;
//            [weakSelf.homeTableView reloadSections:[NSIndexSet indexSetWithIndex:filterIndex] withRowAnimation:UITableViewRowAnimationFade];
//
//            if (![temp isEqualToString:typeName]) {
//                [weakSelf.homeTableView.mj_header beginRefreshing];
//            }
//        };
//    }
//    return _filterView;
//}


//-(NSString *)timeRangeStr {
//    if (!_timeRangeStr) {
//        NSDateComponents *componentBegin = [self currentDateComponents];
//        _timeRangeStr = [NSString stringWithFormat:@"%d.01-%d.12",(int)componentBegin.year,(int)componentBegin.year];
//    }
//    return _timeRangeStr;
//}

-(NSString *)typeStr {
    if (!_typeStr) {
        _typeStr = @"近期";
    }
    return _typeStr;
}

//-(NSString *)startYear {
//    if (!_startYear) {
//        NSDateComponents *componentBegin = [self currentDateComponents];
//        _startYear = [NSString stringWithFormat:@"%d",(int)componentBegin.year];
//    }
//    return _startYear;
//}
//
//-(NSString *)startMonth {
//    if (!_startMonth) {
//        _startMonth = @"1";
//    }
//    return _startMonth;
//}
//
//-(NSString *)endYear {
//    if (!_endYear) {
//        NSDateComponents *componentBegin = [self currentDateComponents];
//        _endYear = [NSString stringWithFormat:@"%d",(int)componentBegin.year];
//    }
//    return _endYear;
//}
//
//-(NSString *)endMonth {
//    if (!_endMonth) {
//        _endMonth = @"12";
//    }
//    return _endMonth;
//}

-(NSMutableArray *)yearsRange {
    if (!_yearsRange) {
        _yearsRange = [NSMutableArray new];
    }
    return _yearsRange;
}

- (NSDateComponents *)currentDateComponents {
    return [[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:[NSDate date]];
}

- (NSString *)converWithMonth:(NSString *)month {
    // 如果月份少于10的话，拼个0，如01，02
    
    if ([month intValue] < 10) {
        return [NSString stringWithFormat:@"0%@",month];
    }
    return month;
}

@end
