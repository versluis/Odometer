//
//  ViewController.m
//  Odometer
//
//  Created by Jay Versluis on 30/11/2015.
//  Copyright © 2015 Pinkstone Pictures LLC. All rights reserved.
//

#import "ViewController.h"
@import CoreLocation;

@interface ViewController () <CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *textlabel;
@property (strong, nonatomic) CLLocationManager *manager;
@property (strong, nonatomic) CLLocation *previousLocation;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textlabel.text = nil;
    
    // beg for location usage
    [self.manager requestAlwaysAuthorization];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CLLocationManager *)manager {
    
    if (!_manager) {
        _manager = [[CLLocationManager alloc]init];
        _manager.delegate = self;
    }
    return _manager;
}

- (IBAction)startStopButtonPressed:(id)sender {
    
    // let's toggle this guy
    if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"Start"]) {
        self.navigationItem.rightBarButtonItem.title = @"Stop";
        // start Odometer
        [self startOdometer];
    } else {
        self.navigationItem.rightBarButtonItem.title = @"Start";
        // stop Odometer
        [self stopOdometer];
    }
}

- (void)startOdometer {
    
    self.textlabel.text = @"Measuring...";
    
    // start location manager
    [self.manager startUpdatingLocation];
    
}

- (void)stopOdometer {
    
    self.textlabel.text = @"Stopped";
    
    // stop location manager
    [self.manager stopUpdatingLocation];
}

#pragma mark - Location Manager Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    NSLog(@"Location Update received...");
    [self calculateDistanceForLocation:locations.lastObject];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    NSLog(@"Nothing works - like always!");
    NSLog(@"Description: %@\nReason: %@", error.localizedDescription, error.localizedFailureReason);
}

- (void)calculateDistanceForLocation:(CLLocation *)currentLocation {
    
    // do we have a previous location?
    if (!self.previousLocation) {
        self.previousLocation = currentLocation;
        return;
    }
    
    // how much time has passed between loation updates?
    // NSTimeInterval duration = [self.previousLocation.timestamp timeIntervalSinceDate:currentLocation.timestamp];
    
    // what's the distance between locations (in meters)?
    CLLocationDistance distance = [self.previousLocation distanceFromLocation:currentLocation];
    
    // turn it into kilometers per hour
    distance = distance * 3.6;
    
    // update label
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    formatter.maximumFractionDigits = 0;
    formatter.minimumIntegerDigits = 1;
    
    NSString *distanceText = [NSString stringWithFormat:@"%@ k/ph", [formatter stringFromNumber:[NSNumber numberWithFloat:distance]]];
    self.textlabel.text = distanceText;
    
    // store current location as previous
    self.previousLocation = currentLocation;
    
}

@end
