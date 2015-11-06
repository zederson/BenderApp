//
//  ViewController+ZEMainCategory.m
//  BenderApp
//
//  Created by Ederson Lima on 11/6/15.
//  Copyright © 2015 Ederson Lima. All rights reserved.
//

#import "ViewController+ZEMainCategory.h"
#import "ZEMessageClient.h"

// framework
#import "SCLAlertView.h"

@implementation ViewController (ZEMainCategory)

- (void) configureView {
    self.sensorsValues             = [NSMutableDictionary dictionary];
    ZEMessageClient *messageClient = [ZEMessageClient sharedInstance];
    messageClient.delegate         = self;
    [messageClient subscribe];
    [self configureSensorsViews];
    [self configureTouchToLuminosityView];
    
}

- (void) configureSensorsViews {
    self.viewTemperature.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_sensors_2.jpg"]];
    self.viewLuminosity.backgroundColor  = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_sensors_2.jpg"]];
    
    self.viewTemperature.layer.cornerRadius  = 15.0f;
    self.viewTemperature.layer.masksToBounds = YES;
    
    self.viewLuminosity.layer.cornerRadius   = 15.0f;
    self.viewLuminosity.layer.masksToBounds  = YES;
    [self addActivitySensors];
    
}

- (void) addActivitySensors {
    self.activitySensors = [[DGActivityIndicatorView alloc]
                            initWithType:DGActivityIndicatorAnimationTypeCookieTerminator
                            tintColor:[UIColor cyanColor] size:20.0f];
    
    self.activitySensors.frame = CGRectMake(0.0f, 0.0f, 50.0f, 50.0f);
    [self.activityViewSensors addSubview:self.activitySensors];
    [self.activitySensors startAnimating];
}

- (void) animateView: (UIView *) view {
    view.transform = CGAffineTransformMakeScale(0, 0);
    [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:0.7 options:UIViewAnimationOptionCurveEaseIn animations:^{
        view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
    }];
}

- (void) stopActivity: (DGActivityIndicatorView *) activity {
    [activity stopAnimating];
    activity.hidden = YES;
}

- (void) configureTouchToLuminosityView {
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLuminosityPress:)];
    [self.viewLuminosity addGestureRecognizer:longPress];
}

- (void) handleLuminosityPress :(UITapGestureRecognizer *)recognizer {
    if (recognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    NSString *kSuccessTitle = @"Luminosidade";
    NSString *kButtonTitle  = @"Voltar";
    NSString *kSubtitle     = @"Ativar controle de intensidade das luzes através do sensor de luminosidade?";
    SCLAlertView *alert     = [[SCLAlertView alloc] initWithNewWindow];
    alert.soundURL          = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/button.mp3", [NSBundle mainBundle].resourcePath]];
    
    [alert addButton:@"Ativar" actionBlock:^(void) {
    }];
    
    [alert addButton:@"Desativar" actionBlock:^(void) {
    }];
    
    [alert showInfo:kSuccessTitle subTitle:kSubtitle closeButtonTitle:kButtonTitle duration:0.0f];
}

@end
