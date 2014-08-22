//
//  CMViewController.h
//  ColorModel
//
//  Created by Hoan Tran on 7/10/14.
//  Copyright (c) 2014 mophie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMColor.h"
#import "CMColorView.h"

@interface CMViewController : UIViewController <UIActivityItemSource>

@property (strong,nonatomic) CMColor *colorModel;

@property (weak, nonatomic) IBOutlet UILabel *hueLabel;
@property (weak, nonatomic) IBOutlet UILabel *saturationLabel;
@property (weak, nonatomic) IBOutlet UILabel *brightnessLabel;
@property (weak, nonatomic) IBOutlet UILabel *webLabel;

@property (weak,nonatomic) IBOutlet CMColorView *colorView;

- (IBAction)changeHue:(UISlider*)sender;
- (IBAction)changeSaturation:(UISlider*)sender;
- (IBAction)changeBrightness:(UISlider*)sender;

- (IBAction)share:(id)sender;

@end
