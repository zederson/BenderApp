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

- (void)viewWillAppear:(BOOL)animated {
    [self animateView:self.viewTemperature];
    [self animateView:self.viewLuminosity];
    [self animateView:self.bulbContainer];
}

# pragma mark Bender Messages
- (NSArray<NSString *> *)topicsToSubscribes {
    return @[[ZEMessageClient benderTopicName:BenderReadLuminosity],
             [ZEMessageClient benderTopicName:BenderReadTemperature] ];
}

- (void)benderHandleMessage:(NSString *)message toTopic:(NSString *)topic {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self stopActivity:self.activitySensors];
        NSString *lastValue = [self.sensorsValues objectForKey:topic];
        if (![topic isEqualToString:lastValue]) {
            if ([[ZEMessageClient benderTopicName:BenderReadTemperature] isEqualToString:topic]) {
                self.labelTemperature.text = message;
            } else if ([[ZEMessageClient benderTopicName:BenderReadLuminosity] isEqualToString:topic]) {
                [self.progressLuminosity setValue:([message floatValue] / 1023.f * 100.f) animateWithDuration:1];
            }
        }
        [self.sensorsValues setObject:message forKey:topic];
    });
}

# pragma mark Buttons

- (IBAction)openColorPicker:(id)sender {
    [self performSegueWithIdentifier:@"ColorSegue" sender:nil];
}

@end