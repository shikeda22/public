//
//  ReceiverViewController.m
//  iBeaconDemo
//
//  Created by Yamashita on 5/15/14.
//  Copyright (c) 2014 Wonderplanet Inc. All rights reserved.
//

#import "ReceiverViewController.h"
@import CoreLocation;

@interface ReceiverViewController ()
<
    CLLocationManagerDelegate
>
@property (weak, nonatomic) IBOutlet UILabel *proximityLabel;
@property(strong, nonatomic) CLLocationManager *locationManager;
@property(strong, nonatomic) CLBeaconRegion *beaconRegion;
@property(strong, nonatomic) NSDictionary *proximityDict;
@end

@implementation ReceiverViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 検出するCLBeaconRegionの作成
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"F0D63390-862E-4748-8CE1-8ECD12A5E698"];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                           identifier:@"wonderplanet_ibeacondemo"];
    
    // CLLocationManagerの作成
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager startMonitoringForRegion:self.beaconRegion];
    
    self.proximityDict = @{@(CLProximityImmediate): @"Immediate",
                           @(CLProximityFar): @"Far",
                           @(CLProximityNear): @"Near",
                           @(CLProximityUnknown): @"Unknown"
                           };
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 監視開始
- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    // 開始時に既に領域内に入っているかどうかチェック
    [self.locationManager requestStateForRegion:(CLBeaconRegion *)region];
}

// 現在領域に入っているかどうかの判定
- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    if(state == CLRegionStateInside) {
        [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
    }
}

// 領域に入ったとき
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    [self.locationManager startRangingBeaconsInRegion:(CLBeaconRegion *)region];
}

// 領域から出たとき
- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    [self.locationManager stopMonitoringForRegion:(CLBeaconRegion *)region];
}

// ビーコン情報取得
- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    for(CLBeacon *beacon in beacons) {
        self.proximityLabel.text = self.proximityDict[@(beacon.proximity)];
    }
}

- (void)locationManager:(CLLocationManager *)manager rangingBeaconsDidFailForRegion:(CLBeaconRegion *)region withError:(NSError *)error
{
    NSLog(@"Ranging error: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    NSLog(@"Monitoring error: %@", error);
}

@end
