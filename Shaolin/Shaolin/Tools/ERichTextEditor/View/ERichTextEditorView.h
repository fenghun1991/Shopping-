//
//  ERichTextEditorView.h
//  KCWC
//
//  Created by Eleven on 2018/2/6.
//  Copyright © 2018年 HAWK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
@interface ERichTextEditorView : UIView

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic,   copy) void (^heightBlock)(CGFloat height);
@property (nonatomic,   copy) void (^scrollYOffset)(CGFloat offset);
- (instancetype)initWithFrame:(CGRect)frame ContentStr:(NSString *)contentStr;
- (void)setBold;
- (void)setItalic;
- (void)setUnorderedList;
- (void)setOrderedList;
- (void)setBlockquote;
- (void)setStrikethrough;
- (void)setSelectedColor:(NSString *)hexColor;
- (void)heading1;
- (void)heading2;
- (void)heading3;
- (void)heading4;
- (void)undo;
- (void)setHTML:(NSString *)html;
- (void)insertImageBase64String:(NSString *)imageBase64String;
- (void)getCaretYPosition;

/**
 视图高度变化时，要及时设置高度
 特别注意键盘的弹出与关闭

 @param contentHeight 显示区域高度
 */
- (void)setContentHeight:(float)contentHeight;

/**
 记录光标位置（需要调用相册功能时，要提前调用本方法）
 */
- (void)recordCursorPosition;
/// 插入图片
- (void)insertImage:(NSString *)url;
- (void)getHTMLAndBlock:(void (^)(NSString * html))block;

@end


@interface ERichTextToolBar : UIView

- (instancetype)initWithFrame:(CGRect)frame editView:(ERichTextEditorView *)editView;

@end
