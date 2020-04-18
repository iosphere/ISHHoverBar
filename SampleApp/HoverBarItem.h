//
//  HoverBarItem.h
//  ISHHoverBar
//
//  Created by Alex Steiner on 24.05.18.
//  Copyright © 2018 iosphere GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
@import ISHHoverBar;

@interface HoverBarItem : UIBarButtonItem <ISHHoverBarItemType>

@property (nonatomic) CGFloat length;

- (instancetype)initWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action length:(CGFloat)length;
- (instancetype)initWithCustomView:(UIView *)customView length:(CGFloat)length;

@end
