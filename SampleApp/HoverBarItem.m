//
//  HoverBarItem.m
//  ISHHoverBar
//
//  Created by Alex Steiner on 24.05.18.
//  Copyright © 2018 iosphere GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HoverBarItem.h"

@interface HoverBarItem ()
@end

@implementation HoverBarItem

- (instancetype)initWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action length:(CGFloat)length {
    self = [super initWithImage:image style:style target:target action:action];
    self.length = length;
    return self;
}


- (instancetype)initWithCustomView:(UIView *)customView length:(CGFloat)length {
    self = [super initWithCustomView:customView];
    self.length = length;
    return self;
}

@end
