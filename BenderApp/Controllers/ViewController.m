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

@property (nonatomic, weak) IBOutlet UILabel *labelTemperature;
@property (nonatomic, weak) IBOutlet UILabel *infoLabelTemperature;
@property (nonatomic, weak) IBOutlet UILabel *labelLuminosity;
@property (nonatomic, weak) IBOutlet UILabel *infoLabelLuminosity;
@property (nonatomic, weak) IBOutlet UIView *viewSensors;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ZEMessageClient *messageClient = [ZEMessageClient sharedInstance];
    messageClient.delegate = self;
    [messageClient subscribe];
    
    self.viewSensors.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_sensors.jpg"]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
    [self animateLabel:self.labelLuminosity];
    [self animateLabel:self.infoLabelLuminosity];
    [self animateLabel:self.labelTemperature];
    [self animateLabel:self.infoLabelTemperature];
}

# pragma mark Bender Messages
- (NSArray<NSString *> *)topicsToSubscribes {
    return @[@"sensors/luminosity", @"sensors/temperature"];
}

- (void)benderHandleMessage:(NSString *)message toTopic:(NSString *)topic {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([@"sensors/temperature" isEqualToString:topic]) {
            [self setSensorsValue:self.labelTemperature withText:message format:@"%@"];
        } else if ([@"sensors/luminosity" isEqualToString:topic]) {
            NSNumber *val       = @([message floatValue] / 1023 * 100);
            NSString *converted = [NSString stringWithFormat:@"%d", [val integerValue]];
            [self setSensorsValue:self.labelLuminosity withText:converted format:@"%@ %%"];
        }
    });
}

# pragma mark Local Methods
- (void) setSensorsValue: (UILabel *) label withText: (NSString *) text format:(NSString *) format {
    NSString *value = [NSString stringWithFormat:format, text];
    label.text = value;
}

- (void) animateLabel: (UILabel *) label {
    label.transform = CGAffineTransformMakeScale(0, 0);
    [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:0.7 options:UIViewAnimationOptionCurveEaseIn animations:^{
        label.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
    }];
}

@end