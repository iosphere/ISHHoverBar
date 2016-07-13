//
//  ISHHoverBar.h
//  ISHHoverBar
//
//  Created by Felix Lamouroux on 11.07.16.
//  Copyright © 2016 iosphere GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger, ISHHoverBarOrientation) {
    /// In vertical orientation the ISHHoverBar places bar buttons from top to bottom.
    ISHHoverBarOrientationVertical,
    /// In horizontal orientation the ISHHoverBar places bar buttons from left to right.
    ISHHoverBarOrientationHorizontal,
};

/// A UIView subclass similar to UIToolBar but designed to hover over other content.
IB_DESIGNABLE
@interface ISHHoverBar : UIView

/// Array of UIBarButtonItem to be included in the bar. Currently only items with a title, image, or customView of type UIControl are supported.
@property (nonatomic, nullable) IBOutlet NSArray<UIBarButtonItem *> *items;

/// The orientation of the hover bar. Default is ISHHoverBarOrientationVertical.
@property (nonatomic) ISHHoverBarOrientation orientation;

/// The visual effect used for the bar's background. Default is an extra light blur effect.
@property (nonatomic, nullable) UIVisualEffect *effect;

/// The bar's corner radius in points. Default is 8.0 */
@property (nonatomic) IBInspectable CGFloat cornerRadius;

/// The width of the bar's border in points. Default is a hairline stroke.
@property (nonatomic) IBInspectable CGFloat borderWidth;

///  The color of the bar's border. Default is lightGray.
@property (nonatomic, nullable) IBInspectable UIColor *borderColor;

/// The bar's shadow radius in points. Default is 6.
@property (nonatomic) IBInspectable CGFloat shadowRadius;

/// The bar's shadow opacity in points. Default is 0.25.
@property (nonatomic) IBInspectable CGFloat shadowOpacity;

/// The bar's shadow color. Default is black.
@property (nonatomic, nullable) IBInspectable UIColor *shadowColor;

@end
