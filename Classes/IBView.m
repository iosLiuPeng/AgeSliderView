//
//  IBView.m
//  WordFun
//
//  Created by 刘鹏i on 2018/6/21.
//  Copyright © 2018年 musjoy. All rights reserved.
//

#import "IBView.h"

@implementation IBView
- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    
    self.layer.cornerRadius = cornerRadius;
}

- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
    
    if (borderColor == nil) {
        self.layer.borderWidth = 0.0;
        self.layer.borderColor = [UIColor clearColor].CGColor;
    } else {
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = borderColor.CGColor;
    }
}

- (void)setShadowColor:(UIColor *)shadowColor
{
    _shadowColor = shadowColor;
    self.layer.shadowColor = shadowColor.CGColor;
}

- (void)setShadowOffset:(CGSize)shadowOffset
{
    _shadowOffset = shadowOffset;
    self.layer.shadowOffset = shadowOffset;
}

- (void)setShadowOpacity:(CGFloat)shadowOpacity
{
    _shadowOpacity = shadowOpacity;
    self.layer.shadowOpacity = shadowOpacity;
}

- (void)setShadowRadius:(CGFloat)shadowRadius
{
    _shadowRadius = shadowRadius;
    self.layer.shadowRadius = shadowRadius;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_cornerCoefficient > 0 && _cornerRadius <= 0) {
        self.layer.cornerRadius = self.bounds.size.height * _cornerCoefficient;
    }
    
    if (_semicircle) {
        self.layer.cornerRadius = self.bounds.size.height / 2.0;
    }
}

@end
