//
//  ZEGeofenceMonitor.h
//  BenderApp
//
//  Created by Ederson Lima on 12/11/15.
//  Copyright © 2015 Ederson Lima. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ZEGeofenceMonitor : NSObject<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) UITextView *logView;

+(ZEGeofenceMonitor *) sharedObj;

- (void) addGeofence:(NSDictionary*) dict;
- (void) removeGeofence:(NSDictionary*) dict;
- (void) clearGeofences;
- (void) findCurrentFence;
- (BOOL) checkLocationManager: (UIViewController *) controllerTarget;

@end