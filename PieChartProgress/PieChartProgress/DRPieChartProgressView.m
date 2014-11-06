//
//  PieChartProgressView.m
//  PieChartProgress
//
//  Created by David Rönnqvist on 2012-05-26.
//  Copyright (c) 2012 David Rönnqvist.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of 
// this software and associated documentation files (the "Software"), to deal in the 
// Software without restriction, including without limitation the rights to use, copy,
// modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,
// and to permit persons to whom the Software is furnished to do so, subject to the 
// following conditions:
//
// The above copyright notice and this permission notice shall be included in all 
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
// INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A 
// PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
// SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "DRPieChartProgressView.h"
#import <QuartzCore/QuartzCore.h>

#import <tgmath.h>

const CGFloat kOutlineWidthPercentage = 0.075;

@interface DRPieChartProgressView (/*Private*/)
@property (strong, nonatomic) CAShapeLayer *pieShape;
@end

@implementation DRPieChartProgressView
@synthesize pieShape = _pieShape;

static inline CGFloat degreesToRadians(CGFloat degrees) {
	return degrees * M_PI / 180.0;
}

static CGAffineTransform CGAffineTransformForRotatingRectAroundCenter(CGRect rect, CGFloat angle) {
	CGAffineTransform transform = CGAffineTransformIdentity;
	
	transform = CGAffineTransformTranslate(transform, CGRectGetMidX(rect), CGRectGetMidY(rect));
	transform = CGAffineTransformRotate(transform, angle);
	transform = CGAffineTransformTranslate(transform, -CGRectGetMidX(rect), -CGRectGetMidY(rect));
	
	return transform;
}

static CGAffineTransform CGAffineTransformForScalingRectAroundCenter(CGRect rect, CGFloat sx, CGFloat sy) {
	CGAffineTransform transform = CGAffineTransformIdentity;
	
	transform = CGAffineTransformTranslate(transform, CGRectGetMidX(rect), CGRectGetMidY(rect));
	transform = CGAffineTransformScale(transform, sx, sy);
	transform = CGAffineTransformTranslate(transform, -CGRectGetMidX(rect), -CGRectGetMidY(rect));
	
	return transform;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		CGRect bounds = self.bounds;
		
		CGColorRef foregroundColor = [[UIColor whiteColor] CGColor];
		CGColorRef clearColor = [[UIColor clearColor] CGColor];
		
        // Make sure the circles will fit the frame
        CGFloat outerRadius = MIN(frame.size.width, frame.size.height)/2;
		
        // Calculate the radius for the outline. Since strokes are centered,
        // the shape needs to be inset half the stroke width.
        CGFloat outlineWidth = round(outerRadius*kOutlineWidthPercentage);
        CGFloat outlineInset = outlineWidth/2;
		CGRect outlineRect = CGRectInset(bounds, outlineInset, outlineInset);
		
		CGAffineTransform outlineTransform = CGAffineTransformForRotatingRectAroundCenter(outlineRect, degreesToRadians(-90.0));
		CGPathRef outlinePath = CGPathCreateWithEllipseInRect(outlineRect, &outlineTransform);

        CAShapeLayer *outlineShape = [CAShapeLayer layer];
        outlineShape.path = outlinePath;
		
        // Draw only the line of the circular outline shape
        outlineShape.fillColor =    clearColor;
        outlineShape.strokeColor =  foregroundColor;
        outlineShape.lineWidth =    outlineWidth;
        
        // Create the pie chart shape layer. It should fill from the center,
        // all the way out (excluding some extra space (equal to the width of
        // the outline)).
        CGFloat pieChartInset = outerRadius/2 + outlineWidth;
		CGRect pieChartRect = CGRectInset(bounds, pieChartInset, pieChartInset);
		
		CGAffineTransform pieChartTransform = CGAffineTransformForRotatingRectAroundCenter(pieChartRect, degreesToRadians(-90.0));
		//CGAffineTransform pieChartTransformFlip = CGAffineTransformForScalingRectAroundCenter(outlineRect, -1.0, 1.0); // Flip left<->right.
		//pieChartTransform = CGAffineTransformConcat(pieChartTransform, pieChartTransformFlip);
		CGPathRef pieChartPath = CGPathCreateWithEllipseInRect(pieChartRect, &pieChartTransform);

        CAShapeLayer *pieChartShape = [CAShapeLayer layer];
        pieChartShape.path = pieChartPath;
        
        // We don't want to fill the pie chart since that will be visible
        // even when we change the stroke start and stroke end. Instead
        // we only draw the stroke with the above calculated width.
        pieChartShape.fillColor =     clearColor;
        pieChartShape.strokeColor =   foregroundColor;
        pieChartShape.lineWidth =     (outerRadius-pieChartInset)*2;
        
        // Add sublayers
        // NOTE: the following code is used in a UIView subclass (thus self is a view)
        // If you instead chose to use this code in a view controller you should instead
        // use self.view.layer to access the view of your view controller.
        [self.layer addSublayer:outlineShape];
        [self.layer addSublayer:pieChartShape];
        self.pieShape = pieChartShape;
		
		_pieShape.strokeStart = 0.0;
		_pieShape.strokeEnd = 0.0;

		CGPathRelease(outlinePath);
		CGPathRelease(pieChartPath);
    }
    return self;
}

- (void)startCountdownWithDuration:(NSUInteger)durationInSeconds {    
    // Animate the strokeStart of the shapeLayer to give the effect that the clock is ticking down
    CABasicAnimation *countdownAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    
    countdownAnimation.duration =             durationInSeconds;
    countdownAnimation.repeatCount =          1.0;  // Animate only once..
    countdownAnimation.removedOnCompletion =  YES;  // Remaining stroked after the animation is set up below.
    
    // Animate from no part of the stroke being drawn to all of the stroke being drawn (clock-wise)
    countdownAnimation.fromValue = @0.0f;
    countdownAnimation.toValue =   @1.0f;
    
    // The countdown should animate linearly to stay true to the actual amount of time left
    countdownAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    // After the animation the strokeEnd should be set to toValue to completely hide the pie-chart clock
    _pieShape.strokeEnd = 1.0;
    // Add the animation to the circle
    [_pieShape addAnimation:countdownAnimation forKey:@"drawCircleAnimation"];
}


@end
