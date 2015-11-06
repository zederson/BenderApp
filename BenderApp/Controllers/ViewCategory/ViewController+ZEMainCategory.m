//
//  ViewController+ZEMainCategory.m
//  BenderApp
//
//  Created by Ederson Lima on 11/6/15.
//  Copyright © 2015 Ederson Lima. All rights reserved.
//

#import "ViewController+ZEMainCategory.h"
#import "ZEMessageClient.h"

@implementation ViewController (ZEMainCategory)

- (void) configureView {
    self.sensorsValues             = [NSMutableDictionary dictionary];
    ZEMessageClient *messageClient = [ZEMessageClient sharedInstance];
    messageClient.delegate         = self;
    [messageClient subscribe];
    [self configureSensorsViews];
}

- (void) configureSensorsViews {
    self.viewTemperature.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_sensors_2.jpg"]];
    self.viewLuminosity.backgroundColor  = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_sensors_2.jpg"]];
    
    self.viewTemperature.layer.cornerRadius  = 15.0f;
    self.viewTemperature.layer.masksToBounds = YES;
    
    self.viewLuminosity.layer.cornerRadius   = 15.0f;
    self.viewLuminosity.layer.masksToBounds  = YES;
    [self addActivitySensors];
    
}

- (void) addActivitySensors {
    self.activitySensors = [[DGActivityIndicatorView alloc]
                            initWithType:DGActivityIndicatorAnimationTypeCookieTerminator
                            tintColor:[UIColor cyanColor] size:20.0f];
    
    self.activitySensors.frame = CGRectMake(0.0f, 0.0f, 50.0f, 50.0f);
    [self.activityViewSensors addSubview:self.activitySensors];
    [self.activitySensors startAnimating];
}

- (void) animateView: (UIView *) view {
    view.transform = CGAffineTransformMakeScale(0, 0);
    [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:0.7 options:UIViewAnimationOptionCurveEaseIn animations:^{
        view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
    }];
}

- (void) stopActivity: (DGActivityIndicatorView *) activity {
    [activity stopAnimating];
    activity.hidden = YES;
}
@end
