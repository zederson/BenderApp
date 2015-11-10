//
//  ZEColorPickerView.m
//  BenderApp
//
//  Created by Ederson Lima on 11/10/15.
//  Copyright © 2015 Ederson Lima. All rights reserved.
//

#import "ZEColorPickerView.h"
#import "UIColor+ZEUIColor.h"

#import <NKOColorPickerView/NKOColorPickerView.h>

@interface ZEColorPickerView ()

@property (nonatomic, weak) IBOutlet UIView *colorPicker;
@property (nonatomic, weak) IBOutlet UIButton *buttonApply;

@end

@implementation ZEColorPickerView

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

# pragma mark action button
- (IBAction) back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction) applyColor:(id)sender {
    
}

# pragma mark local methods
- (void) setColor: (UIColor *) color {
    self.buttonApply.backgroundColor = color;
    
    NSString *colorHex = [UIColor hexStringFromColor:color];
    NSLog(@"%@", colorHex);
}

- (void) configureView {
    NKOColorPickerDidChangeColorBlock colorDidChangeBlock = ^(UIColor *color){
        [self setColor:color];
    };
    
    NKOColorPickerView *colorPickerView = [[NKOColorPickerView alloc] initWithFrame:CGRectMake(0, 0, 300, 340)
                                                                              color:[UIColor blueColor]
                                                             andDidChangeColorBlock:colorDidChangeBlock];
    [self.colorPicker addSubview:colorPickerView];
    self.buttonApply.layer.cornerRadius  = 15.0f;
    self.buttonApply.layer.masksToBounds = YES;
}

@end
