//
//  CMColorView.h
//  ColorModel
//
//  Created by Hoan Tran on 7/11/14.
//  Copyright (c) 2014 mophie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CMColor.h"

@interface CMColorView : UIView

@property (strong, nonatomic) CMColor *colorModel;
@property (readonly, nonatomic) UIImage *image;

- (void)changeHSToPoint: (CGPoint)point;

@end
