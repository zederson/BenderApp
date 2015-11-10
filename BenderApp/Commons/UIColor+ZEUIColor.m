//
//  UIColor+ZEUIColor.m
//  BenderApp
//
//  Created by Ederson Lima on 11/10/15.
//  Copyright © 2015 Ederson Lima. All rights reserved.
//

#import "UIColor+ZEUIColor.h"

@implementation UIColor (ZEUIColor)

+ (NSString *)hexStringFromColor:(UIColor *)color
{
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    
    return [NSString stringWithFormat:@"#%02lX%02lX%02lX",
            lroundf(r * 255),
            lroundf(g * 255),
            lroundf(b * 255)];
}

@end