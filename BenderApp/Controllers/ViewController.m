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

@property (nonatomic, strong) IBOutlet UILabel *labelTemperature;
@property (nonatomic, strong) IBOutlet UILabel *labelLuminosity;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ZEMessageClient *messageClient = [ZEMessageClient sharedInstance];
    messageClient.delegate = self;
    [messageClient subscribe];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSArray<NSString *> *)topicsToSubscribes {
    return @[@"sensors/luminosity", @"sensors/temperature"];
}

- (void)benderHandleMessage:(NSString *)message toTopic:(NSString *)topic {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([@"sensors/temperature" isEqualToString:topic]) {
            [self setSensorsValue:self.labelTemperature withText:message format:@"%@º C"];
        } else if ([@"sensors/luminosity" isEqualToString:topic]) {
            NSNumber *val       = @([message floatValue] / 1023 * 100);
            NSString *converted = [NSString stringWithFormat:@"%d", [val integerValue]];
            [self setSensorsValue:self.labelLuminosity withText:converted format:@"%@ %%"];
        }
    });
}

- (void) setSensorsValue: (UILabel *) label withText: (NSString *) text format:(NSString *) format {
    NSString *value = [NSString stringWithFormat:format, text];
    label.text = value;
}

@end