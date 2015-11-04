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
    return @[@"sensors/socket/1", @"sensors/temperature"];
}

-(void)benderHandleMessage:(NSString *)message toTopic:(NSString *)topic {
    NSLog(@"received message %@ - %@", message, topic);
}
@end