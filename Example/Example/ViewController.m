//
//  ViewController.m
//  Example
//
//  Created by 刘鹏i on 2019/7/30.
//  Copyright © 2019 wuhan.musjoy. All rights reserved.
//

#import "ViewController.h"
#import "AgeSliderView.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UILabel *lblIndex;
@property (strong, nonatomic) IBOutlet AgeSliderView *ageSliderView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 主题色
    _ageSliderView.theme = AgeSliderViewTheme_Blue;
    
    // 是否小于50岁
    NSArray *arrAges = @[@"Now", @"50", @"51", @"52", @"53", @"54", @"55", @"56", @"57", @"58", @"59", @"60", @"60+"];
    _ageSliderView.arrAges = arrAges;
    
    _lblIndex.text = arrAges.firstObject;
    
    __weak typeof(self) weakSelf = self;
    _ageSliderView.scrollToIndex = ^(NSInteger index, NSString * _Nonnull strAge) {
        weakSelf.lblIndex.text = [NSString stringWithFormat:@"index:%ld  title:%@", index, strAge];
    };
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // 开始动画
    [_ageSliderView scrollToIndex:6 animation:YES duration:0.1];
}

@end
