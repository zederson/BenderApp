//
//  ViewController+ZE_Geofencing.m
//  BenderApp
//
//  Created by Ederson Lima on 12/11/15.
//  Copyright © 2015 Ederson Lima. All rights reserved.
//

#import "ViewController+ZE_Geofencing.h"
#import "ZEGeofenceMonitor.h"

@implementation ViewController (ZE_Geofencing)


- (void) configureGeofencing {
    
    ZEGeofenceMonitor  *gfm     = [ZEGeofenceMonitor sharedObj];
    gfm.logView = self.logView;
    
    [gfm clearGeofences];
    
    NSMutableDictionary *fence1 = [NSMutableDictionary new];
    
    [fence1 setValue:@"Locaweb" forKey:@"identifier"];
    [fence1 setValue:@"-23.606146" forKey:@"latitude"];
    [fence1 setValue:@"-46.7169343" forKey:@"longitude"];
    [fence1 setValue:@"1000" forKey:@"radius"];
    
    if ([gfm checkLocationManager:self]) {
        [gfm addGeofence:fence1];
    }
}

@end
