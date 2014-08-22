//
//  CMViewController.m
//  ColorModel
//
//  Created by Hoan Tran on 7/10/14.
//  Copyright (c) 2014 mophie. All rights reserved.
//

#import "CMViewController.h"

@interface CMViewController ()

//- (void) updateColor;

@end

@implementation CMViewController

- (id) activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType
{
    CMColor *color = self.colorModel;
    NSString *message = nil;
    if ([activityType isEqualToString:UIActivityTypePostToTwitter] ||
        [activityType isEqualToString:UIActivityTypePostToWeibo]) {
        message = [NSString stringWithFormat:
                   @"Today's color is RGG=%@."
                   @"An iOS to do this!"
                   @"@LearniOS",
                   [color rgbCodeWithPrefix:nil]];
    }
    else if ([activityType isEqualToString:UIActivityTypeMail]) {
        message = [NSString stringWithFormat:
                   @"Hello,\n\n"
                   @"I wrote an awesome iOS app that lets me share"
                   @"a color with my friends.\n\n"
                   @"Here's my color (see attachment): hue=%.0f\u00b0,"
                   @"saturation=%.0f%%, "
                   @"brightness=%.0f%%.\n\n"
                   @"If you like it, use the code %@ in your design.\n\n"
                   @"Enjoy,\n\n",
                   color.hue,
                   color.saturation,
                   color.brightness,
                   [color rgbCodeWithPrefix:@"#"]];
    }
    else {
        message = [NSString stringWithFormat:
                   @"I wrote a great iOS app to share this color: %@",
                   [color rgbCodeWithPrefix:@"#"]];
    }
    return message;
}

- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController
{
    return @"My color message goes here";
}


- (IBAction)share:(id)sender
{
//    NSString *shareMessage = [NSString stringWithFormat:
//                              @"color to share"
//                              @" RGB=%@"
//                              @" @LearniOSAppDev",
//                              [self.colorModel rgbCodeWithPrefix:nil]];
    UIImage *shareImage = self.colorView.image;
    NSURL *shareURL = [NSURL URLWithString:@"http://www.learniosappdev.com/"];
    NSArray *itemsToShare = @[self, shareImage, shareURL];
    
    UIActivityViewController *activityViewController;
    activityViewController = [[UIActivityViewController alloc]
                              initWithActivityItems:itemsToShare
                              applicationActivities:nil];
    activityViewController.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypePrint];
    [self presentViewController:activityViewController animated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	self.colorModel = [CMColor new];
//    self.colorView.backgroundColor = self.colorModel.color;
    
    self.colorView.colorModel = self.colorModel;
    
    [_colorModel addObserver:self forKeyPath:@"hue" options:0 context:NULL];
    [_colorModel addObserver:self forKeyPath:@"saturation" options:0 context:NULL];
    [_colorModel addObserver:self forKeyPath:@"brightness" options:0 context:NULL];
    [_colorModel addObserver:self forKeyPath:@"color" options:0 context:NULL];
    
    _colorModel.hue = 60;
    _colorModel.saturation = 50;
    _colorModel.brightness = 100;
}

- (void)awakeFromNib
{
    NSLog(@"awakeFromNib");
    NSLog(@"hue:%f", self.colorModel.hue);
    
    [super awakeFromNib];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"hue"]) {
        self.hueLabel.text = [NSString stringWithFormat:@"%.0f\u00b0", self.colorModel.hue];
    }
    else if ([keyPath isEqualToString:@"saturation"]) {
        self.saturationLabel.text = [NSString stringWithFormat:@"%.0f%%", self.colorModel.saturation];
    }
    else if ([keyPath isEqualToString:@"brightness"]) {
        self.brightnessLabel.text = [NSString stringWithFormat:@"%.0f%%", self.colorModel.brightness];
    }
    else if ([keyPath isEqualToString:@"color"]) {
        // Update the color view
        [self.colorView setNeedsDisplay];
        CGFloat red, green, blue, alpha;
        [self.colorModel.color getRed:&red green:&green blue:&blue alpha:&alpha];
        self.webLabel.text = [self.colorModel rgbCodeWithPrefix:@"#"];
    }

}

//- (void) updateColor
//{
//	// Update the color view
//	[self.colorView setNeedsDisplay];
//    
//    self.hueLabel.text = [NSString stringWithFormat:@"%.0f\u00b0", self.colorModel.hue];
//    self.saturationLabel.text = [NSString stringWithFormat:@"%.0f%%", self.colorModel.saturation];
//    self.brightnessLabel.text = [NSString stringWithFormat:@"%.0f%%", self.colorModel.brightness];
//    
//    CGFloat red, green, blue, alpha;
//    [self.colorModel.color getRed:&red green:&green blue:&blue alpha:&alpha];
//    self.webLabel.text = [NSString stringWithFormat:@"#%02lX%02lX%02lX", lroundf(red*0xFF), lroundf(green*0xFF), lroundf(red*0xFF)];
//}

- (IBAction)changeHue:(UISlider*)sender
{
	self.colorModel.hue = sender.value;
}

- (IBAction)changeSaturation:(UISlider*)sender
{
	self.colorModel.saturation = sender.value;
}

- (IBAction)changeBrightness:(UISlider*)sender
{
	self.colorModel.brightness = sender.value;
}



@end
