//
//  KungfuExamNoticeViewController.m
//  Shaolin
//
//  Created by ws on 2020/9/7.
//  Copyright © 2020 syqaxldy. All rights reserved.
// 考点公告

#import "KungfuExamNoticeViewController.h"

#import "KungfuExamNoticeTabelHeardView.h"

#import "KungfuExamNoticeTableViewCell.h"

#import "MutableCopyCatetory.h"

#import "KungfuManager.h"

#import "NSString+Size.h"

#import "ExamNoticeModel.h"

@interface KungfuExamNoticeViewController ()<UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

@property(nonatomic, strong)UITableView *tableView;

@property(nonatomic, strong)NSMutableArray *dataArray;

@property(nonatomic, assign)NSInteger pageNmuber;

@end

@implementation KungfuExamNoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
    [self initDate];
}

-(void)initDate{
    
    self.pageNmuber = 1;
    
    [[KungfuManager sharedInstance]getActivityAnnouncement:@{@"pageSize":@"10", @"pageNum":[NSString stringWithFormat:@"%ld", self.pageNmuber]} Callback:^(NSDictionary *result) {
        [self.dataArray addObjectsFromArray:result[@"dataArray"]];
        [self.tableView reloadData];
        NSInteger  total = [result[@"total"] integerValue];
        
        if (total <= [self.dataArray count]) {
            [self.tableView.mj_footer setHidden:YES];
        }
    }];
}

-(void)refreshData{
    self.pageNmuber = 1;
    [self.dataArray removeAllObjects];
    [[KungfuManager sharedInstance]getActivityAnnouncement:@{@"pageSize":@"10", @"pageNum":[NSString stringWithFormat:@"%ld", self.pageNmuber]} Callback:^(NSDictionary *result) {
        
        [self.dataArray addObjectsFromArray:result[@"dataArray"]];
        [self.tableView reloadData];
        
        [self.tableView.mj_header endRefreshing];
        
        [self.tableView.mj_footer resetNoMoreData];
        
        NSInteger  total = [result[@"total"] integerValue];
        if (total <= [self.dataArray count]) {
            [self.tableView.mj_footer setHidden:YES];
        }
    }];
}

-(void)loadingMoreData{
    [[KungfuManager sharedInstance]getActivityAnnouncement:@{@"pageSize":@"10", @"pageNum":[NSString stringWithFormat:@"%ld", self.pageNmuber]} Callback:^(NSDictionary *result) {
        
        [self.dataArray addObjectsFromArray:result[@"dataArray"]];
        [self.tableView reloadData];
        NSInteger  total = [result[@"total"] integerValue];
        
        [self.tableView.mj_footer endRefreshing];
        if (total <= [self.dataArray count]) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    }];
}

-(void)initUI{
    [self.titleLabe setText:@"考点公告"];
    
    [self.rightBtn setTitle:@"标为已读" forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:kMainYellow forState:UIControlStateNormal];
    [self.rightBtn.titleLabel setFont:kRegular(14)];
    
    [self.rightBtn addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.mas_equalTo(self.view);
    }];
}

#pragma mark - Action
-(void)rightAction{
    NSLog(@"%s", __func__);
    
    [[KungfuManager sharedInstance]activityAnnouncementMarkRead:@{} Callback:^(Message *message) {
        for (ExamNoticeModel *noticeModel in self.dataArray) {
            noticeModel.ifRead = @"1";
        }
        [self.tableView reloadData];
    }];
}

#pragma mark - DZNEmptyDataSetDelegate && dataSource
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    
    return !self.dataArray.count;
}

-(CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return -30;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = SLLocalizedString(@"暂无公告");
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:15.0f],
                                 NSForegroundColorAttributeName: [UIColor hexColor:@"999999"]};
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"categorize_nogoods"];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource
//组头高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 48;
}
//组尾高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}
//组头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    static NSString *hIdentifier = @"hIdentifier";
    
    UITableViewHeaderFooterView *view= [tableView dequeueReusableHeaderFooterViewWithIdentifier:hIdentifier];
    KungfuExamNoticeTabelHeardView *headView;
    
    if(view == nil){
        view = [[UITableViewHeaderFooterView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 48)];
        headView = [[KungfuExamNoticeTabelHeardView alloc]initWithFrame:view.bounds];
        [view.contentView addSubview:headView];
    }
    ExamNoticeModel *noticeModel = [self.dataArray objectAtIndex:section];
    [headView setTitleStr:noticeModel.title];
    
    [headView setSection:section];
    
    [headView setModel:noticeModel];
    
    [headView setExamNoticeTabletActionBclok:^(NSInteger itemSection) {
        ExamNoticeModel *noticeModel = [self.dataArray objectAtIndex:itemSection];
        noticeModel.isSelected = !noticeModel.isSelected;
        
        if([noticeModel.ifRead boolValue] == NO){
            [[KungfuManager sharedInstance]activityAnnouncementMarkRead:@{@"announcementId" : noticeModel.examNoticeModelID} Callback:^(Message *message) {
                noticeModel.ifRead = @"1";
            }];
        }
        
        NSRange range = NSMakeRange(itemSection, 1);
        NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
        [tableView reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationAutomatic];
        
      
    }];
    
    return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.dataArray count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    ExamNoticeModel *noticeModel = [self.dataArray objectAtIndex:section];
    if (noticeModel.isSelected) {
        return 1;
    }else{
        return 0;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    
    ExamNoticeModel *noticeModel = [self.dataArray objectAtIndex:indexPath.section];
    
   
    NSString *contentStr = noticeModel.content;
    
     CGFloat height = [contentStr textSizeWithFont:kRegular(15) numberOfLines:0 constrainedWidth:(ScreenWidth - 32)].height+12;
     
     return height > 156 ? height : 156;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell;
    
    ExamNoticeModel *noticeModel = [self.dataArray objectAtIndex:indexPath.section];
     NSString *contentStr = noticeModel.content;
    KungfuExamNoticeTableViewCell *detailCell = [tableView dequeueReusableCellWithIdentifier:@"KungfuExamNoticeTableViewCell"];
    [detailCell setDetailsStr:contentStr];
    cell = detailCell;
    
    [cell setSelectionStyle:(UITableViewCellSelectionStyleNone)];
    
    return cell;
}



#pragma mark - getter / setter
-(UITableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        
        
         [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([KungfuExamNoticeTableViewCell class])bundle:nil] forCellReuseIdentifier:@"KungfuExamNoticeTableViewCell"];
        
        MJRefreshNormalHeader *headerView = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self refreshData];
        }];
        
        _tableView.mj_header = headerView;
        
        
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            self.pageNmuber ++;
            [self loadingMoreData];
        }];
        
    }
    return _tableView;
}

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
        
    }
    return _dataArray;
}




@end
