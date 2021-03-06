//
//  MyRiteFinishedViewController.m
//  Shaolin
//
//  Created by ws on 2020/7/30.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "MyRiteFinishedViewController.h"
#import "MyRiteRegisteredCell.h"
#import "ActivityManager.h"
#import "MyRiteCellModel.h"
#import "RiteRegistrationDetailsViewController.h"

static NSString *const riteCellId = @"MyRiteRegisteredCell";

@interface MyRiteFinishedViewController () <UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property (nonatomic, strong) UITableView * infoTable;

@property (nonatomic, strong) NSMutableArray * riteList;

@property(nonatomic) NSInteger pageSize;
@property(nonatomic) NSInteger pageNum;

@end

@implementation MyRiteFinishedViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNavigationBarRedTintColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageSize = 10;
    self.pageNum = 1;
    [self.view addSubview:self.infoTable];
    
    [self loadData];
}

- (void)loadData{
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    
    NSDictionary *parames = @{@"type":@"2",
                              @"pageSize":@(self.pageSize),
                              @"pageNum":@(self.pageNum)
    };
    
    [ActivityManager getMyRiteListWithParams:parames success:^(NSDictionary * _Nullable resultDic) {
        
        NSArray * data = resultDic[@"data"];
        NSArray * dataList = [MyRiteCellModel mj_objectArrayWithKeyValuesArray:data];
        
        [self.riteList addObjectsFromArray:dataList];
        
        [self.infoTable.mj_header endRefreshing];
        [self.infoTable.mj_footer endRefreshing];
        [self.infoTable reloadData];
        
    } failure:^(NSString * _Nullable errorReason) {
        ;
    } finish:^(NSDictionary * _Nullable resultDic, NSString * _Nullable errorReason) {
        [hud hideAnimated:YES];
    }];

}

#pragma mark - DZNEmptyDataSetDelegate && dataSource
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    
    return !self.riteList.count;
}

-(CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -30;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"暂无参加法会";
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:15.0f],
                                 NSForegroundColorAttributeName: [UIColor hexColor:@"999999"]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"categorize_nogoods"];
}

#pragma mark - delegate && dataSources
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.riteList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyRiteRegisteredCell * cell = [tableView dequeueReusableCellWithIdentifier:riteCellId];
    
    MyRiteCellModel * model = self.riteList[indexPath.row];
    cell.riteModel = model;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyRiteCellModel * model = self.riteList[indexPath.row];
    
    RiteRegistrationDetailsViewController * vc = [RiteRegistrationDetailsViewController new];
    vc.orderCode = model.orderCode;
    [self.navigationController pushViewController:vc animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyRiteCellModel * model = self.riteList[indexPath.row];
    
    CGFloat top = 15;
    
    
    
    return 123;
}

- (UITableView *)infoTable {
    WEAKSELF
    if (!_infoTable) {
        _infoTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight - kNavBarHeight - kStatusBarHeight) style:(UITableViewStylePlain)];
        _infoTable.delegate = self;
        _infoTable.dataSource = self;
        _infoTable.backgroundColor = UIColor.whiteColor;
        
        _infoTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakSelf.pageNum = 1;
            [weakSelf.riteList removeAllObjects];
            [weakSelf loadData];
        }];

        _infoTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            weakSelf.pageNum++;
            [weakSelf loadData];
//            [weakSelf loadMoreData];
        }];
        
        
        _infoTable.emptyDataSetDelegate = self;
        _infoTable.emptyDataSetSource = self;
        
        [_infoTable registerNib:[UINib nibWithNibName:riteCellId bundle:nil] forCellReuseIdentifier:riteCellId];
        
        //self.tableView.backgroundColor = [UIColor whiteColor];
        _infoTable.separatorStyle = UITableViewCellSelectionStyleNone;
    }
    return _infoTable;
}

-(NSMutableArray *)riteList {
    if (!_riteList) {
        _riteList = [NSMutableArray new];
    }
    return _riteList;
}

@end
