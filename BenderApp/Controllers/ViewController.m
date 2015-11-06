//
//  ViewController.m
//  BenderApp
//
//  Created by Ederson Lima on 11/2/15.
//  Copyright © 2015 Ederson Lima. All rights reserved.
//
#import "ViewController.h"
#import "ZEMessageClient.h"

// Category
#import "ViewController+ZEMainCategory.h"

@interface ViewController ()<ZeMessageClientDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
    [self animateView:self.viewTemperature];
    [self animateView:self.viewLuminosity];
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


@end