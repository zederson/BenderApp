//
//  ZEMessageClient.h
//  BenderApp
//
//  Created by Ederson Lima on 11/3/15.
//  Copyright © 2015 Ederson Lima. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZEMessageClient;

@protocol ZeMessageClientDelegate

- (NSArray<NSString *> *) topicsToSubscribes;
- (void) benderHandleMessage: (NSString *) message toTopic:(NSString *) topic;

@end

@interface ZEMessageClient : NSObject

@property (nonatomic, strong) id delegate;

+(ZEMessageClient *) sharedInstance;

- (void) subscribe;
- (NSString *) host;
- (NSString *) app_name;

@end
