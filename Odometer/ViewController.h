//
//  ViewController.h
//  Odometer
//
//  Created by Jay Versluis on 30/11/2015.
//  Copyright © 2015 Pinkstone Pictures LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
@import CoreLocation;

@interface ViewController : UIViewController

@property CLLocationDistance totalDistance;
@property float currentSpeed;

@end

