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


@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;
@property (strong, nonatomic) IBOutlet UILabel *unitLabel;

@property (strong, nonatomic) CLLocationManager *manager;
@property (strong, nonatomic) CLLocation *previousLocation;
@property (nonatomic, strong) NSArray *units;
@property (nonatomic, strong) NSString *chosenUnit;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.distanceLabel.text = @"0.00";
    
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

- (NSArray *)units {
    
    if (!_units) {
        _units = @[@"kilometers per hour",
                   @"miles per hour",
                   @"meters per second"];
    }
    return _units;
}

- (NSString *)chosenUnit {
    
    if (!_chosenUnit) {
        _chosenUnit = [self.units objectAtIndex:0];
    }
    return _chosenUnit;
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
    
    self.distanceLabel.text = @"0.00";
    
    // start location manager
    [self.manager startUpdatingLocation];
    
}

- (void)stopOdometer {
    
    self.distanceLabel.text = @"0.00";
    
    // stop location manager
    [self.manager stopUpdatingLocation];
}

- (IBAction)changeUnitButtonPressed:(id)sender {
    
    // display a list of other units to measure speed
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:[self.units objectAtIndex:0] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.chosenUnit = [self.units objectAtIndex:0];
        self.unitLabel.text = self.chosenUnit;
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:[self.units objectAtIndex:1] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.chosenUnit = [self.units objectAtIndex:1];
        self.unitLabel.text = self.chosenUnit;
    }];
    
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:[self.units objectAtIndex:2] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.chosenUnit = [self.units objectAtIndex:2];
        self.unitLabel.text = self.chosenUnit;
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Never mind" style:UIAlertActionStyleDestructive handler:nil];
    
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Change unit of measuring into..." message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [controller addAction:action1];
    [controller addAction:action2];
    [controller addAction:action3];
    [controller addAction:cancel];
    
    [self presentViewController:controller animated:YES completion:^{
        // do something on completion
    }];
    
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
    
    // turn it into chosen unit
    distance = [self tweakDistance:distance];
    
    // update label
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    formatter.minimumFractionDigits = 2;
    formatter.maximumFractionDigits = 2;
    formatter.minimumIntegerDigits = 1;
    
    NSString *distanceText = [formatter stringFromNumber:[NSNumber numberWithFloat:distance]];
    self.distanceLabel.text = distanceText;
    
    // store current location as previous
    self.previousLocation = currentLocation;
    
}

- (CLLocationDistance)tweakDistance:(CLLocationDistance)currentDistance {
    
    // see what the user wants to see and re-calculate the distance
    // we're receiving meters per second
    
    // kph
    if ([self.chosenUnit isEqualToString:[self.units objectAtIndex:0]]) {
        return currentDistance * 3.6;
    }
    
    // mph
    if ([self.chosenUnit isEqualToString:[self.units objectAtIndex:1]]) {
        return currentDistance * 2.23694;
    }
    
    // meters per second - return as is
    return currentDistance;
}

@end
