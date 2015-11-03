//
//  ViewController.m
//  BenderApp
//
//  Created by Ederson Lima on 11/2/15.
//  Copyright © 2015 Ederson Lima. All rights reserved.
//

#import "ViewController.h"
#import <MQTTKit/MQTTKit.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *host = @"cpro25389.publiccloud.com.br";
    NSString *topic = @"sensors/socket/1";
    
    MQTTClient *client = [[MQTTClient alloc] initWithClientId:@"bender_app"];
    
    [client connectToHost:host completionHandler:^(MQTTConnectionReturnCode code) {
        if (code == ConnectionAccepted) {
            [client subscribe:topic withCompletionHandler:nil];
            [client subscribe:@"sensors/temperature" withCompletionHandler:nil];
        }
    }];
    
    [client setMessageHandler:^(MQTTMessage *message) {
        NSString *text = message.payloadString;
        NSLog(@"received message %@ - %@", message.topic, text);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
