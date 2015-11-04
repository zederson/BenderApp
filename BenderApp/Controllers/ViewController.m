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

-(void)benderHandleMessage:(NSString *)message toTopic:(NSString *)topic {
    dispatch_async(dispatch_get_main_queue(), ^{
        UILabel *label = nil;
        if ([@"sensors/temperature" isEqualToString:topic]) {
            label = self.labelTemperature;
        } else if ([@"sensors/luminosity" isEqualToString:topic]) {
            label = self.labelLuminosity;
        }
        label.text = message;
    });
}
@end