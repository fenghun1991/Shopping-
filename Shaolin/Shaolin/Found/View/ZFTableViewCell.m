//
//  ZFTableViewCell.m
//  ZFPlayer
//
//  Created by 紫枫 on 2018/4/3.
//  Copyright © 2018年 紫枫. All rights reserved.
//

#import "ZFTableViewCell.h"
#import "UIImageView+ZFCache.h"

//#define ZFTableViewCell_ColorTest

@interface ZFTableViewCell ()
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nickNameLabel;
@property (nonatomic, strong) UIImageView *coverImageView;
@property (nonatomic, strong) UIView *fullMaskView;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, weak) id<ZFTableViewCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) UIImageView *bgImgView;

@property (nonatomic, strong) UIView *effectView;

@end

@implementation ZFTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.bgImgView];
        [self.bgImgView addSubview:self.effectView];
        [self.contentView addSubview:self.coverImageView];
        [self.coverImageView addSubview:self.playBtn];
        [self.contentView addSubview:self.headImageView];
        [self.contentView addSubview:self.nickNameLabel];
        [self.contentView addSubview:self.praiseBtn];
        [self.contentView addSubview:self.shareBnt];
        [self.contentView addSubview:self.collectionBtn];
        [self.contentView addSubview:self.abstractsLabel];
        [self.contentView addSubview:self.fullMaskView];

        self.contentView.backgroundColor =  [UIColor blackColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        

    }
    return self;
}

- (void)setLayout:(ZFTableViewCellLayout *)layout {
    _layout = layout;
    self.headImageView.layer.cornerRadius = CGRectGetHeight(layout.headerRect)/2;
    self.headImageView.frame = layout.headerRect;
    self.nickNameLabel.frame = layout.nickNameRect;
    self.abstractsLabel.frame = layout.abstractsRect;
    self.coverImageView.frame = layout.videoRect;
    self.bgImgView.frame = layout.videoRect;
    self.effectView.frame = self.bgImgView.bounds;
    self.playBtn.frame = layout.playBtnRect;
    self.fullMaskView.frame = layout.maskViewRect;
    self.praiseBtn.frame = layout.praiseRect;
    self.shareBnt.frame = layout.shareRect;
    self.collectionBtn.frame = layout.collectionRect;
    
    [self.headImageView setImageWithURLString:layout.data.headurl placeholder:[UIImage imageNamed:@"shaolinlogo"]];
    NSString *coverImageStr = [NSString stringWithFormat:@"%@%@",layout.data.coverurl,Video_First_Photo];
    [self.coverImageView setImageWithURLString:coverImageStr placeholder:[UIImage imageNamed:@"loading_bgView"]];
    [self.bgImgView setImageWithURLString:coverImageStr placeholder:[UIImage imageNamed:@"loading_bgView"]];
    self.nickNameLabel.text = [NSString stringWithFormat:@"@%@", layout.data.author];
    self.abstractsLabel.text = layout.data.title;
    [self.praiseBtn setTitle:[NSString stringWithFormat:@"%@",layout.data.praises] forState:(UIControlStateNormal)];
     [self.collectionBtn setTitle:[NSString stringWithFormat:@"%@",layout.data.collections] forState:(UIControlStateNormal)];
       [self.shareBnt setTitle:[NSString stringWithFormat:@"%@",layout.data.forwards] forState:(UIControlStateNormal)];
    if ([layout.data.collection integerValue]==1) {//没有
        [self.collectionBtn setSelected:NO];
    }else
    {
         [self.collectionBtn setSelected:YES];
    }
    if ([layout.data.praise integerValue]==1) {//没有
        [self.praiseBtn setSelected:NO];
    }else
    {
         [self.praiseBtn setSelected:YES];
    }
    NSArray *restyleButtons = @[self.shareBnt, self.collectionBtn, self.praiseBtn];
    for (UIButton *button in restyleButtons){
        [self restyleButton:button];
    }
}

- (void)setDelegate:(id<ZFTableViewCellDelegate>)delegate withIndexPath:(NSIndexPath *)indexPath {
    self.delegate = delegate;
    self.indexPath = indexPath;
}

- (void)setNormalMode {
    self.fullMaskView.hidden = YES;
    self.nickNameLabel.textColor = [UIColor blackColor];
    self.contentView.backgroundColor =  [UIColor blackColor];
}

- (void)showMaskView {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.fullMaskView.alpha = 0.8;
       
    }];
   
}

- (void)hideMaskView {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.fullMaskView.alpha = 0;
       
    }];
}

- (void)restyleButton:(UIButton *)button{
    CGFloat spacing = 5;
    CGSize imageSize = button.imageView.frame.size;
    CGSize titleSize = button.titleLabel.frame.size;
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:button.titleLabel.font forKey:NSFontAttributeName];
    CGSize textSize = [button.titleLabel.text sizeWithAttributes:attributes];
    CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
    if (titleSize.width + 0.5 < frameSize.width) {
        titleSize.width = frameSize.width;
    }
    
    CGFloat totalHeight = imageSize.height + titleSize.height;
    button.imageEdgeInsets = UIEdgeInsetsMake(- (totalHeight - imageSize.height + spacing), 0.0, 0.0, - titleSize.width);
    button.titleEdgeInsets = UIEdgeInsetsMake(0, - imageSize.width, - (totalHeight - titleSize.height + spacing), 0);
}

- (void)playBtnClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(zf_playTheVideoAtIndexPath:)]) {
        [self.delegate zf_playTheVideoAtIndexPath:self.indexPath];
    }
}

#pragma mark - getter

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[UIImage imageNamed:@"new_allPlay_44x44_"] forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

- (UIView *)fullMaskView {
    if (!_fullMaskView) {
        _fullMaskView = [UIView new];
        _fullMaskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
        _fullMaskView.userInteractionEnabled = NO;
        _fullMaskView.hidden = YES;
    }
    return _fullMaskView;
}


- (UILabel *)nickNameLabel {
    if (!_nickNameLabel) {
        _nickNameLabel = [UILabel new];
        _nickNameLabel.textColor = [UIColor colorForHex:@"FFFFFF"];
        _nickNameLabel.font = kMediumFont(16);
#ifdef ZFTableViewCell_ColorTest
        _nickNameLabel.backgroundColor = [UIColor greenColor];
#endif
    }
    return _nickNameLabel;
}

- (UILabel *)abstractsLabel{
    if (!_abstractsLabel) {
        _abstractsLabel = [UILabelLeftTopAlign new];
        _abstractsLabel.textColor = [UIColor colorForHex:@"FFFFFF"];
        _abstractsLabel.font = kRegular(15);
#ifdef ZFTableViewCell_ColorTest
        _abstractsLabel.backgroundColor = [UIColor redColor];
#endif
    }
    return _abstractsLabel;
}

- (UIImageView *)headImageView {
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.userInteractionEnabled = YES;
        _headImageView.clipsToBounds = YES;
#ifdef ZFTableViewCell_ColorTest
        _headImageView.backgroundColor = [UIColor blueColor];
#endif
    }
    return _headImageView;
}

- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.userInteractionEnabled = YES;
        _coverImageView.tag = 100;
//        _coverImageView.backgroundColor = [UIColor blackColor];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _coverImageView;
}

- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] init];
        _bgImgView.userInteractionEnabled = YES;
//        _bgImgView.backgroundColor = [UIColor blackColor];
    }
    return _bgImgView;
}

- (UIView *)effectView {
    if (!_effectView) {
        if (@available(iOS 8.0, *)) {
            UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            _effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        } else {
            UIToolbar *effectView = [[UIToolbar alloc] init];
            effectView.barStyle = UIBarStyleBlackTranslucent;
            _effectView = effectView;
        }
        _effectView.backgroundColor = [UIColor blackColor];
    }
    return _effectView;
}
-(UIButton *)praiseBtn
{
    if (!_praiseBtn) {
        _praiseBtn  =[[ UIButton alloc]init];
       
        [_praiseBtn setImage:[UIImage imageNamed:@"video_praise_normal"] forState:(UIControlStateNormal)];
        [_praiseBtn setImage:[UIImage imageNamed:@"praise_select"] forState:(UIControlStateSelected)];
        _praiseBtn.titleLabel.font = kRegular(13);
        [_praiseBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_praiseBtn addTarget:self action:@selector(praiseAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _praiseBtn;
}
-(UIButton *)collectionBtn
{
    if (!_collectionBtn) {
        _collectionBtn  =[[ UIButton alloc]init];
        [_collectionBtn setTitle:@" 10" forState:(UIControlStateNormal)];
        [_collectionBtn setImage:[UIImage imageNamed:@"video_focus_normal"] forState:(UIControlStateNormal)];
        [_collectionBtn setImage:[UIImage imageNamed:@"focus_select"] forState:(UIControlStateSelected)];
        _collectionBtn.titleLabel.font = kRegular(13);
        [_collectionBtn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_collectionBtn addTarget:self action:@selector(collectionAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _collectionBtn;
}
-(void)collectionAction:(UIButton *)button
{
    UITableView *table = (UITableView *)self.superview;
    NSInteger numOfSelectedCell = [table indexPathForCell:self].row;
   
    [self.delegate foucsActionButton:button IndexPath:numOfSelectedCell IndexPathRow:self.indexPath];
}
-(void)praiseAction:(UIButton *)button
{
    
   
       UITableView *table = (UITableView *)self.superview;
        NSInteger numOfSelectedCell = [table indexPathForCell:self].row;
        [self.delegate prasieActionButton:button IndexPath:numOfSelectedCell IndexPathRow:self.indexPath];
    
}
-(void)shareAction:(UIButton *)button
{
     UITableView *table = (UITableView *)self.superview;
          NSInteger numOfSelectedCell = [table indexPathForCell:self].row;
        [self.delegate shareActionButton:button IndexPath:numOfSelectedCell IndexPathRow:self.indexPath];
    
    
}
-(UIButton *)shareBnt
{
    if (!_shareBnt) {
        _shareBnt  =[[ UIButton alloc]init];
        [_shareBnt setTitle:@" 1" forState:(UIControlStateNormal)];
        [_shareBnt setImage:[UIImage imageNamed:@"video_share_normal"] forState:(UIControlStateNormal)];
        _shareBnt.titleLabel.font = kRegular(13);
        [_shareBnt setTitleColor:[UIColor colorForHex:@"FFFFFF"] forState:(UIControlStateNormal)];
        [_shareBnt addTarget:self action:@selector(shareAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _shareBnt;
}

- (UIImage *)getShowImage{
    return self.coverImageView.image;
}
@end
