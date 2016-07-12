//
//  ViewController.m
//  ISHHoverBar
//
//  Created by Felix Lamouroux on 11.07.16.
//  Copyright © 2016 iosphere GmbH. All rights reserved.
//

#import "ViewController.h"
#import "ISHHoverBar.h"
@import MapKit;

@interface ViewController ()
@property (weak, nonatomic) IBOutlet ISHHoverBar *hoverbar;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *mapBarButton = [[MKUserTrackingBarButtonItem alloc] initWithMapView:self.mapView];
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [infoButton addTarget:self action:@selector(toggleOrientation:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *infoBarButton = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
    [self.hoverbar setItems:@[mapBarButton, infoBarButton]];
}

- (void)toggleOrientation:(UIControl *)sender {
    BOOL isHorizontal = (self.hoverbar.orientation == ISHHoverBarOrientationHorizontal);

    [self.hoverbar setOrientation:isHorizontal ? ISHHoverBarOrientationVertical : ISHHoverBarOrientationHorizontal];
}

@end
