//
//  ViewController.m
//  BenderApp
//
//  Created by Ederson Lima on 11/2/15.
//  Copyright © 2015 Ederson Lima. All rights reserved.
//

#import "ViewController.h"
#import <MQTTKit/MQTTKit.h>
#import "ZEMessageClient.h"
#import <DGActivityIndicatorView/DGActivityIndicatorView.h>
#import <MBCircularProgressBar/MBCircularProgressBarView.h>

@interface ViewController ()<ZeMessageClientDelegate>

//outlets de sensores
@property (nonatomic, weak) IBOutlet UILabel *labelTemperature;

@property (nonatomic, weak) IBOutlet UIView *viewTemperature;
@property (nonatomic, weak) IBOutlet UIView *viewLuminosity;
@property (nonatomic, weak) IBOutlet UIView *viewSensors;
@property (nonatomic, weak) IBOutlet UIView *activityViewSensors;
@property (nonatomic, strong) DGActivityIndicatorView *activitySensors;

@property (nonatomic, weak) IBOutlet MBCircularProgressBarView *progressLuminosity;

//locals
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *sensorsValues;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sensorsValues             = [NSMutableDictionary dictionary];
    ZEMessageClient *messageClient = [ZEMessageClient sharedInstance];
    messageClient.delegate         = self;
    [messageClient subscribe];
    [self configureSensorsViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
    [self animateLabel:self.viewTemperature];
    [self animateLabel:self.viewLuminosity];
}

# pragma mark Bender Messages
- (NSArray<NSString *> *)topicsToSubscribes {
    return @[@"sensors/luminosity", @"sensors/temperature"];
}

- (void)benderHandleMessage:(NSString *)message toTopic:(NSString *)topic {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self stopActivity:self.activitySensors];
        NSString *lastValue = [self.sensorsValues objectForKey:topic];
        if (![topic isEqualToString:lastValue]) {
            if ([@"sensors/temperature" isEqualToString:topic]) {
                self.labelTemperature.text = message;
            } else if ([@"sensors/luminosity" isEqualToString:topic]) {
                [self.progressLuminosity setValue:([message floatValue] / 1023.f * 100.f) animateWithDuration:1];
            }
        }
        [self.sensorsValues setObject:message forKey:topic];
    });
}

# pragma mark Commons Methods

- (void) animateLabel: (UIView *) label {
    label.transform = CGAffineTransformMakeScale(0, 0);
    [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:0.7 options:UIViewAnimationOptionCurveEaseIn animations:^{
        label.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
    }];
}

- (void) configureSensorsViews {
    self.viewTemperature.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_sensors.jpg"]];
    self.viewLuminosity.backgroundColor  = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_sensors.jpg"]];
    
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

- (void) stopActivity: (DGActivityIndicatorView *) activity {
    [activity stopAnimating];
    activity.hidden = YES;
}

@end