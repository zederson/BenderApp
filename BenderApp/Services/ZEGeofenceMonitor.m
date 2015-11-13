//
//  ZEGeofenceMonitor.m
//  BenderApp
//
//  Created by Ederson Lima on 12/11/15.
//  Copyright © 2015 Ederson Lima. All rights reserved.
//

#import "ZEGeofenceMonitor.h"

@implementation ZEGeofenceMonitor

+(ZEGeofenceMonitor *) sharedObj {
    static ZEGeofenceMonitor * shared =nil;
    static dispatch_once_t onceTocken;
    
    dispatch_once(&onceTocken, ^{
        shared = [[ZEGeofenceMonitor alloc] init];
    });
    return shared;
}

-(id) init {
    self = [super init];
    if(self) {
        self.locationManager                 = [[CLLocationManager alloc] init];
        self.locationManager.delegate        = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [self.locationManager requestAlwaysAuthorization];
    }
    return self;
}

- (CLRegion*) dictToRegion:(NSDictionary*)dictionary {
    
    NSString *identifier                    = [dictionary valueForKey:@"identifier"];
    CLLocationDegrees latitude              = [[dictionary valueForKey:@"latitude"] doubleValue];
    CLLocationDegrees longitude             = [[dictionary valueForKey:@"longitude"] doubleValue];
    CLLocationDistance regionRadius         = [[dictionary valueForKey:@"radius"] doubleValue];
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
    
    if(regionRadius > self.locationManager.maximumRegionMonitoringDistance) {
        regionRadius = self.locationManager.maximumRegionMonitoringDistance;
    }
    
    CLRegion *region = [[CLCircularRegion alloc] initWithCenter:centerCoordinate
                                                         radius:regionRadius
                                                     identifier:identifier];
    return region;
}

-(void) controller:(UIViewController *) controller showMessage:(NSString *) message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Geofence"
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [controller presentViewController:alertController animated:YES completion:nil];
}

-(BOOL) checkLocationManager: (UIViewController *) controllerTarget {
    if(![CLLocationManager locationServicesEnabled]) {
        [self controller:controllerTarget showMessage:@"You need to enable Location Services"];
        return FALSE;
    }
    
    if(![CLLocationManager isMonitoringAvailableForClass:[CLRegion class]]) {
        [self controller:controllerTarget showMessage:@"Region monitoring is not available for this Class"];
        return FALSE;
    }
    
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied ||
       [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted  ) {
        [self controller:controllerTarget showMessage:@"You need to authorize Location Services for the APP"];
        return FALSE;
    }
    return TRUE;
}

-(void) addGeofence:(NSDictionary*) dict {
    CLRegion * region = [self dictToRegion:dict];
    [self.locationManager startMonitoringForRegion:region];
}

-(void) findCurrentFence {
    NSArray * monitoredRegions = [self.locationManager.monitoredRegions allObjects];
    for(CLRegion *region in monitoredRegions) {
        [self.locationManager requestStateForRegion:region];
    }
}

-(void) removeGeofence:(NSDictionary*) dict {
    CLRegion * region = [self dictToRegion:dict];
    [self.locationManager stopMonitoringForRegion:region];
}

-(void) clearGeofences {
    NSArray * monitoredRegions = [self.locationManager.monitoredRegions allObjects];
    for(CLRegion *region in monitoredRegions) {
        [self.locationManager stopMonitoringForRegion:region];
    }
}

# pragma mark Delegate

- (void) locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {
    if(state == CLRegionStateInside) {
        self.logView.text = [NSString stringWithFormat:@"%@\nChegamos em %@", self.logView.text, region.identifier];
//        NSLog(@"entramos - %@", region.identifier);
    } else if(state == CLRegionStateOutside) {
//        NSLog(@"##Exited Region - %@", region.identifier);
    } else{
//        NSLog(@"##Unknown state  Region - %@", region.identifier);
    }
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
//    NSLog(@"Started monitoring %@ region", region.identifier);
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
//    NSLog(@"Entered Region - %@", region.identifier);
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
//    NSLog(@"Exited Region - %@", region.identifier);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    static BOOL firstTime = TRUE;
    
    if(firstTime) {
        firstTime                = FALSE;
        NSSet * monitoredRegions = self.locationManager.monitoredRegions;
        if(monitoredRegions) {
            [monitoredRegions enumerateObjectsUsingBlock:^(CLRegion *region,BOOL *stop) {
                 NSString *identifer                  = region.identifier;
                 CLLocationCoordinate2D centerCoords  = region.center;
                 CLLocationDistance radius            = region.radius;
                 CLLocationCoordinate2D currentCoords = CLLocationCoordinate2DMake(newLocation.coordinate.latitude,newLocation.coordinate.longitude);
                 
                 NSNumber * currentLocationDistance = [self calculateDistanceInMetersBetweenCoord:currentCoords coord:centerCoords];
                 if([currentLocationDistance floatValue] < radius) {
                     NSLog(@"Invoking didEnterRegion Manually for region: %@",identifer);

                     [self.locationManager stopMonitoringForRegion:region];
                     [self locationManager:self.locationManager didEnterRegion:region];
                     [self.locationManager startMonitoringForRegion:region];
                 }
             }];
        }
        [self.locationManager stopUpdatingLocation];
    }
}

# pragma mark Helper
- (NSNumber*) calculateDistanceInMetersBetweenCoord:(CLLocationCoordinate2D)coord1 coord:(CLLocationCoordinate2D)coord2 {
    NSInteger nRadius       = 6371; // Earth's radius in Kilometers
    double latDiff          = (coord2.latitude - coord1.latitude) * (M_PI/180);
    double lonDiff          = (coord2.longitude - coord1.longitude) * (M_PI/180);
    double lat1InRadians    = coord1.latitude * (M_PI/180);
    double lat2InRadians    = coord2.latitude * (M_PI/180);
    double nA               = pow ( sin(latDiff/2), 2 ) + cos(lat1InRadians) * cos(lat2InRadians) * pow ( sin(lonDiff/2), 2 );
    double nC               = 2 * atan2( sqrt(nA), sqrt( 1 - nA ));
    double nD               = nRadius * nC;
    return @(nD*1000);
}

@end
