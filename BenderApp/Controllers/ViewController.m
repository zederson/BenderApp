//
//  ViewController.m
//  BenderApp
//
//  Created by Ederson Lima on 11/2/15.
//  Copyright © 2015 Ederson Lima. All rights reserved.
//
#import "ViewController.h"
#import "ZEMessageClient.h"
#import "ZEColorPickerView.h"

// Category
#import "ViewController+ZEMainCategory.h"
#import "ViewController+ZE_Geofencing.h"

// Libraries
#import <CoreLocation/CoreLocation.h>

@interface ViewController ()<ZeMessageClientDelegate, CLLocationManagerDelegate>


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];
    
    [self configureGeofencing];
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
             [ZEMessageClient benderTopicName:BenderReadTemperature],
             [ZEMessageClient benderTopicName:BenderFanStatus],
             [ZEMessageClient benderTopicName:BenderNotifications] ];
}

- (void)benderHandleMessage:(NSString *)message toTopic:(NSString *)topic {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self stopActivity:self.activitySensors];
        NSString *lastValue = [self.sensorsValues objectForKey:topic];
        if (![topic isEqualToString:lastValue]) {
            [self processTopic:topic withMessage:message];
        }
        [self.sensorsValues setObject:message forKey:topic];
    });
}

# pragma mark Buttons
- (IBAction)openColorPicker:(UIButton *)sender {
    [self performSegueWithIdentifier:@"ColorSegue" sender: sender];
}

- (IBAction)turnOffBulbs:(id)sender {
    [self.messageClient publishToTopic:BenderTurnOffBulbs withMessage:@"" completionHandler:^{
    }];
}

# pragma mark Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ColorSegue"]){
        ZEColorPickerView *controller = segue.destinationViewController;
        
        UIButton *button = (UIButton *) sender;
        controller.targetButton = button;
        controller.bulbId       = button.tag;
    }
}

# pragma mark local methods
- (void) processTopic:(NSString *) topic withMessage: (NSString *) message {
    if ([[ZEMessageClient benderTopicName:BenderReadTemperature] isEqualToString:topic]) {
        self.labelTemperature.text = message;
    } else if ([[ZEMessageClient benderTopicName:BenderReadLuminosity] isEqualToString:topic]) {
        [self.progressLuminosity setValue:([message floatValue] / 1023.f * 100.f) animateWithDuration:1];
    } else if ([[ZEMessageClient benderTopicName:BenderFanStatus] isEqualToString:topic]) {
        if ([message isEqualToString:@"0"]) {
            self.fanLabel.textColor = [UIColor redColor];
        } else {
            self.fanLabel.textColor = [UIColor greenColor];
        }
    } else if ([[ZEMessageClient benderTopicName:BenderNotifications] isEqualToString:topic]) {
        [self localNotification:@"Bender Avisa !" withMessage:message];
    }
}


@end