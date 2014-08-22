//
//  CMColor.h
//  ColorModel
//
//  Created by Hoan Tran on 7/10/14.
//  Copyright (c) 2014 mophie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CMColor : NSObject

@property (nonatomic) float hue;
@property (nonatomic) float saturation;
@property (nonatomic) float brightness;
@property (readonly, nonatomic) UIColor *color;

- (NSString *)rgbCodeWithPrefix:(NSString*)prefix;
@end
