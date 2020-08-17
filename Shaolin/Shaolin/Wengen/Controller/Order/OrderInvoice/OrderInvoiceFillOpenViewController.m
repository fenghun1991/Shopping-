//
//  OrderInvoiceFillOpenViewController.m
//  Shaolin
//
//  Created by 郭超 on 2020/6/8.
//  Copyright © 2020 syqaxldy. All rights reserved.
// 补开发票


#import "OrderInvoiceFillOpenViewController.h"

#import "MutableCopyCatetory.h"

#import "OrderInvoiceTableCell.h"

#import "OrderInvoicePopupView.h"

#import "OrderInvoiceFillModel.h"


@interface OrderInvoiceFillOpenViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong)UITableView *tableView;

@property(nonatomic, strong)UIView *bottomView;

@property(nonatomic, strong)NSMutableArray *dataArray;
@property(nonatomic, strong)NSArray *personalDataArray;
@property(nonatomic, strong)NSArray *enterpriseDataArray;

@property(nonatomic, strong)NSArray *ticketArray;

@property(nonatomic, strong)NSArray *registeredInfoArray;
///抬头类型 个人
@property(nonatomic, assign)BOOL isPersonal;
///抬头类型 企业
@property(nonatomic, assign)BOOL isCompany;
///发票形式 电子
@property(nonatomic, assign)BOOL isElectronic;
///发票形式 纸
@property(nonatomic, assign)BOOL isPaper;
///发票类型 普通
@property(nonatomic, assign)BOOL isOrdinary;
///发票类型 增值税专用发票
@property(nonatomic, assign)BOOL isSpecialInvoice;

@property(nonatomic, strong)OrderInvoiceFillModel *fillModel;

@end

@implementation OrderInvoiceFillOpenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initUI];
    
    [self initData];
}

-(void)initData{
    
    self.fillModel = [[OrderInvoiceFillModel alloc]init];
    
    self.fillModel.order_id = self.orderTotalSn;
    
    self.isPersonal = YES;
    self.isCompany = NO;
    self.isElectronic = YES;
    self.isPaper = NO;
    self.isOrdinary = YES;
    self.isSpecialInvoice = NO;
    
    //    NSArray *basecArray = @[
    //        @[
    //            @{@"title" : SLLocalizedString(@"订单编号"), @"content" : self.orderSn, @"isMore" : @"0", @"isEditor" : @"0", @"placeholder" : @""},
    //            @{@"title" : SLLocalizedString(@"发票形式"), @"content" : SLLocalizedString(@"电子发票"), @"isMore" : @"1", @"isEditor" : @"0", @"placeholder" : @""},
    //            @{@"title" : SLLocalizedString(@"发票类型"), @"content" : SLLocalizedString(@"普通发票"), @"isMore" : @"1", @"isEditor" : @"0", @"placeholder" : @""},
    //            @{@"title" : SLLocalizedString(@"发票内容"), @"content" : SLLocalizedString(@"商品明细"), @"isMore" : @"0", @"isEditor" : @"0", @"placeholder" : @""},
    //            @{@"title" : SLLocalizedString(@"抬头类型"), @"content" : SLLocalizedString(@"个人"), @"isMore" : @"1", @"isEditor" : @"0", @"placeholder" : @""},
    //            @{@"title" : SLLocalizedString(@"个人名称"), @"content" : @"", @"isMore" : @"0", @"isEditor" : @"1", @"placeholder" : SLLocalizedString(@"请输入个人名称")},
    //            @{@"title" : SLLocalizedString(@"补开费用"), @"content" : SLLocalizedString(@"到付"), @"isMore" : @"0", @"isEditor" : @"0", @"placeholder" : @""},
    //        ],
    //    ];
    //    self.dataArray = [basecArray mutableArrayDeeoCopy];
    //
    //    NSArray *enterpriseArray = @[
    //        @[
    //            @{@"title" : SLLocalizedString(@"订单编号"), @"content" : self.orderSn, @"isMore" : @"0", @"isEditor" : @"0", @"placeholder" : @""},
    //            @{@"title" : SLLocalizedString(@"发票形式"), @"content" : SLLocalizedString(@"电子发票"), @"isMore" : @"1", @"isEditor" : @"0", @"placeholder" : @""},
    //            @{@"title" : SLLocalizedString(@"发票类型"), @"content" : SLLocalizedString(@"普通发票"), @"isMore" : @"1", @"isEditor" : @"0", @"placeholder" : @""},
    //            @{@"title" : SLLocalizedString(@"发票内容"), @"content" : SLLocalizedString(@"商品明细"), @"isMore" : @"0", @"isEditor" : @"0", @"placeholder" : @""},
    //            @{@"title" : SLLocalizedString(@"抬头类型"), @"content" : SLLocalizedString(@"企业"), @"isMore" : @"1", @"isEditor" : @"0", @"placeholder" : @""},
    //            @{@"title" : SLLocalizedString(@"单位名称"), @"content" : @"", @"isMore" : @"0", @"isEditor" : @"1", @"placeholder" : SLLocalizedString(@"请输入单位名称")},
    //            @{@"title" : SLLocalizedString(@"单位税号"), @"content" : @"", @"isMore" : @"0", @"isEditor" : @"1", @"placeholder" : SLLocalizedString(@"请输入纳税人识别号")},
    //            @{@"title" : SLLocalizedString(@"补开费用"), @"content" : SLLocalizedString(@"到付"), @"isMore" : @"0", @"isEditor" : @"0", @"placeholder" : @""},
    //        ],
    //    ];
    //
    //    self.enterpriseDataArray = [enterpriseArray mutableArrayDeeoCopy];
    //
    //    NSArray *specialArray = @[
    //        @[
    //            @{@"title" : SLLocalizedString(@"订单编号"), @"content" : self.orderSn, @"isMore" : @"0", @"isEditor" : @"0", @"placeholder" : @""},
    //            @{@"title" : SLLocalizedString(@"发票形式"), @"content" : SLLocalizedString(@"电子发票"), @"isMore" : @"1", @"isEditor" : @"0", @"placeholder" : @""},
    //            @{@"title" : SLLocalizedString(@"发票类型"), @"content" : SLLocalizedString(@"增值税专用发票发票"), @"isMore" : @"1", @"isEditor" : @"0", @"placeholder" : @""},
    //            @{@"title" : SLLocalizedString(@"发票内容"), @"content" : SLLocalizedString(@"商品明细"), @"isMore" : @"0", @"isEditor" : @"0", @"placeholder" : @""},
    //            @{@"title" : SLLocalizedString(@"补开费用"), @"content" : SLLocalizedString(@"到付"), @"isMore" : @"0", @"isEditor" : @"0", @"placeholder" : @""},
    //        ],
    //        @[
    //            @{@"title" : SLLocalizedString(@"注册地址"), @"content" : @"", @"isMore" : @"0", @"isEditor" : @"1", @"placeholder" : SLLocalizedString(@"请输入注册地址")},
    //            @{@"title" : SLLocalizedString(@"注册电话"), @"content" : @"", @"isMore" : @"0", @"isEditor" : @"1", @"placeholder" : SLLocalizedString(@"请输入注册电话")},
    //            @{@"title" : SLLocalizedString(@"开户银行"), @"content" : @"", @"isMore" : @"0", @"isEditor" : @"1", @"placeholder" : SLLocalizedString(@"请输入开户银行")},
    //            @{@"title" : SLLocalizedString(@"银行账户"), @"content" : @"", @"isMore" : @"0", @"isEditor" : @"1", @"placeholder" : SLLocalizedString(@"请输入银行账户")},
    //        ],
    //        @[
    //            @{@"title" : SLLocalizedString(@"收票人"), @"content" : @"", @"isMore" : @"0", @"isEditor" : @"0", @"placeholder" : @""},
    //            @{@"title" : SLLocalizedString(@"手机号码"), @"content" : SLLocalizedString(@"电子发票"), @"isMore" : @"1", @"isEditor" : @"0", @"placeholder" : @""},
    //            @{@"title" : SLLocalizedString(@"详细地址"), @"content" : SLLocalizedString(@"增值税专用发票发票"), @"isMore" : @"0", @"isEditor" : @"1", @"placeholder" : @""},
    //        ],
    //    ];
    //
    //    self.specialDataArray = [specialArray mutableArrayDeeoCopy];
    
    
    
    NSArray *basecArray = @[
        @[
            @{@"title" : SLLocalizedString(@"订单编号"), @"content" : self.orderSn, @"isMore" : @"0", @"isEditor" : @"0", @"placeholder" : @""},
            @{@"title" : SLLocalizedString(@"发票形式"), @"content" : SLLocalizedString(@"电子发票"), @"isMore" : @"1", @"isEditor" : @"0", @"placeholder" : @""},
            @{@"title" : SLLocalizedString(@"发票类型"), @"content" : SLLocalizedString(@"普通发票"), @"isMore" : @"1", @"isEditor" : @"0", @"placeholder" : @""},
            @{@"title" : SLLocalizedString(@"发票内容"), @"content" : SLLocalizedString(@"商品明细"), @"isMore" : @"0", @"isEditor" : @"0", @"placeholder" : @""},
            @{@"title" : SLLocalizedString(@"补开费用"), @"content" : SLLocalizedString(@"到付"), @"isMore" : @"0", @"isEditor" : @"0", @"placeholder" : @""},
        ],
    ];
    self.dataArray = [basecArray mutableArrayDeeoCopy];
    
    
    NSArray *ticketArray = @[
        @{@"title" : SLLocalizedString(@"收票人"), @"content" : @"", @"isMore" : @"0", @"isEditor" : @"1", @"placeholder" : SLLocalizedString(@"收票人")},
        @{@"title" : SLLocalizedString(@"手机号码"), @"content" : @"", @"isMore" : @"0", @"isEditor" : @"1", @"placeholder" : SLLocalizedString(@"手机号码")},
        @{@"title" : SLLocalizedString(@"详细地址"), @"content" : @"", @"isMore" : @"0", @"isEditor" : @"1", @"placeholder" : SLLocalizedString(@"详细地址")},
    ];
    self.ticketArray = [ticketArray mutableArrayDeeoCopy];
    
    
    NSArray *registeredInfoArray =  @[
        @{@"title" : SLLocalizedString(@"注册地址"), @"content" : @"", @"isMore" : @"0", @"isEditor" : @"1", @"placeholder" : SLLocalizedString(@"请输入注册地址")},
        @{@"title" : SLLocalizedString(@"注册电话"), @"content" : @"", @"isMore" : @"0", @"isEditor" : @"1", @"placeholder" : SLLocalizedString(@"请输入注册电话")},
        @{@"title" : SLLocalizedString(@"开户银行"), @"content" : @"", @"isMore" : @"0", @"isEditor" : @"1", @"placeholder" : SLLocalizedString(@"请输入开户银行")},
        @{@"title" : SLLocalizedString(@"银行账户"), @"content" : @"", @"isMore" : @"0", @"isEditor" : @"1", @"placeholder" : SLLocalizedString(@"请输入银行账户")}
    ];
    
    self.registeredInfoArray = [registeredInfoArray mutableArrayDeeoCopy];
    
    
    NSArray *enterpriseArray =  @[
        @{@"title" : SLLocalizedString(@"抬头类型"), @"content" : SLLocalizedString(@"企业"), @"isMore" : @"1", @"isEditor" : @"0", @"placeholder" : @""},
        @{@"title" : SLLocalizedString(@"单位名称"), @"content" : @"", @"isMore" : @"0", @"isEditor" : @"1", @"placeholder" : SLLocalizedString(@"请输入单位名称")},
        @{@"title" : SLLocalizedString(@"单位税号"), @"content" : @"", @"isMore" : @"0", @"isEditor" : @"1", @"placeholder" : SLLocalizedString(@"请输入纳税人识别号")},
    ];
    
    self.enterpriseDataArray = [enterpriseArray mutableArrayDeeoCopy];
    
    NSArray *personalArray =  @[
        @{@"title" : SLLocalizedString(@"抬头类型"), @"content" : SLLocalizedString(@"个人"), @"isMore" : @"1", @"isEditor" : @"0", @"placeholder" : @""},
        @{@"title" : SLLocalizedString(@"个人名称"), @"content" : @"", @"isMore" : @"0", @"isEditor" : @"1", @"placeholder" : SLLocalizedString(@"请输入个人名称")},
    ];
    
    self.personalDataArray = [personalArray mutableArrayDeeoCopy];
    
    // 要插入的位置
    NSMutableArray *baseArray = [self.dataArray firstObject];
    
    NSIndexSet *indexPath = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange([baseArray count]-1, [self.personalDataArray count])];
    
    
    // 要插入的数组
    
    [baseArray insertObjects:self.personalDataArray atIndexes:indexPath];
    
    
    [self.tableView reloadData];
    
}

-(void)initUI{
    
    [self.titleLabe setText:SLLocalizedString(@"补开发票")];
    
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.bottomView];
}

#pragma mark - action
-(void)commitAction{
    
    [self.view endEditing:YES];
    
    BOOL flag = YES;
    for (NSArray *subArray in self.dataArray) {
        for (NSDictionary *temDic in subArray) {
             NSString *content = temDic[@"content"];
            if (content.length == 0) {
                flag = NO;
            }
        }
    }
    
    if (flag == NO) {
        [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"请填写发票信息") view:self.view afterDelay:TipSeconds];
        return;
    }
    
    
    
    self.isPersonal = YES;
    self.isCompany = NO;
    self.isElectronic = YES;
    self.isPaper = NO;
    self.isOrdinary = YES;
    self.isSpecialInvoice = NO;
    
    if (self.isPersonal) {
        self.fillModel.type = @"1";
    }
    
    if (self.isCompany) {
        self.fillModel.type = @"2";
    }
    
    if (self.isElectronic) {
        self.fillModel.is_paper = @"2";
    }
    
    if (self.isPaper) {
        self.fillModel.is_paper = @"1";
    }
    
    if (self.isOrdinary) {
        self.fillModel.invoice_type = @"1";
    }
    
    if (self.isSpecialInvoice) {
        self.fillModel.invoice_type = @"2";
    }
    
    
    
    NSDictionary *dic = [self.fillModel mj_keyValues];
    
    
    MBProgressHUD *hud = [ShaolinProgressHUD defaultLoadingWithText:nil];
    [[DataManager shareInstance]invoicing:dic Callback:^(Message *message) {
        [hud hideAnimated:YES];
        if (message.isSuccess) {
            [ShaolinProgressHUD singleTextHud:SLLocalizedString(@"提交成功") view:self.view afterDelay:TipSeconds];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            [ShaolinProgressHUD singleTextHud:NotNilAndNull(message.reason)?message.reason:@"" view:self.view afterDelay:TipSeconds];
        }
    }];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *rowArray = self.dataArray[section];
    
    return rowArray.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 51;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]init];
    [view setBackgroundColor:[UIColor colorForHex:@"FAFAFA"]];
    return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    OrderInvoiceTableCell *orderInvoiceCell = [tableView dequeueReusableCellWithIdentifier:@"OrderInvoiceTableCell"];
    
    NSArray *rowArray = self.dataArray[indexPath.section];
    
    [orderInvoiceCell setModel:rowArray[indexPath.row]];
    
    [orderInvoiceCell setFillModel:self.fillModel];
    
    cell = orderInvoiceCell;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    
    NSArray *rowArray = self.dataArray[indexPath.section];
    
    NSMutableDictionary *dic = rowArray[indexPath.row];
    
    //     @{@"title" : SLLocalizedString(@"收票人"), @"content" : @"", @"isMore" : @"0", @"isEditor" : @"0", @"placeholder" : @""},
    /**
     获取model的标题
     */
    NSString *titleStr = dic[@"title"];
    /**
     判断 标题是哪一种
     */
    if ([titleStr isEqualToString:SLLocalizedString(@"发票形式")]) {
        NSString *contentStr = dic[@"content"];
        /**
         弹窗
         */
        OrderInvoicePopupView *popupView = [[OrderInvoicePopupView alloc]initWithFrame:self.view.bounds];
        popupView.titleStr = SLLocalizedString(@"发票形式");
        /**
         弹窗展示内容
         */
        NSArray *array;
        if ([contentStr isEqualToString:SLLocalizedString(@"电子发票")]) {
            array = @[@{@"title":SLLocalizedString(@"电子发票"), @"isSelect":@"1"},@{@"title":SLLocalizedString(@"纸质发票"), @"isSelect":@"0"}];
        }else{
            array = @[@{@"title":SLLocalizedString(@"电子发票"), @"isSelect":@"0"},@{@"title":SLLocalizedString(@"纸质发票"), @"isSelect":@"1"}];
        }
        
        [popupView setCellArr:array];
        
        [popupView setTitleStr:SLLocalizedString(@"发票形式")];
        
        [self.view addSubview:popupView];
        
        /**
         选择后的回显
         */
        [popupView setSelectedBlock:^(NSString * _Nonnull cause) {
            NSLog(@"cause : %@", cause);
            [dic setValue:cause forKey:@"content"];
            /**
             判断 选择项
             */
            if ([cause isEqualToString:SLLocalizedString(@"纸质发票")]) {
                /**
                 纸质发票 需要 收票人信息
                 */
                if (![self.dataArray containsObject:self.ticketArray]) {
                    [self.dataArray addObject:self.ticketArray];
                }
                
                /**
                 更改标识
                 */
                self.isElectronic = NO;
                self.isPaper = YES;
                
            }else if([cause isEqualToString:SLLocalizedString(@"电子发票")]){
                /**
                电子发票 不要 收票人信息 和 注册信息
                */
                if ([self.dataArray containsObject:self.ticketArray]) {
                    [self.dataArray removeObject:self.ticketArray];
                }
                
                if ([self.dataArray containsObject:self.registeredInfoArray]) {
                    [self.dataArray removeObject:self.registeredInfoArray];
                }
                
                self.isElectronic = YES;
                self.isPaper = NO;
                
                NSMutableDictionary *subDic = [rowArray objectAtIndex:2];
                if ([subDic[@"content"] isEqualToString:SLLocalizedString(@"增值税专用发票")]) {
                    [subDic setValue:SLLocalizedString(@"普通发票") forKey:@"content"];
                }
                
                
            }
            
            [tableView reloadData];
        }];
        
        
    }
    
    if ([titleStr isEqualToString:SLLocalizedString(@"发票类型")]) {
        NSString *contentStr = dic[@"content"];
        
        OrderInvoicePopupView *popupView = [[OrderInvoicePopupView alloc]initWithFrame:self.view.bounds];
        popupView.titleStr = SLLocalizedString(@"发票类型");
        
        NSArray *array;
        if ([contentStr isEqualToString:SLLocalizedString(@"普通发票")]) {
            array = @[@{@"title":SLLocalizedString(@"普通发票"), @"isSelect":@"1"},@{@"title":SLLocalizedString(@"增值税专用发票"), @"isSelect":@"0"}];
        }else{
            array = @[@{@"title":SLLocalizedString(@"普通发票"), @"isSelect":@"0"},@{@"title":SLLocalizedString(@"增值税专用发票"), @"isSelect":@"1"}];
        }
        
        [popupView setCellArr:array];
        
        [popupView setTitleStr:SLLocalizedString(@"发票类型")];
        
        [self.view addSubview:popupView];
        
        [popupView setSelectedBlock:^(NSString * _Nonnull cause) {
            NSLog(@"cause : %@", cause);
            [dic setValue:cause forKey:@"content"];
            
            if ([cause isEqualToString:SLLocalizedString(@"增值税专用发票")]) {
                if ([self.dataArray containsObject:self.ticketArray]) {
                    [self.dataArray removeObject:self.ticketArray];
                }
                
                if ([self.dataArray containsObject:self.registeredInfoArray]) {
                    [self.dataArray removeObject:self.registeredInfoArray];
                }
                [self.dataArray addObject:self.registeredInfoArray];
                [self.dataArray addObject:self.ticketArray];
                
                
                
                self.isElectronic = NO;
                self.isPaper = YES;
                self.isOrdinary = NO;
                self.isSpecialInvoice = YES;
                
                NSMutableDictionary *subDic = [rowArray objectAtIndex:1];
                if ([subDic[@"content"] isEqualToString:SLLocalizedString(@"电子发票")]) {
                    [subDic setValue:SLLocalizedString(@"纸质发票") forKey:@"content"];
                }
                
                NSMutableArray *firstArray = [self.dataArray firstObject];
                if (self.isPersonal) {
                    [firstArray removeObjectsInArray:self.personalDataArray];
                }
                
                if (self.isCompany) {
                    [firstArray removeObjectsInArray:self.enterpriseDataArray];
                }
                
            }else if([cause isEqualToString:SLLocalizedString(@"普通发票")]){
                
                self.isOrdinary = YES;
                self.isSpecialInvoice = NO;
                
                if ([self.dataArray containsObject:self.ticketArray]) {
                    [self.dataArray removeObject:self.ticketArray];
                }
                
                if ([self.dataArray containsObject:self.registeredInfoArray]) {
                    [self.dataArray removeObject:self.registeredInfoArray];
                }
                
                if (self.isPersonal) {
                    // 要插入的位置
                    NSMutableArray *baseArray = [self.dataArray firstObject];
                    
                    NSIndexSet *indexPath = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange([baseArray count]-1, [self.personalDataArray count])];
                    
                    
                    // 要插入的数组
                    
                    [baseArray insertObjects:self.personalDataArray atIndexes:indexPath];
                }
                
                if (self.isCompany) {
                    
                    // 要插入的位置
                    NSMutableArray *baseArray = [self.dataArray firstObject];
                    
                    NSIndexSet *indexPath = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange([baseArray count]-1, [self.enterpriseDataArray count])];
                    
                    // 要插入的数组
                    
                    [baseArray insertObjects:self.enterpriseDataArray atIndexes:indexPath];
                    
                }
                
            }
            
            [tableView reloadData];
        }];
        
        
    }
    
    if ([titleStr isEqualToString:SLLocalizedString(@"抬头类型")]) {
        NSString *contentStr = dic[@"content"];
        OrderInvoicePopupView *popupView = [[OrderInvoicePopupView alloc]initWithFrame:self.view.bounds];
        popupView.titleStr = SLLocalizedString(@"抬头类型");
        
        NSArray *array;
        if ([contentStr isEqualToString:SLLocalizedString(@"个人")]) {
            array = @[@{@"title":SLLocalizedString(@"个人"), @"isSelect":@"1"},@{@"title":SLLocalizedString(@"企业"), @"isSelect":@"0"}];
        }else{
            array = @[@{@"title":SLLocalizedString(@"个人"), @"isSelect":@"0"},@{@"title":SLLocalizedString(@"企业"), @"isSelect":@"1"}];
        }
        
        [popupView setCellArr:array];
        
        [popupView setTitleStr:SLLocalizedString(@"抬头类型")];
        
        [self.view addSubview:popupView];
        
        [popupView setSelectedBlock:^(NSString * _Nonnull cause) {
            NSLog(@"cause : %@", cause);
//            [dic setValue:cause forKey:@"content"];
            
            NSMutableArray *firstArray = [self.dataArray firstObject];
            
            if ([cause isEqualToString:SLLocalizedString(@"个人")]) {
                
                if (self.isPersonal) {
                    [firstArray removeObjectsInArray:self.personalDataArray];
                }
                
                if (self.isCompany) {
                    [firstArray removeObjectsInArray:self.enterpriseDataArray];
                }
                
                
                if ([self.dataArray containsObject:self.ticketArray]) {
                    [self.dataArray removeObject:self.ticketArray];
                }
                
                if ([self.dataArray containsObject:self.registeredInfoArray]) {
                    [self.dataArray removeObject:self.registeredInfoArray];
                }
                self.isPersonal = YES;
                self.isCompany = NO;
                
                if (self.isPersonal) {
                    // 要插入的位置
                    NSMutableArray *baseArray = [self.dataArray firstObject];
                    
                    NSIndexSet *indexPath = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange([baseArray count]-1, [self.personalDataArray count])];
                    
                    
                    // 要插入的数组
                    
                    [baseArray insertObjects:self.personalDataArray atIndexes:indexPath];
                }
                
                
                
                
                if (self.isPaper) {
                    [self.dataArray addObject:self.ticketArray];
                }
                
            }else if([cause isEqualToString:SLLocalizedString(@"企业")]){
                if (self.isPersonal) {
                    [firstArray removeObjectsInArray:self.personalDataArray];
                }
                
                if (self.isCompany) {
                    [firstArray removeObjectsInArray:self.enterpriseDataArray];
                }
                if ([self.dataArray containsObject:self.ticketArray]) {
                    [self.dataArray removeObject:self.ticketArray];
                }
                
                if ([self.dataArray containsObject:self.registeredInfoArray]) {
                    [self.dataArray removeObject:self.registeredInfoArray];
                }
                self.isPersonal = NO;
                self.isCompany = YES;
                
                if (self.isCompany) {
                    
                    // 要插入的位置
                    NSMutableArray *baseArray = [self.dataArray firstObject];
                    
                    NSIndexSet *indexPath = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange([baseArray count]-1, [self.enterpriseDataArray count])];
                    
                    
                    // 要插入的数组
                    
                    [baseArray insertObjects:self.enterpriseDataArray atIndexes:indexPath];
                    
                }
                
                if (self.isPaper) {
                    [self.dataArray addObject:self.ticketArray];
                }
                
            }
            [tableView reloadData];
        }];
        
        
    }
    
    
}

#pragma mark - setter / getter
-(UITableView *)tableView{
    if (_tableView == nil) {
        
        
        CGFloat h = ScreenHeight - NavBar_Height - (CGRectGetHeight(self.bottomView.frame));
        
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, h) style:UITableViewStyleGrouped];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        
//        UIView * view = [UIView new];
//        view.backgroundColor = UIColor.whiteColor;
//        _tableView.tableFooterView = view;
        _tableView.backgroundColor = UIColor.whiteColor;
        [_tableView registerNib:[UINib nibWithNibName:NSStringFromClass([OrderInvoiceTableCell class])bundle:nil] forCellReuseIdentifier:@"OrderInvoiceTableCell"];
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _tableView;
}

-(UIView *)bottomView{
    
    if (_bottomView == nil) {
        CGFloat h = 49 + kBottomSafeHeight;
        CGFloat y = (ScreenHeight - NavBar_Height - h );
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, y, ScreenWidth, h)];
        
        UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [commitButton setFrame:CGRectMake(ScreenWidth - 90 - 16, 8, 90, 33)];
        [_bottomView addSubview:commitButton];
        [commitButton setTitle:SLLocalizedString(@"提交") forState:UIControlStateNormal];
        [commitButton.titleLabel setFont:kRegular(15)];
        [commitButton setTitleColor:[UIColor colorForHex:@"333333"] forState:UIControlStateNormal];
        
        commitButton.layer.cornerRadius = 15;
        commitButton.layer.borderWidth = 1;
        commitButton.layer.borderColor = [UIColor colorForHex:@"979797"].CGColor;
        
        [commitButton addTarget:self action:@selector(commitAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _bottomView;
    
}




@end
