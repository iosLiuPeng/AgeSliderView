//
//  AgeSliderView.h
//  FaceSecret
//
//  Created by 刘鹏i on 2019/7/29.
//  Copyright © 2019 musjoy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, AgeSliderViewTheme) {
    AgeSliderViewTheme_Red,
    AgeSliderViewTheme_Blue,
};

IB_DESIGNABLE
@interface AgeSliderView : UIView
@property (nonatomic, assign) AgeSliderViewTheme theme;     ///< 颜色样式
@property (nonatomic, strong) NSArray<NSString *> *arrAges; ///< 每一段的标题
@property (nonatomic, copy) void(^scrollToIndex)(NSInteger index, NSString *strAge);///< 滑动结束回调

/// 滑动到指定位置
- (void)scrollToIndex:(NSInteger)index animation:(BOOL)animation duration:(CGFloat)duration;

@end

NS_ASSUME_NONNULL_END
