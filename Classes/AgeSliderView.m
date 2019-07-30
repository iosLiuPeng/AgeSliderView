//
//  AgeSliderView.m
//  FaceSecret
//
//  Created by 刘鹏i on 2019/7/29.
//  Copyright © 2019 musjoy. All rights reserved.
//

#import "AgeSliderView.h"
#import "MJGradientView.h"
#import "UIColor+Utils.h"

@interface AgeSliderView ()
@property (strong, nonatomic) IBOutlet MJGradientView *viewBG;
@property (strong, nonatomic) IBOutlet UIView *viewThumb;
@property (strong, nonatomic) IBOutlet MJGradientView *viewThumbBG;
@property (strong, nonatomic) IBOutlet UILabel *lblThumb;
@property (strong, nonatomic) IBOutlet UILabel *lblLeft;
@property (strong, nonatomic) IBOutlet UILabel *lblRight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lytLeading;

@property (nonatomic, assign) NSInteger currentIndex;   ///< 当前位置
@property (nonatomic, assign) CGFloat originBGWidth;    ///< 背景条宽度
@end

@implementation AgeSliderView
#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadViewFromXib];
        
        [self viewConfig];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self loadViewFromXib];
    }
    return self;
}

- (void)loadViewFromXib
{
    UIView *contentView = [[NSBundle bundleForClass:[self class]] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
    contentView.frame = self.bounds;
    contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight;
    [self addSubview:contentView];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self viewConfig];
}

#pragma mark - Subjoin
- (void)viewConfig
{
    self.backgroundColor = [UIColor clearColor];

    self.currentIndex = 0;
    [self layoutView];
}

- (void)layoutView
{
    CGFloat totalWidth = self.bounds.size.width - self.viewThumb.bounds.size.width;
    CGFloat partWidth = totalWidth / (self.arrAges.count - 1);
    
    CGFloat space = self.viewThumb.center.x - self.viewBG.frame.origin.x - self.viewBG.frame.size.width;
    CGRect frameBG = self.viewBG.frame;

    // 先立即更新frame能看到效果
    CGRect frame = self.viewThumb.frame;
    frame.origin.x = _currentIndex * partWidth;
    self.viewThumb.frame = frame;
    
    // 计算背景条的宽度
    frameBG.size.width = self.viewThumb.center.x - space * 2.0;
    self.viewBG.frame = frameBG;
    
    // 再设置约束，保证视图更新后位置也是正确的
    _lytLeading.constant = _currentIndex * partWidth;
}

#pragma mark - Setter
- (void)setTheme:(AgeSliderViewTheme)theme
{
    switch (theme) {
        case AgeSliderViewTheme_Red:
            _viewBG.beginColor = [UIColor colorFromHexRGB:@"FA7F3C"];
            _viewBG.endColor = [UIColor colorFromHexRGB:@"E30D84"];
            _viewThumbBG.beginColor = [UIColor colorFromHexRGB:@"F94483"];
            _viewThumbBG.endColor = [UIColor colorFromHexRGB:@"FA825F"];
            break;
        case AgeSliderViewTheme_Blue:
            _viewBG.beginColor = [UIColor colorFromHexRGB:@"543DED"];
            _viewBG.endColor = [UIColor colorFromHexRGB:@"5DA6FC"];
            _viewThumbBG.beginColor = [UIColor colorFromHexRGB:@"88B8F3"];
            _viewThumbBG.endColor = [UIColor colorFromHexRGB:@"908DF3"];
            break;
        default:
            break;
    }
}

- (void)setArrAges:(NSArray<NSString *> *)arrAges
{
    _arrAges = arrAges;
    
    _lblLeft.text = arrAges.firstObject;
    _lblRight.text = arrAges.lastObject;
    
    self.currentIndex = _currentIndex;
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    if (_currentIndex != currentIndex) {
        if (_scrollToIndex) {
            _scrollToIndex(currentIndex, _arrAges[currentIndex]);
        }
    }
    
    _currentIndex = currentIndex;
    
    if (currentIndex < _arrAges.count) {
        _lblThumb.text = _arrAges[currentIndex];
    } else {
        _lblThumb.text = @"";
    }
}

#pragma mark - Action
- (IBAction)sliderAction:(UIPanGestureRecognizer *)sender
{
    CGPoint translatePoint = [sender translationInView:self];
    
    CGFloat totalWidth = self.bounds.size.width - self.viewThumb.bounds.size.width;
    CGFloat originX = sender.view.frame.origin.x - sender.view.transform.tx;

    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            sender.view.transform = CGAffineTransformIdentity;
            _originBGWidth = self.viewBG.frame.size.width;
        case UIGestureRecognizerStateChanged:
            if (originX + translatePoint.x >= 0 && originX + translatePoint.x <= totalWidth) {
                // 滑块
                sender.view.transform = CGAffineTransformMakeTranslation(translatePoint.x, 0);
                // 背景条
                CGRect frameBG = self.viewBG.frame;
                frameBG.size.width = _originBGWidth + translatePoint.x;
                self.viewBG.frame = frameBG;
            }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
            sender.view.center = CGPointMake(sender.view.center.x + sender.view.transform.tx, sender.view.center.y);
            sender.view.transform = CGAffineTransformIdentity;
            break;
        default:
            break;
    }
    
    CGFloat partWidth = totalWidth / (self.arrAges.count - 1);
    NSInteger index = round(sender.view.frame.origin.x / partWidth);
    self.currentIndex = index;
    
    switch (sender.state) {
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
            [self layoutView];
            break;
        default:
            break;
    }
}

#pragma mark - Overwrite
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self layoutView];
}

#pragma mark - Public
/// 滑动到指定位置
- (void)scrollToIndex:(NSInteger)index animation:(BOOL)animation duration:(CGFloat)duration
{
    if (animation) {
        [self startAnimtion:index duration:duration];
    } else {
        self.currentIndex = index;
        [self layoutView];
    }
}

#pragma mark - Animation
/// 开始动画
- (void)startAnimtion:(NSInteger)index duration:(CGFloat)duration
{
    if (_arrAges.count < 2 && index >= 0 && index < _arrAges.count - 1) {
        return;
    }
    
    CGFloat totalWidth = self.bounds.size.width - self.viewThumb.bounds.size.width;
    CGFloat partWidth = totalWidth / (self.arrAges.count - 1);
    
    CGFloat half = self.viewThumb.bounds.size.width / 2.0;
    CGFloat centerY = self.viewThumb.center.y;
    
    CGFloat leftCenterX = half;
    CGFloat rightCenterX = totalWidth + half;
    CGFloat endCenterX = index * partWidth + half;
    
    self.userInteractionEnabled = NO;
    
    self.viewThumb.center = CGPointMake(leftCenterX, centerY);
    
    CGFloat space = self.viewThumb.center.x - self.viewBG.frame.origin.x - self.viewBG.frame.size.width;
    CGRect frameBG = self.viewBG.frame;
    frameBG.size.width = self.viewThumb.center.x - space * 2.0;
    self.viewBG.frame = frameBG;
        
    [UIView animateWithDuration:duration * (_arrAges.count - 1) delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        // 前进
        self.viewThumb.center = CGPointMake(rightCenterX, centerY);
        
        CGRect frameBG = self.viewBG.frame;
        frameBG.size.width = self.viewThumb.center.x - space * 2.0;
        self.viewBG.frame = frameBG;
    } completion:^(BOOL finished) {
        // 返回
        [UIView animateWithDuration:duration * (self.arrAges.count - 1 - index) delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.viewThumb.center = CGPointMake(endCenterX, centerY);
            
            CGRect frameBG = self.viewBG.frame;
            frameBG.size.width = self.viewThumb.center.x - space * 2.0;
            self.viewBG.frame = frameBG;
        } completion:^(BOOL finished) {
            self.userInteractionEnabled = YES;
        }];
    }];
    
    // 前进计数
    [NSTimer scheduledTimerWithTimeInterval:duration repeats:YES block:^(NSTimer * _Nonnull timer1) {
        self.currentIndex += 1;

        if (self.currentIndex == self.arrAges.count - 1) {
            [timer1 invalidate];
            
            // 返回计数
            [NSTimer scheduledTimerWithTimeInterval:duration repeats:YES block:^(NSTimer * _Nonnull timer2) {
                self.currentIndex -= 1;
                if (self.currentIndex == index) {
                    [timer2 invalidate];
                }
            }];
        }
    }];
}

@end
