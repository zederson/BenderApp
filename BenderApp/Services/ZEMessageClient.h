//
//  ZEMessageClient.h
//  BenderApp
//
//  Created by Ederson Lima on 11/3/15.
//  Copyright © 2015 Ederson Lima. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    BenderReadLuminosity,
    BenderReadTemperature,
    BenderCandleLuminosity
} BenderTopic;

@class ZEMessageClient;

@protocol ZeMessageClientDelegate

- (NSArray<NSString *> *) topicsToSubscribes;
- (void) benderHandleMessage: (NSString *) message toTopic:(NSString *) topic;

@end

@interface ZEMessageClient : NSObject

@property (nonatomic, strong) id delegate;

+ (ZEMessageClient *) sharedInstance;
+ (NSString *) benderTopicName: (BenderTopic) topic;

- (void) subscribe;
- (void) publishToTopic: (BenderTopic) topic withMessage: (NSString *) message completionHandler:(void(^) () ) completion;
- (NSString *) host;
- (NSString *) app_name;

@end