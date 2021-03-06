//
//  RiteOrderTableViewCell.m
//  Shaolin
//
//  Created by 郭超 on 2020/7/30.
//  Copyright © 2020 syqaxldy. All rights reserved.
//

#import "RiteOrderTableViewCell.h"

#import "OrderListModel.h"
#import "OrderStoreModel.h"
#import "OrderGoodsModel.h"

@interface RiteOrderTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
- (IBAction)deleteAction:(UIButton *)sender;

/**
 只显示 已完成/已取消
 */
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

/**
 等待付款
 */
@property (weak, nonatomic) IBOutlet UILabel *waitingPaymentLabel;

/**
 订单封面图
 */
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;

/**
 商品名称
 */
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;

/**
 简介分类
 */
@property (weak, nonatomic) IBOutlet UILabel *introductionLabel;

/**
 价格
 */
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

/**
 从左数第二个button
 去支付，查看发票，开具发票
 */
@property (weak, nonatomic) IBOutlet UIButton *secondButton;

/**
 第二个button 宽度， 正常时80，隐藏时0
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondButtonW;
- (IBAction)secondButtonAction:(UIButton *)sender;

/**
 第一个button 和 第二个button 间隔 正常时 5，隐藏时0
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *intervalW;

/**
 从左数第一个button
 主要是报名详情
 */
@property (weak, nonatomic) IBOutlet UIButton *firstButton;
- (IBAction)firstButonAction:(UIButton *)sender;

@end


@implementation RiteOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.stateLabel setHidden:YES];
    [self.deleteButton setHidden:YES];
    [self.waitingPaymentLabel setHidden:YES];
    
    [self modifiedButton:self.firstButton borderColor:[UIColor colorForHex:@"979797"] cornerRadius:15];
    
    [self modifiedButton:self.secondButton borderColor:[UIColor colorForHex:@"979797"] cornerRadius:15];
    
}

///装饰button
-(void)modifiedButton:(UIButton *)sender borderColor:(UIColor *)color cornerRadius:(CGFloat)radius{
    sender.layer.borderWidth = 1;
    sender.layer.borderColor = color.CGColor;
    sender.layer.cornerRadius = radius;
    [sender.layer setMasksToBounds:YES];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - 待付款

/// 待付款
-(void)p_obligation{
    //待付款
    [self.stateLabel setHidden:YES];
    [self.deleteButton setHidden:YES];
    [self.waitingPaymentLabel setHidden:NO];
    
    [self.firstButton setHidden:NO];
    [self.secondButton setHidden:NO];
    
    [self.secondButton setTitle:@"去支付" forState:UIControlStateNormal];
    [self.secondButton setTitleColor:[UIColor colorForHex:@"BE0B1F"] forState:UIControlStateNormal];
    [self modifiedButton:self.secondButton borderColor:[UIColor colorForHex:@"BE0B1F"] cornerRadius:15];
    self.secondButtonW.constant = 80;
    self.intervalW.constant = 5;
}


#pragma mark - 已取消

/// 已取消
-(void)p_canceled{
    // 已取消
    [self.waitingPaymentLabel setHidden:YES];
    [self.stateLabel setHidden:NO];
    [self.deleteButton setHidden:NO];
    [self.stateLabel setText:@"已取消"];
    
    [self.firstButton setHidden:NO];
    [self.secondButton setHidden:YES];
    
    self.secondButtonW.constant = 0;
    self.intervalW.constant = 0;
}

#pragma mark - 已完成

/// 已完成
-(void)p_finished{
    //已完成
    [self.waitingPaymentLabel setHidden:YES];
    [self.stateLabel setHidden:NO];
    [self.deleteButton setHidden:NO];
    [self.stateLabel setText:@"已完成"];
    
    [self.firstButton setHidden:NO];
    [self.secondButton setHidden:NO];
    
    self.secondButtonW.constant = 80;
    self.intervalW.constant = 5;
    
    [self modifiedButton:self.secondButton borderColor:[UIColor colorForHex:@"979797"] cornerRadius:15];
    
    [self.secondButton setTitleColor:[UIColor colorForHex:@"333333"] forState:UIControlStateNormal];
}



#pragma mark - setter / getter

-(void)setListModel:(OrderListModel *)listModel{
    
    _listModel = listModel;
    
    [self.numberLabel setText:[NSString stringWithFormat:@"功德编号：%@", listModel.order_sn]];
    
    
    NSArray *orderStoreArray = listModel.order_goods;
    
    OrderStoreModel *storeModel = [orderStoreArray firstObject];
    
    NSArray *orderGoodsArray = storeModel.goods;
    
    OrderGoodsModel *goodsModel = [orderGoodsArray firstObject];
    
    if([goodsModel.goods_image count] > 0){
        NSString * goodsImageStr = goodsModel.goods_image[0];
        [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:goodsImageStr] placeholderImage:[UIImage imageNamed:@"default_small"]];
    }
    
    [self.goodsNameLabel setText:goodsModel.goods_name];
    
    NSString *desc = [goodsModel.desc stringByReplacingOccurrencesOfString:@"," withString:@"/"];
    [self.introductionLabel setText:desc];
    
    NSString *pay_money = [NSString stringWithFormat:@"￥%@", listModel.order_car_money];
    
    NSRange range = [pay_money rangeOfString:@"."];
    if (range.location != NSNotFound) {
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:pay_money];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:MediumFont size:12] range:NSMakeRange(0, 1)];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:MediumFont size:16] range:NSMakeRange(1, range.location-1)];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont fontWithName:MediumFont size:14] range:NSMakeRange(range.location, 3)];
        self.priceLabel.attributedText = attrStr;
    }
    ///1：待付款，2：待发货，3：待收货，4：已收货，5：完成，6：取消 7：支付超时
    NSInteger status = [goodsModel.status integerValue];
    if (status == 1) {
        //待付款
        [self p_obligation];
    }else if(status == 4 || status == 5){
        // 已完成
        [self p_finished];
        
       NSInteger order_check = [goodsModel.order_check integerValue];
        
        if (order_check == 1) {
            BOOL is_invoice = [goodsModel.is_invoice boolValue];
               NSString *buttonTitle = @"查看发票";
               if (is_invoice == NO) {
                   buttonTitle = @"补开发票";
               }
            [self.secondButton setTitle:buttonTitle forState:UIControlStateNormal];
        }else{
            [self.secondButton setHidden:YES];
               
            self.secondButtonW.constant = 0;
            self.intervalW.constant = 0;
        }
        
        
        
    }else if(status == 6 || status == 7){
        // 已取消
        [self p_canceled];
    }
}

- (IBAction)deleteAction:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(riteOrderTableViewCell: delOrder:)]) {
        [self.delegate riteOrderTableViewCell:self delOrder:self.listModel];
    }
}

/**
 第二个button Action
 */
- (IBAction)secondButtonAction:(UIButton *)sender {
    
     NSString *title = sender.titleLabel.text;
    
    if ([title isEqualToString:@"查看发票"]) {
        
        if ([self.delegate respondsToSelector:@selector(riteOrderTableViewCell: lookInvoice:)]) {
            [self.delegate riteOrderTableViewCell:self lookInvoice:self.listModel];
        }
    }else if([title isEqualToString:@"补开发票"]){
        if ([self.delegate respondsToSelector:@selector(riteOrderTableViewCell: repairInvoice:)]) {
            [self.delegate riteOrderTableViewCell:self repairInvoice:self.listModel];
        }
        
    }else if([title isEqualToString:@"去支付"]){
        if ([self.delegate respondsToSelector:@selector(riteOrderTableViewCell: pay:)]) {
            [self.delegate riteOrderTableViewCell:self pay:self.listModel];
        }
        
    }
    
}

/**
 第一个button Action
 */
- (IBAction)firstButonAction:(UIButton *)sender {
    NSString *title = sender.titleLabel.text;
    
    if ([title isEqualToString:@"详情"]) {
        if ([self.delegate respondsToSelector:@selector(riteOrderTableViewCell: subjects:)]) {
            [self.delegate riteOrderTableViewCell:self subjects:self.listModel];
        }
    }
    
}

@end
