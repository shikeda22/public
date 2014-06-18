//
//  SenderViewController.m
//  iBeaconDemo
//
//  Created by Yamashita on 5/15/14.
//  Copyright (c) 2014 Wonderplanet Inc. All rights reserved.
//

#import "SenderViewController.h"
@import CoreLocation;
@import CoreBluetooth;

@interface SenderViewController ()
<
    CBPeripheralManagerDelegate
>
@property(strong, nonatomic) CLBeaconRegion *beaconRegion;
@property(strong, nonatomic) CBPeripheralManager *peripheralManager;
@property(strong, nonatomic) NSDictionary *peripheralData;
@end

@implementation SenderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"F0D63390-862E-4748-8CE1-8ECD12A5E698"];
    self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:uuid
                                                           identifier:@"wonderplanet_ibeacondemo"];
    
    self.peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self
                                                                     queue:dispatch_get_main_queue()];
    self.peripheralData = [self.beaconRegion peripheralDataWithMeasuredPower:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
        [self.peripheralManager startAdvertising:self.peripheralData];
    } else if (peripheral.state == CBPeripheralManagerStatePoweredOff) {
        [self.peripheralManager stopAdvertising];
    }
}

@end
