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

@interface ViewController ()<ZeMessageClientDelegate>

//outlets de sensores
@property (nonatomic, weak) IBOutlet UILabel *labelTemperature;
@property (nonatomic, weak) IBOutlet UILabel *labelLuminosity;

@property (nonatomic, weak) IBOutlet UIView *viewTemperature;
@property (nonatomic, weak) IBOutlet UIView *viewLuminosity;

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
        NSString *lastValue = [self.sensorsValues objectForKey:topic];
        NSString *value     = message;
        
        if (![topic isEqualToString:lastValue]) {
            UILabel *label = nil;
            if ([@"sensors/temperature" isEqualToString:topic]) {
                label = [self setSensorsValue:self.labelTemperature withText:message format:@"%@"];
            } else if ([@"sensors/luminosity" isEqualToString:topic]) {
                NSNumber *val = @([message floatValue] / 1023 * 100);
                value         = [NSString stringWithFormat:@"%d", [val integerValue]];
                label         = [self setSensorsValue:self.labelLuminosity withText:value format:@"%@ %%"];
            }
        }
        [self.sensorsValues setObject:value forKey:topic];
    });
}

# pragma mark Commons Methods
- (UILabel *) setSensorsValue: (UILabel *) label withText: (NSString *) text format:(NSString *) format {
    label.text = [NSString stringWithFormat:format, text];
    return label;
}

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
}

@end