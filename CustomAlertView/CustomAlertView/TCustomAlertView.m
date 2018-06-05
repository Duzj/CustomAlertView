//
//  TUserAlertView.m
//  TUser
//
//  Created by Duzj on 2018/5/30.
//

#import "TCustomAlertView.h"
#import <Masonry/Masonry.h>
//#import "UIColor+TUser.h"
//#import "TUserMacro.h"
#define SCREEN_WIDTH                ([UIScreen mainScreen].bounds.size.width)

#pragma mark  - TCustomAlertAction

@interface TCustomAlertAction()

@property (nonatomic ,strong) NSString *title;

@property (nonatomic ,strong) UIColor *titleColor;

@property (nonatomic ,copy) void (^ actionBlock)(TCustomAlertAction *action);

@end

@implementation TCustomAlertAction

+ (instancetype)actionWithTitle:(nullable NSString *)title titleColor:(nullable UIColor*)titleColor handler:(void (^ __nullable)(TCustomAlertAction *action))handler{
    TCustomAlertAction *action = [TCustomAlertAction new];
    action.title = title;
    action.titleColor = titleColor;
    action.actionBlock = handler;
    return action;
}

@end


#pragma mark  - TUserAlertView

@interface TCustomAlertView()

@property (nonatomic ,strong) UIView *backgroundView;

@property (nonatomic ,strong) UILabel *titleLabel;

@property (nonatomic ,strong) UILabel *contentLabel;

@property (nonatomic ,strong) UIView *horizontalLine; //横线


@property (nonatomic ,strong)  NSMutableDictionary *attributedText;

@property (nonatomic ,strong) NSMutableArray *allActions;

@end

@implementation TCustomAlertView

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message{
    self = [super init];
    if (self) {
        self.layer.cornerRadius = 8.0;
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.titleLabel];
        [self addSubview:self.contentLabel];

        [self addSubview:self.horizontalLine];
        [self setNeedsUpdateConstraints];
        
        if ((title.length && (!message.length))) {
            self.contentLabel.attributedText = [[NSAttributedString alloc] initWithString:title attributes:self.attributedText];
        }else if (((!title.length)&&message.length)) {
            self.contentLabel.attributedText = [[NSAttributedString alloc] initWithString:message attributes:self.attributedText];
        }else{
            self.titleLabel.attributedText = [[NSAttributedString alloc] initWithString:title attributes:self.attributedText];
            self.contentLabel.attributedText = [[NSAttributedString alloc] initWithString:message attributes:self.attributedText];
        }
    }
    return self;
}

- (void)addAction:(TCustomAlertAction *)action{
    [self.allActions addObject:action];
}


- (void)dealloc{
    NSLog(@"dealloc");
}

#pragma mark - public

- (void)show{
    [self addBtns];
    
    UIWindow *keyWindow =   [UIApplication sharedApplication].keyWindow;
    self.backgroundView.frame = keyWindow.frame;
    [keyWindow addSubview:self.backgroundView];
    [keyWindow addSubview:self];
    
    CGSize titleSize = [self.titleLabel.text boundingRectWithSize:CGSizeMake((SCREEN_WIDTH-100 - 60), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:self.attributedText context:nil].size;

    CGSize contentSize = [self.contentLabel.text boundingRectWithSize:CGSizeMake((SCREEN_WIDTH-100 - 60), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:self.attributedText context:nil].size;

    CGFloat contentLabelToTitleLabel = self.titleLabel.text.length ? 15 : 0;
    
    CGFloat height = 50 + titleSize.height +contentLabelToTitleLabel + contentSize.height+ 50;

    self.bounds = CGRectMake(0, 0, SCREEN_WIDTH-100, height);
    self.center = keyWindow.center;
    CAKeyframeAnimation * animation;
    animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.4;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    animation.keyTimes = @[@0.0f, @0.2f, @0.8f, @1.0f];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.layer addAnimation:animation forKey:nil];
}

#pragma mark - private

- (void)addBtns{
    CGFloat btnWidth = (SCREEN_WIDTH-100)/self.allActions.count;
    
    for (int i =0 ;i < self.allActions.count ; i++) {
        TCustomAlertAction *action = self.allActions[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:action.title forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:17];
        [btn setTitleColor:action.titleColor forState:UIControlStateNormal];
        btn.tag = i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(i*(btnWidth+0.5));
            make.top.equalTo(self.horizontalLine.mas_bottom);
            make.width.equalTo(@(btnWidth));
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        if (self.allActions.count >= 2 &&( i != self.allActions.count-1)) {
            
            UIView *line = [UIView new];
            line.backgroundColor = [self colorWithRGBHex:0xE1E1E1 alpha:1.0];
            [self addSubview:line];
            
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(btn.mas_right);
                make.width.equalTo(@0.5);
                make.top.equalTo(self.horizontalLine.mas_bottom);
                make.bottom.equalTo(self.mas_bottom);
            }];
        }
    }
}

- (void)btnClick:(UIButton *)btn{
    TCustomAlertAction *action = self.allActions[btn.tag];
    [self dismiss];
    if (action.actionBlock) {
        action.actionBlock(action);
    }
}

- (void)dismiss{
    [self removeFromSuperview];
    [self.backgroundView removeFromSuperview];
}

#pragma mark - updateConstraints

- (void)updateConstraints{
    
    [self.horizontalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom).offset(-50);
        make.height.equalTo(@0.5);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.equalTo(@(SCREEN_WIDTH-100 - 60));
        make.top.equalTo(self.mas_top).offset(24);
    }];
    
    CGFloat contentLabelToTitleLabel = self.titleLabel.text.length ? 15 : 0;
    
    if (self.titleLabel.text.length) {
        UIView *lineView = [UIView new];
        lineView.backgroundColor = [self colorWithRGBHex:0xE1E1E1 alpha:1.0];
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
            make.height.equalTo(@0.5);
        }];
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.width.equalTo(@(SCREEN_WIDTH-100 - 60));
            make.top.equalTo(lineView.mas_bottom).offset(contentLabelToTitleLabel);
        }];
    }else{
        [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.width.equalTo(@(SCREEN_WIDTH-100 - 60));
            make.top.equalTo(self.titleLabel.mas_bottom).offset(contentLabelToTitleLabel);
        }];
    }
    
    [super updateConstraints];
}

#pragma mark - geter

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textColor = [self colorWithRGBHex:0x4a4a4a alpha:1.0];
        _titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
        _titleLabel.numberOfLines = 0;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
//        _titleLabel.attributedText =
    }
    return _titleLabel;
}

- (NSMutableDictionary *)attributedText{
    if (!_attributedText) {
        _attributedText = [NSMutableDictionary dictionaryWithCapacity:0];
        //基本属性设置
        //字体颜色
        _attributedText[NSForegroundColorAttributeName] = [self colorWithRGBHex:0x4a4a4a alpha:1.0];
        //字号大小
        _attributedText[NSFontAttributeName] = [UIFont fontWithName:@"Helvetica-Bold" size:17];
        //段落样式
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        //行间距
        paraStyle.lineSpacing = 5.0;
        paraStyle.alignment = NSTextAlignmentCenter;
        //首行文本缩进
//        paraStyle.firstLineHeadIndent = 20.0;
        //使用
        //文本段落样式
        _attributedText[NSParagraphStyleAttributeName] = paraStyle;
//        testLabel.attributedText = [[NSAttributedString alloc] initWithString:textContent attributes:textDict];
    }
    return _attributedText;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
        _contentLabel.numberOfLines = 0;
        _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _contentLabel;
}


- (UIView *)horizontalLine{
    if (!_horizontalLine) {
        _horizontalLine = [[UIView alloc]init];
        _horizontalLine.backgroundColor = [self colorWithRGBHex:0xE1E1E1 alpha:1.0];
    }
    return _horizontalLine;
}

- (UIView *)backgroundView{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc]init];
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    }
    return _backgroundView;
}

- (NSMutableArray *)allActions{
    if (!_allActions) {
        _allActions = [NSMutableArray arrayWithCapacity:0];
    }
    return _allActions;
}


- (UIColor *)colorWithRGBHex:(UInt32)hex  alpha:(float)alpha{
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    float al = (alpha >=0 && alpha <= 1.0f) ? alpha : 1.0f;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:al];
}
@end
