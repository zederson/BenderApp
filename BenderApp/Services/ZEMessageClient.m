//
//  ZEMessageClient.m
//  BenderApp
//
//  Created by Ederson Lima on 11/3/15.
//  Copyright © 2015 Ederson Lima. All rights reserved.
//

#import "ZEMessageClient.h"
#import <MQTTKit/MQTTKit.h>

@implementation ZEMessageClient

+(ZEMessageClient *)sharedInstance {
    static ZEMessageClient *instance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[ZEMessageClient alloc] init];
    });
    return instance;
}

+ (NSString *) benderTopicName: (BenderTopic) topic {
    NSArray *arr = @[
                     @"sensors/luminosity",
                     @"sensors/temperature",
                     @"lights/sensor/luminosity",
                     @"lights/off"
                     ];
    return (NSString *)[arr objectAtIndex:topic];
}

- (void) publishToTopic: (BenderTopic) topic withMessage: (NSString *) message completionHandler:(void(^) () ) completion {
    NSString *stringTopic = [ZEMessageClient benderTopicName:topic];
    [self publishToTopicString:stringTopic withMessage:message completionHandler:completion];
}

- (void) publishToTopicString: (NSString *) topic withMessage: (NSString *) message completionHandler:(void(^) () ) completion {
    MQTTClient *client = [self getClient];
    [client publishString:message toTopic:topic withQos:AtLeastOnce retain:NO completionHandler:^(int mid) {
        completion();
    }];
}

- (void) subscribe {
    MQTTClient *client = [self getClient];

    [client connectToHost:[self host] completionHandler:^(MQTTConnectionReturnCode code) {
        if (code == ConnectionAccepted) {
            NSArray<NSString *> *topics = [self.delegate topicsToSubscribes];
            for (NSString *topic in topics) {
                [client subscribe:topic withCompletionHandler:nil];
            }
        }
    }];
    [self handleMessage:client];
}

- (void) handleMessage: (MQTTClient *) client {
    [client setMessageHandler:^(MQTTMessage *message) {
        [self.delegate benderHandleMessage:message.payloadString toTopic:message.topic];
    }];
}

- (MQTTClient *) getClient {
    static MQTTClient *client = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        client = [[MQTTClient alloc] initWithClientId:[self app_name]];
    });
    
    if (!client.connected) {
        [client reconnect];
    }
    
    return client;
}

- (NSString *) host {
    return @"cpro25389.publiccloud.com.br";
}

- (NSString *) app_name {
   return @"bender_app";
}
@end