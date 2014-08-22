//
//  CMColorView.m
//  ColorModel
//
//  Created by Hoan Tran on 7/11/14.
//  Copyright (c) 2014 mophie. All rights reserved.
//

#import "CMColorView.h"

#define kCircleRadius	40.0f

@interface CMColorView ()
{
	CGImageRef hsImageRef;
	float brightness;
}
@end

@implementation CMColorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)dealloc
{
    if (hsImageRef!=NULL)
		CGImageRelease(hsImageRef);
}

- (void)drawColorInRect:(CGRect)bounds context:(CGContextRef)context
{
    if (hsImageRef!=NULL &&
		( brightness!=_colorModel.brightness ||
         bounds.size.width!=CGImageGetWidth(hsImageRef) ||
         bounds.size.height!=CGImageGetHeight(hsImageRef) ) )
    {
		// There's a cached hue/saturation graph but it's no longer
		//  valid because either the brightness or dimenions of the
		//  image have changed, requiring it to be redrawn.
		// Dicard the old image, forcing a new one to be created
		CGImageRelease(hsImageRef);
		hsImageRef = NULL;
    }
	
	if (hsImageRef==NULL)
    {
		// There is no hue/saturation graph image: generate one
		
		// remember the brightness value for this image
		brightness = _colorModel.brightness;
		
		// Allocate an array of RGBA pixels the size of the image
		NSUInteger width = bounds.size.width;
		NSUInteger height = bounds.size.height;
		typedef struct {
			uint8_t red;
			uint8_t green;
			uint8_t blue;
			uint8_t alpha;
		} Pixel;
		NSMutableData *bitmapData = [NSMutableData dataWithLength:sizeof(Pixel)*width*height];
        // Loop through each pixel, setting its RGB values to the cooresponding HSB value
        //  at that coordinate.
		for ( NSUInteger y=0; y<height; y++ )
        {
			for ( NSUInteger x=0; x<width; x++ )
            {
				// Use a UIColor to convert between HSB and RGB
				UIColor *color = [UIColor colorWithHue:(float)x/(float)width
											saturation:1.0f-(float)y/(float)height
											brightness:brightness/100
												 alpha:1];
                //				float red,green,blue,alpha;
                CGFloat red,green,blue,alpha;
				[color getRed:&red green:&green blue:&blue alpha:&alpha];
				Pixel *pixel = ((Pixel*)bitmapData.bytes)+x+y*width;
				pixel->red = red*255;
				pixel->green = green*255;
				pixel->blue = blue*255;
				pixel->alpha = 255;
            }
        }
		
		// Turn the raw bitmap into a CGImage reference (object).
        // This is accomplished by creating a data provider that supplies the raw
        //  pixel array as the source data for the image. (Normally, data providers
        //  get the image's pixels from a file, like a JPEG file, performing
        //  whatever conversion or decompression is needed.)
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)bitmapData);
		hsImageRef = CGImageCreate(width,height,8,32,width*4,colorSpace,kCGBitmapByteOrderDefault,provider,NULL,false,kCGRenderingIntentDefault);
		CGColorSpaceRelease(colorSpace);
		CGDataProviderRelease(provider);
    }
	
	// Draw the current hue/saturation graph as the background
	CGContextDrawImage(context,bounds,hsImageRef);
	
	// Create a circular path, centered at the current hue/saturation
	CGRect circleRect = CGRectMake(bounds.origin.x+bounds.size.width*_colorModel.hue/360-kCircleRadius/2,
								   bounds.origin.y+bounds.size.height*_colorModel.saturation/100-kCircleRadius/2,
								   kCircleRadius,
								   kCircleRadius);
	UIBezierPath *circle = [UIBezierPath bezierPathWithOvalInRect:circleRect];
	[_colorModel.color setFill];
	[circle fill];
	circle.lineWidth = 3;
	[[UIColor blackColor] setStroke];
	[circle stroke];
}

- (void)drawRect:(CGRect)rect
{
	CGRect bounds = self.bounds;
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	[self drawColorInRect:bounds context:context];
}

- (UIImage*)image
{
    CGRect bounds = self.bounds;
    CGSize imageSize = bounds.size;
    CGFloat margin = kCircleRadius/2 + 2;
    imageSize.width += margin * 2;
    imageSize.height += margin * 2;
    bounds = CGRectOffset(bounds, margin, margin);
    
    UIGraphicsBeginImageContext(imageSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor clearColor] set];
    CGContextFillRect(context, CGRectMake(0, 0, imageSize.width, imageSize.height));
    [self drawColorInRect:bounds context:context];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)changeHSToPoint:(CGPoint)point
{
    CGRect bounds = self.bounds;
    if (CGRectContainsPoint(bounds, point)) {
        _colorModel.hue = (point.x-bounds.origin.x)/bounds.size.width*360;
        _colorModel.saturation = (point.y-bounds.origin.y)/bounds.size.height*100;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self changeHSToPoint:[(UITouch *) [touches anyObject] locationInView:self]];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self changeHSToPoint:[(UITouch *) [touches anyObject] locationInView:self]];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self changeHSToPoint:[(UITouch *) [touches anyObject] locationInView:self]];    
}

@end
