//
//  PersonalDataView.m
//  Shaolin
//
//  Created by edz on 2020/3/18.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "PersonalDataView.h"
#import "OrderPriceBuyCarCell.h"
#import "UIView+Colors.h"
#import "DataManager.h"

@interface PersonalDataView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong) UIImageView *headerImage;
@property(nonatomic,strong) UILabel *nameLabel;
@property(nonatomic,strong) UILabel *signatureLabel;
@property(nonatomic,strong) UIButton *rightBtn;
@property(nonatomic,strong) UIView *personView;
@property(nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) UIView *levelView;


@end
@implementation PersonalDataView
{
    NSInteger _levelLabelTag;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _levelLabelTag = 200;
        [self layoutView];
    }
    return self;
}
-(void)layoutView
{
    [[DataManager shareInstance]getOrderAndCartCount];
    self.personView.userInteractionEnabled = YES;
    
    [self addSubview:self.headerImage];
    [self addSubview:self.nameLabel];
    [self addSubview:self.levelView];
    [self addSubview:self.signatureLabel];
    [self addSubview:self.rightBtn];
    [self addSubview:self.collectionView];
    [self addSubview:self.personView];
    [self.personView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchView)]];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(balanceRefresh) name:@"GetUserBalance" object:nil];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(balanceRefresh) name:WENGENMANAGER_GETORDERANDCARTCOUNT object:nil];
    
    [self.headerImage mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.size.mas_equalTo(43);
        make.size.mas_equalTo(66);
        make.left.mas_equalTo(16);
        make.top.mas_equalTo(0);
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.left.mas_equalTo(self.headerImage.mas_right).offset(10);
        make.left.mas_equalTo(self.headerImage.mas_right).offset(17);
        //        make.right.mas_lessThanOrEqualTo(-SLChange(115));
        //        make.width.mas_lessThanOrEqualTo(SLChange(200));
        //        make.height.mas_equalTo(SLChange(16));
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(SLChange(5));
        make.right.mas_lessThanOrEqualTo(-SLChange(115));
        make.width.mas_lessThanOrEqualTo(SLChange(200));
    }];
    
    [self.levelView mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.left.mas_equalTo(self.nameLabel.mas_right).mas_offset(SLChange(9));
        //        make.right.mas_lessThanOrEqualTo(-SLChange(55));
        //        make.centerY.mas_equalTo(self.nameLabel);
        //        make.size.mas_equalTo(CGSizeMake(SLChange(44), SLChange(18)));
        
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.size.mas_equalTo(CGSizeMake(48, 21));
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(11.5);
        
    }];
    [self.signatureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.left.mas_equalTo(self.headerImage.mas_right).offset(SLChange(9));
        //         make.right.mas_equalTo(self.mas_right).offset(-SLChange(55));
        //        make.height.mas_equalTo(SLChange(16));
        //        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(SLChange(10));
        
        make.left.mas_equalTo(self.levelView.mas_right).offset(12);
        make.right.mas_equalTo(self.mas_right).offset(-SLChange(55));
        
        make.height.mas_equalTo(16.5);
        
        
        
        make.centerY.mas_equalTo(self.levelView);
        
    }];
    
    
    
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        //        make.width.mas_equalTo(SLChange(6));
        //        make.height.mas_equalTo(SLChange(13));
        //        make.centerY.mas_equalTo(self.headerImage);
        //        make.right.mas_equalTo(-SLChange(24.5));
        
        
        make.width.mas_equalTo(13);
        make.height.mas_equalTo(14);
        make.centerY.mas_equalTo(self.nameLabel);
        make.left.mas_equalTo(self.nameLabel.mas_right).mas_offset(10);
        
    }];
    [self.personView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(SLChange(43));
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(SLChange(16));
        make.right.mas_equalTo(0);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.top.mas_equalTo(self.headerImage.mas_bottom).mas_equalTo(29);
        make.size.mas_equalTo(CGSizeMake(kWidth - 30, 80));
    }];
    
}
- (void)balanceRefresh {
    [self.collectionView reloadData];
}
- (void)setDicData:(NSDictionary *)dicData {
    _dicData = dicData;
    [_headerImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[dicData objectForKey:@"headurl"]]] placeholderImage:[UIImage imageNamed:@"shaolinlogo"]];
    
    if ([[dicData objectForKey:@"nickname"] isEqual:[NSNull null]] || [self.dicData objectForKey:@"nickname"] == nil || [[dicData objectForKey:@"nickname"] isEqual:@"(null)"]) {
        self.nameLabel.text = SLLocalizedString(@"暂无昵称");
    }else{
        self.nameLabel.text = [dicData objectForKey:@"nickname"];
        
    }
    NSString * autograph = [dicData objectForKey:@"autograph"];
    if (IsNilOrNull(autograph) || autograph.length == 0) {
        self.signatureLabel.text = @"";
    }else{
        //        self.signatureLabel.text = [NSString stringWithFormat:SLLocalizedString(@"个性签名：%@"),[dicData objectForKey:@"autograph"]];
        
        self.signatureLabel.text = [NSString stringWithFormat:SLLocalizedString(@"%@"),[dicData objectForKey:@"autograph"]];
        
    }
    NSString *levelName = [dicData objectForKey:@"levelName"];
    if (levelName.length == 0 ){
        levelName = SLLocalizedString(@"无位阶");
    }
    [self reloadLevelView:levelName];
}

-(void)reloadLevelView:(NSString *)levelName{
    UILabel *levelLabel = [self.levelView viewWithTag:_levelLabelTag];
    levelLabel.text = levelName;
    if ([levelName isEqualToString:SLLocalizedString(@"无位阶")]){
        levelLabel.textColor = [UIColor colorForHex:@"FFFFFF"];
        //        self.levelView.backgroundColor = [UIColor colorForHex:@"BBBBBB"];
        self.levelView.backgroundColor = KMeLightYellow;
        //        [self.levelView setGradationColor:@[] startPoint:CGPointMake(0.0, 0.0) endPoint:CGPointMake(1.0, 1.0)];
    } else {
        
        //        levelLabel.textColor = [UIColor colorForHex:@"333333"];
        //        NSArray *colors = @[
        //            [UIColor colorForHex:@"F1D38B"],
        //            [UIColor colorForHex:@"E7BC60"],
        //        ];
        //        [self.levelView setGradationColor:colors startPoint:CGPointMake(0.0, 0.0) endPoint:CGPointMake(1.0, 1.0)];
        levelLabel.textColor = [UIColor colorForHex:@"FFFFFF"];
        
        self.levelView.backgroundColor = KMeLightYellow;
    }
}

-(void)touchView
{
    if (self.personDataClick) {
        self.personDataClick(self.dicData);
    }
    
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
    
}
/// collectinView section header 在高版本存在系统BUG，需要设置zPosition = 0.0
- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    view.layer.zPosition = 0.0;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    OrderPriceBuyCarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OrderPriceBuyCarCell" forIndexPath:indexPath];
    
    ModelTool *tool = [ModelTool shareInstance];
    
    NSString *orderCount = tool.orderCount == nil || [tool.orderCount isEqualToString:@"(null)"] ? @"0":tool.orderCount;
    NSString *carCount = tool.carCount == nil || [tool.carCount isEqualToString:@"(null)"] ?@"0":tool.carCount;
    NSString *balance = @"";
    if (!self.balanceNumber) self.balanceNumber = @(0);
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    //    formatter.positiveFormat = @",###.##"; // 正数格式
    // 整数最少位数
    formatter.minimumIntegerDigits = 1;
    // 小数位最多位数
    formatter.maximumFractionDigits = 2;
    // 小数位最少位数
    formatter.minimumFractionDigits = 2;
    
    // 注意传入参数的数据长度，可用double
    NSString *money = [formatter stringFromNumber:self.balanceNumber];
    balance = money;
    //        balance = [NSString stringWithFormat:@"%.2f",self.balanceStr.floatValue];
    
    NSArray *arr = @[orderCount,balance,carCount];
    cell.numberLabel.text = arr[indexPath.row];
    NSArray *arrTitle = @[SLLocalizedString(@"订单管理"),SLLocalizedString(@"余额管理"),SLLocalizedString(@"我的购物车")];
    cell.nameLabel.text = arrTitle[indexPath.row];
    if (indexPath.row ==2) {
        cell.vieW.hidden = YES;
    }else {
        cell.vieW.hidden = NO;
    }
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.itemDidClick) {
        self.itemDidClick(indexPath.row);
    }
}
//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = kWidth - 30 ;
    return CGSizeMake(width/3, 80);
}

-(UICollectionView *)collectionView
{
    if (!_collectionView) {

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
                
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        //                _collectionView.backgroundColor = [UIColor clearColor];
        [_collectionView registerClass:[OrderPriceBuyCarCell class] forCellWithReuseIdentifier:@"OrderPriceBuyCarCell"];
        
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        
        _collectionView.layer.cornerRadius = 8;
        
    }
    return _collectionView;
}
-(UICollectionViewFlowLayout *)layout
{
    if (!_layout) {
        _layout = [UICollectionViewFlowLayout new];
        _layout.minimumLineSpacing = 0;
        _layout.minimumInteritemSpacing = 0;
        _layout.itemSize = CGSizeMake(kWidth/3, SLChange(34));
        //            _layout.sectionInset = UIEdgeInsetsMake(SLChange(32) ,0 , 0,0);
    }
    return _layout;
    
}
-(UIImageView *)headerImage
{
    if (!_headerImage) {
        _headerImage = [[UIImageView alloc]init];
        //        _headerImage.layer.cornerRadius = SLChange(43)/2;
        _headerImage.layer.cornerRadius = 66/2;
        _headerImage.layer.masksToBounds = YES;
        _headerImage.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _headerImage;
}
-(UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.text = @"";
        //        _nameLabel.font = kRegular(16);
        _nameLabel.font = kMediumFont(20);
    }
    return _nameLabel;
}
-(UILabel *)signatureLabel
{
    if (!_signatureLabel) {
        _signatureLabel = [[UILabel alloc]init];
        //        _signatureLabel.textColor = [UIColor whiteColor];
        _signatureLabel.text = SLLocalizedString(@"个性签名：");
        //        _signatureLabel.font = kRegular(11);
        _signatureLabel.font = kRegular(12);
        _signatureLabel.textColor = [UIColor colorForHex:@"E3DCCE"];
    }
    return _signatureLabel;
}
-(UIButton *)rightBtn
{
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        //        [_rightBtn setImage:[UIImage imageNamed:@"me_right_icon"] forState:(UIControlStateNormal)];
        [_rightBtn setImage:[UIImage imageNamed:@"bianji"] forState:(UIControlStateNormal)];
        
        
    }
    return _rightBtn;
}
-(UIView *)personView
{
    if (!_personView) {
        _personView = [[UIView alloc]init];
        _personView.backgroundColor = [UIColor clearColor];
    }
    return _personView;
}

-(UIView *)levelView
{
    if (!_levelView){
        _levelView = [[UIView alloc] init];
        _levelView.clipsToBounds = YES;
        
        UILabel *levelLabel = [[UILabel alloc] init];
        levelLabel.textAlignment = NSTextAlignmentCenter;
        //        levelLabel.font = kBoldFont(10);
        levelLabel.font = kRegular(13);
        
        levelLabel.tag = _levelLabelTag;
        
        [levelLabel setTextAlignment:NSTextAlignmentCenter];
        
        [self.levelView addSubview:levelLabel];
        
        [levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return _levelView;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */


-(void)dealloc{
    //移除监听
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
