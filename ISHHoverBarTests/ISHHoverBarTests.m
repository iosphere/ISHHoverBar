//
//  ISHHoverBarTests.m
//  ISHHoverBarTests
//
//  Created by Felix Lamouroux on 11.07.16.
//  Copyright © 2016 iosphere GmbH. All rights reserved.
//

@import XCTest;
@import ISHHoverBar;

#import "ISHHoverBar+Tests.h"

@interface ISHHoverBarTests : XCTestCase
@property (nonatomic) ISHHoverBar *hoverBar;
@property (nonatomic) NSMutableArray <UIBarButtonItem *> *firedItems;
@end

@implementation ISHHoverBarTests

- (void)setUp {
    [super setUp];
    self.hoverBar = [ISHHoverBar new];
    self.firedItems = [NSMutableArray new];
}

- (void)tearDown {
    [super tearDown];
    self.hoverBar = nil;
    self.firedItems = nil;
}

- (void)selectorForControl:(UIBarButtonItem *)item {
    XCTAssertNotNil(item);
    XCTAssertEqualObjects(item.class, [UIBarButtonItem class]);

    if (item) {
        [self.firedItems addObject:item];
    }
}

- (void)setupDefaultItems {
    SEL selector = @selector(selectorForControl:);

    self.hoverBar.items = @[[[UIBarButtonItem alloc] initWithTitle:@"1" style:UIBarButtonItemStylePlain target:self action:selector],
                            [[UIBarButtonItem alloc] initWithTitle:@"2" style:UIBarButtonItemStylePlain target:self action:selector]];
}

- (void)testInitializers {
    ISHHoverBar *initPlain = [ISHHoverBar new];
    ISHHoverBar *initFrame = [[ISHHoverBar alloc] initWithFrame:CGRectZero];
    NSArray *bars = @[initPlain, initFrame];

    for (ISHHoverBar *bar in bars) {
        // after initialization we expect to have one subview (background)
        XCTAssertEqual(bar.subviews.count, 2);

        // Test defaults
        XCTAssertEqual(bar.borderWidth, 1.0/[[UIScreen mainScreen] scale]);
        XCTAssertEqualObjects(bar.borderColor, [UIColor lightGrayColor]);
        XCTAssertEqual(bar.cornerRadius, 8);
        XCTAssertNotNil(bar.effect);
    }
}

- (void)testIntrinsicContentSize {
    [self setupDefaultItems];
    self.hoverBar.orientation = ISHHoverBarOrientationVertical;
    CGSize verticalSize = [self.hoverBar intrinsicContentSize];
    XCTAssertTrue(verticalSize.height > verticalSize.width, @"ISHHoverBarOrientationVertical with two items should yield a hover bar that is higher than wide: %@", NSStringFromCGSize(verticalSize));

    self.hoverBar.orientation = ISHHoverBarOrientationHorizontal;
    CGSize horizontalSize = [self.hoverBar intrinsicContentSize];
    XCTAssertTrue(horizontalSize.height < horizontalSize.width, @"ISHHoverBarOrientationHorizontal with two items should yield a hover bar that is wider than high: %@", NSStringFromCGSize(horizontalSize));
}

- (void)testControlTargets {
    [self setupDefaultItems];
    // we expect to have one UIControl per item
    XCTAssertEqual(self.hoverBar.controls.count, 2);

    for (UIControl *control in self.hoverBar.controls) {
        XCTAssertNotNil(control.superview);
        [control sendActionsForControlEvents:UIControlEventTouchUpInside];
    }

    for (UIBarButtonItem *item in self.hoverBar.items) {
        XCTAssertTrue([self.firedItems containsObject:item], @"item should fire it's action: %@", item.title);
    }
}

- (void)testReloadingControls {
    [self setupDefaultItems];

    // check that previous views were correctly removed
    // we expect to have one per item plus background and separator
    NSUInteger expectedViewCount = self.hoverBar.items.count + 2;

    XCTAssertEqual(self.hoverBar.subviews.count, expectedViewCount);

    // run setup a second time to set the items again
    [self setupDefaultItems];

    XCTAssertEqual(self.hoverBar.subviews.count, expectedViewCount);
}

- (void)testControlsLayout {
    [self setupDefaultItems];
    [self.hoverBar layoutIfNeeded];

    // we expect to have on UIControl per items
    XCTAssertEqual(self.hoverBar.controls.count, 2);
    CGRect lastControlFrame = CGRectZero;

    for (UIControl *control in self.hoverBar.controls) {
        XCTAssertNotNil(control.superview);
        CGRect controlFrame = [control frame];
        XCTAssertFalse(CGRectIsEmpty(controlFrame));
        XCTAssertFalse(CGRectEqualToRect(controlFrame, lastControlFrame), @"Two controls should not be equal, but: %@ = %@", NSStringFromCGRect(controlFrame), NSStringFromCGRect(lastControlFrame));
        XCTAssertTrue(CGRectIsEmpty(CGRectIntersection(controlFrame, lastControlFrame)), @"The intersection between two controls should be empty, but %@ | %@", NSStringFromCGRect(controlFrame), NSStringFromCGRect(lastControlFrame));
        lastControlFrame = controlFrame;
    }
}

- (void)testAssertionForSystemItems {
    UIBarButtonItem *systemItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(selectorForControl:)];

    XCTAssertThrows([self.hoverBar setItems:@[systemItem]]);
}

- (void)testAccessibilityValuesSet {
    
    UIBarButtonItem *accessibleItem = [[UIBarButtonItem alloc] initWithTitle:@"1" style:UIBarButtonItemStylePlain target:nil action:nil];
    accessibleItem.accessibilityLabel = @"Label";
    accessibleItem.accessibilityHint = @"Hint";
    accessibleItem.accessibilityValue = @"1";
    [self.hoverBar setItems:@[accessibleItem]];
    
    
    XCTAssertEqualObjects(self.hoverBar.controls.firstObject.accessibilityLabel, @"Label", @"The first control's accessibility label should be set correctly");
    XCTAssertEqualObjects(self.hoverBar.controls.firstObject.accessibilityHint, @"Hint", @"The first control's accessibility hint should be set correctly");
    XCTAssertEqualObjects(self.hoverBar.controls.firstObject.accessibilityValue, @"1", @"The first control's accessibility value should be set correctly");
}

@end
