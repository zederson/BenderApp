//
//  ViewController.h
//  BenderApp
//
//  Created by Ederson Lima on 11/2/15.
//  Copyright © 2015 Ederson Lima. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZEMessageClient.h"

// libraries
#import <MQTTKit/MQTTKit.h>
#import <DGActivityIndicatorView/DGActivityIndicatorView.h>
#import <MBCircularProgressBar/MBCircularProgressBarView.h>

@interface ViewController : UIViewController

@property (nonatomic, weak) IBOutlet UILabel *labelTemperature;
@property (nonatomic, weak) IBOutlet UIView *viewTemperature;
@property (nonatomic, weak) IBOutlet UIView *viewLuminosity;
@property (nonatomic, weak) IBOutlet UIView *viewSensors;
@property (nonatomic, weak) IBOutlet UIView *activityViewSensors;
@property (nonatomic, strong) DGActivityIndicatorView *activitySensors;

@property (nonatomic, weak) IBOutlet MBCircularProgressBarView *progressLuminosity;

//locals
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSString *> *sensorsValues;
@property (nonatomic, strong) ZEMessageClient *messageClient;

@end

