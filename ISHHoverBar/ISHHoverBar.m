//
//  ISHHoverBar.m
//  ISHHoverBar
//
//  Created by Felix Lamouroux on 11.07.16.
//  Copyright © 2016 iosphere GmbH. All rights reserved.
//

#import "ISHHoverBar.h"

const CGFloat ISHHoverBarDefaultItemDimension = 44.0;

#pragma mark ISHHoverShadowLayer

@interface ISHHoverShadowLayer : CALayer
// The mask layer is used to knock out the content of this layer to show the shadow only outside of the shadowPath.
@property (nonatomic, weak, nullable) CAShapeLayer *maskShapeLayer;
@end

@implementation ISHHoverShadowLayer

- (instancetype)init {
    self = [super init];
    CAShapeLayer *masklayer = [CAShapeLayer new];
    self.maskShapeLayer = masklayer;
    masklayer.fillRule = kCAFillRuleEvenOdd;
    masklayer.fillColor = [UIColor blackColor].CGColor;
    self.mask = masklayer;
    self.shadowOffset = CGSizeZero;
    return self;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    super.cornerRadius = cornerRadius;
    [self updateShadowPathAndMask];
}

- (void)layoutSublayers {
    [super layoutSublayers];
    [self updateShadowPathAndMask];
}

- (nonnull UIBezierPath *)bezierPathForShadow {
    return [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.cornerRadius];
}

- (void)updateShadowPathAndMask {
    UIBezierPath *shadowPath = [self bezierPathForShadow];

    self.shadowPath = shadowPath.CGPath;
    // using the even odd fill rule we create a path that includes the shadow which contains a path that excludes this layer's shadow path
    CGFloat outsetForShadow = -1 * (fabs(self.shadowOffset.height) + fabs(self.shadowOffset.width) + self.shadowRadius * 2.0);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(outsetForShadow, outsetForShadow, outsetForShadow, outsetForShadow))];
    [maskPath appendPath:shadowPath];
    (self.maskShapeLayer).frame = self.bounds;
    (self.maskShapeLayer).path = maskPath.CGPath;
}

@end

#pragma mark -
#pragma mark - ISHHoverSeparatorView

@interface ISHHoverSeparatorView : UIView
@property (nonatomic) ISHHoverBarOrientation orientation;
@property (nonatomic, nullable) UIColor *separatorColor;
@property (nonatomic) CGFloat separatorWidth;
@property (nonatomic, nullable) NSArray<UIView *> *viewsToSeparate;
@end

@implementation ISHHoverSeparatorView

- (instancetype)init {
    self = [super init];
    self.backgroundColor = [UIColor clearColor];
    return self;
}

- (void)setOrientation:(ISHHoverBarOrientation)orientation {
    if (orientation == _orientation) {
        return;
    }

    _orientation = orientation;
    [self setNeedsDisplay];
}

- (void)setSeparatorColor:(nullable UIColor *)separatorColor {
    if (separatorColor == _separatorColor) {
        return;
    }

    _separatorColor = separatorColor;
    [self setNeedsDisplay];
}

- (void)setSeparatorWidth:(CGFloat)separatorWidth {
    if (separatorWidth == _separatorWidth) {
        return;
    }

    _separatorWidth = separatorWidth;
    [self setNeedsDisplay];
}

- (void)setViewsToSeparate:(nullable NSArray<UIView *> *)viewsToSeparate {
    if (_viewsToSeparate == viewsToSeparate) {
        return;
    }

    _viewsToSeparate = viewsToSeparate;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    if (!self.separatorWidth || !self.separatorColor) {
        return;
    }

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self.separatorColor setStroke];
    CGContextSetLineWidth(ctx, self.separatorWidth);

    CGFloat xMax = CGRectGetWidth(rect);
    CGFloat yMax = CGRectGetHeight(rect);
    // offset separator position by half the separator width to draw on physical pixels
    // if the separator width is below 1pt
    CGFloat separatorOffset = self.separatorWidth < 1 ? self.separatorWidth / 2.0 : 0;

    for (UIView *view in self.viewsToSeparate) {
        if (view == self.viewsToSeparate.lastObject) {
            // no separator after last view
            break;
        }

        // draw separator after view
        // Convert frame to this coordinate space
        CGRect viewFrame = [view convertRect:view.bounds toView:self];
        CGPoint from, to;

        switch (self.orientation) {
            case ISHHoverBarOrientationVertical: {
                CGFloat y = CGRectGetMaxY(viewFrame) + separatorOffset;
                from = CGPointMake(0, y);
                to = CGPointMake(xMax, y);
                break;
            }

            case ISHHoverBarOrientationHorizontal: {
                CGFloat x = CGRectGetMaxX(viewFrame) + separatorOffset;
                from = CGPointMake(x, 0);
                to = CGPointMake(x, yMax);
                break;
            }
        }

        CGContextMoveToPoint(ctx, from.x, from.y);
        CGContextAddLineToPoint(ctx, to.x, to.y);
        CGContextStrokePath(ctx);
    }
}

@end

#pragma mark -
#pragma mark - ISHHoverBar

@interface ISHHoverBar ()
@property (nonatomic, nonnull) UIVisualEffectView *backgroundView;
@property (nonatomic, nonnull) UIView *backgroundContainerView;
@property (nonatomic, nonnull) ISHHoverSeparatorView *separatorView;
@property (nonatomic, nonnull) ISHHoverShadowLayer *shadowLayer;
@property (nonatomic, nullable) NSArray<UIControl *> *controls;
@property (nonatomic, nullable) NSMapTable<UIControl *, UIBarButtonItem *> *itemsControlsMap;
@end

@implementation ISHHoverBar

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self commonInit];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    [self commonInit];
    return self;
}

- (void)commonInit {
    self.backgroundColor = [UIColor clearColor];
    self.itemsControlsMap = [NSMapTable weakToWeakObjectsMapTable];

    // add shadow layer
    ISHHoverShadowLayer *shadowLayer = [ISHHoverShadowLayer new];
    self.shadowLayer = shadowLayer;
    [self.layer addSublayer:shadowLayer];

    UIView* backgroundContainerView = [[UIView alloc] init];
    self.backgroundContainerView = backgroundContainerView;
    [self addSubview:backgroundContainerView];
    
    // add visual effects view as background
    UIVisualEffectView *bgView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
    self.backgroundView = bgView;
    [self.backgroundContainerView addSubview:bgView];

    // add separator drawing view on top
    ISHHoverSeparatorView *sepView = [ISHHoverSeparatorView new];
    self.separatorView = sepView;
    [self.backgroundContainerView addSubview:sepView];

    // set default values
    self.borderColor = [UIColor lightGrayColor];
    self.borderWidth = 1.0 / [UIScreen mainScreen].scale;
    self.cornerRadius = 8.0;
    self.shadowOpacity = 0.25;
    self.shadowColor = [UIColor blackColor];
    self.shadowRadius = 6.0;
}

- (void)setOrientation:(ISHHoverBarOrientation)orientation {
    if (orientation == _orientation) {
        return;
    }

    _orientation = orientation;
    (self.separatorView).orientation = orientation;
    [self invalidateIntrinsicContentSize];
    [self setNeedsLayout];
}

- (void)setItems:(nullable NSArray<UIBarButtonItem *> *)items {
    if (items == _items) {
        return;
    }

    _items = items;
    [self reloadControls];
    [self invalidateIntrinsicContentSize];
    [self setNeedsLayout];
}

#pragma mark - Layout

- (CGSize)intrinsicContentSize {
    
    CGFloat itemLength = 0.0;
    for (UIBarButtonItem* item in self.items) {
        if ([item isKindOfClass:[ISHHoverBarItem class]]) {
            itemLength += ((ISHHoverBarItem*)item).length;
        } else {
            itemLength += ISHHoverBarDefaultItemDimension;
        }
    }

    switch (self.orientation) {
        case ISHHoverBarOrientationVertical:
            return CGSizeMake(ISHHoverBarDefaultItemDimension, itemLength);

        case ISHHoverBarOrientationHorizontal:
            return CGSizeMake(itemLength, ISHHoverBarDefaultItemDimension);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    (self.backgroundView).frame = self.bounds;
    (self.backgroundContainerView).frame = self.bounds;
    (self.separatorView).frame = self.bounds;
    (self.shadowLayer).frame = self.bounds;
    
    CGFloat yStep = 0;
    CGFloat xStep = 0;
    
    int i = 0;
    for (UIControl *control in self.controls) {
        CGFloat length = ISHHoverBarDefaultItemDimension;
        if ([self.items[i] isKindOfClass:[ISHHoverBarItem class]]) {
            length = ((ISHHoverBarItem*) self.items[i]).length;
        }
        CGRect frame;
        
        switch (self.orientation) {
            case ISHHoverBarOrientationVertical:
                frame = CGRectMake(0, 0, ISHHoverBarDefaultItemDimension, length);
                control.frame = CGRectOffset(frame, xStep, yStep);
                yStep += length;
                break;
                
            case ISHHoverBarOrientationHorizontal:
                frame = CGRectMake(0, 0, length, ISHHoverBarDefaultItemDimension);
                control.frame = CGRectOffset(frame, xStep, yStep);
                xStep += length;
                break;
        }
        i++;
    }
}

-(void)reload {
    [self.separatorView setNeedsDisplay];
    [self invalidateIntrinsicContentSize];
    [self setNeedsLayout];
}

#pragma mark - Control management

- (void)reloadControls {
    [self resetControls];
    NSMutableArray *controls = [NSMutableArray arrayWithCapacity:self.items.count];

    for (UIBarButtonItem *item in self.items) {
        UIControl *control = [self newControlForBarButtonItem:item];
        if (!control) {
            continue;
        }
        [self.backgroundContainerView addSubview:control];
        [controls addObject:control];
        [self.itemsControlsMap setObject:item forKey:control];
    }

    self.controls = [controls copy];
}

- (nullable UIControl *)newControlForBarButtonItem:(nonnull UIBarButtonItem *)item {
    if ([item.customView isKindOfClass:[UIControl class]]) {
        return item.customView;
    }

    if (!item.image && !item.title.length) {
        NSAssert(item.image || item.title.length,
                 @"ISHHoverBar only support bar button items with an image, title or customView (of type UIControl). "
                 @"If you attempted to use a system item, please consider creating your own artwork.");
        return nil;
    }

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];

    if (item.image) {
        [button setImage:item.image forState:UIControlStateNormal];
    }

    if (item.title.length) {
        [button setTitle:item.title forState:UIControlStateNormal];
    }

    [button addTarget:self action:@selector(handleActionForControl:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)handleActionForControl:(nonnull UIControl *)control {
    NSParameterAssert(control);

    if (!control) {
        return;
    }

    // get bar button item
    UIBarButtonItem *item = [self.itemsControlsMap objectForKey:control];
    NSParameterAssert(item.target);
    NSParameterAssert(item.action);

    if (!item.target || !item.action) {
        return;
    }

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    // perform action
    [item.target performSelector:item.action withObject:item];
#pragma clang diagnostic pop
}

- (void)resetControls {
    for (UIControl *control in self.controls) {
        [control removeFromSuperview];
    }

    self.controls = nil;
    [self.itemsControlsMap removeAllObjects];
}

- (void)setControls:(nullable NSArray<UIControl *> *)controls {
    if (controls == _controls) {
        return;
    }

    _controls = controls;
    self.separatorView.viewsToSeparate = controls;
}

#pragma mark - Background view

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.backgroundContainerView.clipsToBounds = (cornerRadius != 0);
    self.backgroundContainerView.layer.cornerRadius = cornerRadius;
    self.shadowLayer.cornerRadius = cornerRadius;
}

- (CGFloat)cornerRadius {
    return self.backgroundContainerView.layer.cornerRadius;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.backgroundContainerView.layer.borderWidth = borderWidth;
    self.separatorView.separatorWidth = borderWidth;
}

- (CGFloat)borderWidth {
    return self.backgroundContainerView.layer.borderWidth;
}

- (void)setBorderColor:(nullable UIColor *)borderColor {
    self.backgroundContainerView.layer.borderColor = borderColor.CGColor;
    self.separatorView.separatorColor = borderColor;
}

- (nullable UIColor *)borderColor {
    if (self.backgroundContainerView.layer.borderColor) {
        return [UIColor colorWithCGColor:self.backgroundContainerView.layer.borderColor];
    }

    return nil;
}

- (nullable UIVisualEffect *)effect {
    return self.backgroundView.effect;
}

- (void)setEffect:(nullable UIVisualEffect *)effect {
    self.backgroundView.effect = effect;
}

#pragma mark - Shadow
- (void)setShadowColor:(nullable UIColor *)shadowColor {
    self.shadowLayer.shadowColor = shadowColor.CGColor;
}

- (nullable UIColor *)shadowColor {
    if (self.shadowLayer.shadowColor) {
        return [UIColor colorWithCGColor:self.shadowLayer.shadowColor];
    }

    return nil;
}

- (void)setShadowRadius:(CGFloat)shadowRadius {
    self.shadowLayer.shadowRadius = shadowRadius;
}

- (CGFloat)shadowRadius {
    return self.shadowLayer.shadowRadius;
}

- (void)setShadowOpacity:(CGFloat)shadowOpacity {
    (self.shadowLayer).shadowOpacity = shadowOpacity;
}

- (CGFloat)shadowOpacity {
    return self.shadowLayer.shadowOpacity;
}

@end
