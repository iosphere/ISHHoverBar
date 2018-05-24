//
//  ViewController.m
//  ISHHoverBar
//
//  Created by Felix Lamouroux on 11.07.16.
//  Copyright © 2016 iosphere GmbH. All rights reserved.
//

#import "ViewController.h"
@import ISHHoverBar;
@import MapKit;

@interface ViewController ()
@property (weak, nonatomic) IBOutlet ISHHoverBar *hoverbar;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property BOOL isToggled;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *mapBarButton = [[MKUserTrackingBarButtonItem alloc] initWithMapView:self.mapView];
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [infoButton addTarget:self action:@selector(toggleOrientation:) forControlEvents:UIControlEventTouchUpInside];
//    infoButton.layer.backgroundColor = UIColor.greenColor.CGColor;
//    infoButton.layer.masksToBounds = YES;
//    infoButton.layer.cornerRadius = 8;
//    infoButton.backgroundColor = UIColor.greenColor;
//    infoButton.layer.masksToBounds = YES;
    infoButton.clipsToBounds = YES;
    ISHHoverBarItem *infoBarButton = [[ISHHoverBarItem alloc] initWithCustomView:infoButton length:88];
    self.hoverbar.orientation = ISHHoverBarOrientationHorizontal;
    self.isToggled = false;
    (self.hoverbar).items = @[infoBarButton, mapBarButton];
    self.hoverbar.cornerRadius = 8;
}

- (void)toggleOrientation:(UIControl *)sender {
    self.isToggled = !self.isToggled;
    ((ISHHoverBarItem *)self.hoverbar.items[0]).length = self.isToggled ? 44 : 88;
    self.hoverbar.items[0].customView.backgroundColor = self.isToggled ? UIColor.clearColor : UIColor.orangeColor;
    [self.hoverbar reload];
}

@end
