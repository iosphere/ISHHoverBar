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
    masklayer.fillColor = [[UIColor blackColor] CGColor];
    self.mask = masklayer;
    self.shadowOffset = CGSizeZero;
    return self;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    [super setCornerRadius:cornerRadius];
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

    self.shadowPath = [shadowPath CGPath];
    // using the even odd fill rule we create a path that includes the shadow which contains a path that excludes this layer's shadow path
    CGFloat outsetForShadow = -1 * (fabs(self.shadowOffset.height) + fabs(self.shadowOffset.width) + self.shadowRadius * 2.0);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(outsetForShadow, outsetForShadow, outsetForShadow, outsetForShadow))];
    [maskPath appendPath:shadowPath];
    [self.maskShapeLayer setFrame:self.bounds];
    [self.maskShapeLayer setPath:[maskPath CGPath]];
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
    [self setBackgroundColor:[UIColor clearColor]];
    self.itemsControlsMap = [NSMapTable weakToWeakObjectsMapTable];

    // add shadow layer
    ISHHoverShadowLayer *shadowLayer = [ISHHoverShadowLayer new];
    [self setShadowLayer:shadowLayer];
    [self.layer addSublayer:shadowLayer];

    // add visual effects view as background
    UIVisualEffectView *bgView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
    [self setBackgroundView:bgView];
    [self addSubview:bgView];

    // add separator drawing view on top
    ISHHoverSeparatorView *sepView = [ISHHoverSeparatorView new];
    [self setSeparatorView:sepView];
    [self addSubview:sepView];

    // set default values
    [self setBorderColor:[UIColor lightGrayColor]];
    [self setBorderWidth:1.0 / [[UIScreen mainScreen] scale]];
    [self setCornerRadius:8.0];
    [self setShadowOpacity:0.25];
    [self setShadowColor:[UIColor blackColor]];
    [self setShadowRadius:6.0];
}

- (void)setOrientation:(ISHHoverBarOrientation)orientation {
    if (orientation == _orientation) {
        return;
    }

    _orientation = orientation;
    [self.separatorView setOrientation:orientation];
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
    CGFloat itemLength = ISHHoverBarDefaultItemDimension * (CGFloat)self.items.count;

    switch (self.orientation) {
        case ISHHoverBarOrientationVertical:
            return CGSizeMake(ISHHoverBarDefaultItemDimension, itemLength);

        case ISHHoverBarOrientationHorizontal:
            return CGSizeMake(itemLength, ISHHoverBarDefaultItemDimension);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat yStep = 0;
    CGFloat xStep = 0;
    [self.backgroundView setFrame:self.bounds];
    [self.separatorView setFrame:self.bounds];
    [self.shadowLayer setFrame:self.bounds];

    switch (self.orientation) {
        case ISHHoverBarOrientationVertical:
            yStep = ISHHoverBarDefaultItemDimension;
            break;

        case ISHHoverBarOrientationHorizontal:
            xStep = ISHHoverBarDefaultItemDimension;
            break;
    }

    CGRect frame = CGRectMake(0, 0, ISHHoverBarDefaultItemDimension, ISHHoverBarDefaultItemDimension);

    for (UIControl *control in self.controls) {
        [control setFrame:frame];
        frame = CGRectOffset(frame, xStep, yStep);
    }
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

        [self addSubview:control];
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
    [self.separatorView setViewsToSeparate:controls];
}

#pragma mark - Background view

- (void)setCornerRadius:(CGFloat)cornerRadius {
    [self.backgroundView setClipsToBounds:(cornerRadius != 0)];
    [self.backgroundView.layer setCornerRadius:cornerRadius];
    [self.shadowLayer setCornerRadius:cornerRadius];
}

- (CGFloat)cornerRadius {
    return self.backgroundView.layer.cornerRadius;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    [self.backgroundView.layer setBorderWidth:borderWidth];
    [self.separatorView setSeparatorWidth:borderWidth];
}

- (CGFloat)borderWidth {
    return self.backgroundView.layer.borderWidth;
}

- (void)setBorderColor:(nullable UIColor *)borderColor {
    [self.backgroundView.layer setBorderColor:[borderColor CGColor]];
    [self.separatorView setSeparatorColor:borderColor];
}

- (nullable UIColor *)borderColor {
    if (self.backgroundView.layer.borderColor) {
        return [UIColor colorWithCGColor:self.backgroundView.layer.borderColor];
    }

    return nil;
}

- (nullable UIVisualEffect *)effect {
    return self.backgroundView.effect;
}

- (void)setEffect:(nullable UIVisualEffect *)effect {
    return [self.backgroundView setEffect:effect];
}

#pragma mark - Shadow
- (void)setShadowColor:(nullable UIColor *)shadowColor {
    [self.shadowLayer setShadowColor:[shadowColor CGColor]];
}

- (nullable UIColor *)shadowColor {
    if (self.shadowLayer.shadowColor) {
        return [UIColor colorWithCGColor:self.shadowLayer.shadowColor];
    }

    return nil;
}

- (void)setShadowRadius:(CGFloat)shadowRadius {
    [self.shadowLayer setShadowRadius:shadowRadius];
}

- (CGFloat)shadowRadius {
    return self.shadowLayer.shadowRadius;
}

- (void)setShadowOpacity:(CGFloat)shadowOpacity {
    [self.shadowLayer setShadowOpacity:shadowOpacity];
}

- (CGFloat)shadowOpacity {
    return self.shadowLayer.shadowOpacity;
}

@end
