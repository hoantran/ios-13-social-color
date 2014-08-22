//
//  CMColor.m
//  ColorModel
//
//  Created by Hoan Tran on 7/10/14.
//  Copyright (c) 2014 mophie. All rights reserved.
//

#import "CMColor.h"

@implementation CMColor


- (UIColor*)color
{
	return [UIColor colorWithHue:self.hue/360
					  saturation:self.saturation/100
					  brightness:self.brightness/100
						   alpha:1];
}

- (NSString*)rgbCodeWithPrefix:(NSString *)prefix
{
    if (prefix==nil) {
        prefix = @"";
    }
    
    CGFloat red, green, blue, alpha;
    [self.color getRed:&red green:&green blue:&blue alpha:&alpha];
    return [NSString stringWithFormat:@"%@%02lx%02lx%02lx",
            prefix,
            lroundf(255 * red),
            lroundf(255 * green),
            lroundf(255 * blue) ];
}


+ (NSSet *) keyPathsForValuesAffectingColor
{
    return [NSSet setWithObjects:@"hue", @"saturation", @"brightness", nil];
}
@end
