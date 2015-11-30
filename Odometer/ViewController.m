//
//  ViewController.m
//  Odometer
//
//  Created by Jay Versluis on 30/11/2015.
//  Copyright © 2015 Pinkstone Pictures LLC. All rights reserved.
//

#import "ViewController.h"
@import CoreLocation;

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UILabel *textlabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textlabel.text = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
}

- (void)stopOdometer {
    
    self.textlabel.text = @"Stopped";
}

@end
