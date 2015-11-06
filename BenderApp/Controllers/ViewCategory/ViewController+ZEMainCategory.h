//
//  ViewController+ZEMainCategory.h
//  BenderApp
//
//  Created by Ederson Lima on 11/6/15.
//  Copyright © 2015 Ederson Lima. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (ZEMainCategory)

- (void) configureView;
- (void) configureSensorsViews;
- (void) addActivitySensors;
- (void) animateView: (UIView *) view;
- (void) stopActivity: (DGActivityIndicatorView *) activity;
@end
