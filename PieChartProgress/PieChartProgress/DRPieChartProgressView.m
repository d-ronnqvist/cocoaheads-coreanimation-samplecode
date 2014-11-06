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

#define kOutlineWidthPercentage 0.075

@interface DRPieChartProgressView (/*Private*/)
@property (strong, nonatomic) CAShapeLayer *pieShape;
@end

@implementation DRPieChartProgressView
@synthesize pieShape = _pieShape;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Make sure the circles will fit the frame
        CGFloat radius = MIN(frame.size.width, frame.size.height)/2;
        
        // Calculate the radius for the outline. Since strokes are centered,
        // the shape needs to be inset half the stroke width.
        CGFloat outlineWidth = round(radius*kOutlineWidthPercentage);
        CGFloat inset = outlineWidth/2;
        
        CAShapeLayer *outlineShape = [CAShapeLayer layer];
        outlineShape.path = [[UIBezierPath bezierPathWithRoundedRect:CGRectInset(self.bounds, inset, inset)
                                                        cornerRadius:radius-inset] CGPath];
        // Draw only the line of the circular outline shape
        [outlineShape setFillColor:   [[UIColor clearColor] CGColor]];
        [outlineShape setStrokeColor: [[UIColor whiteColor] CGColor]];
        [outlineShape setLineWidth:   outlineWidth];
        
        // Create the pie chart shape layer. It should fill from the center,
        // all the way out (excluding some extra space (equal to the width of
        // the outline)).
        CAShapeLayer *pieChartShape = [CAShapeLayer layer];
        inset = radius/2 + outlineWidth; // The inset is updated here
        pieChartShape.path = [UIBezierPath bezierPathWithRoundedRect:CGRectInset(self.bounds, inset, inset)
                                                   cornerRadius:radius-inset].CGPath;
        
        // We don't want to fill the pie chart since that will be visible
        // even when we change the stroke start and stroke end. Instead
        // we only draw the stroke with the above calculated width.
        [pieChartShape setFillColor:    [[UIColor clearColor] CGColor]];
        [pieChartShape setStrokeColor:  [[UIColor whiteColor] CGColor]];
        [pieChartShape setLineWidth:    (radius-inset)*2];   
        
        // Add sublayers
        // NOTE: the following code is used in a UIView subclass (thus self is a view)
        // If you instead chose to use this code in a view controller you should instead
        // use self.view.layer to access the view of your view controller.
        [self.layer addSublayer:outlineShape];
        [self.layer addSublayer:pieChartShape];
        [self setPieShape:pieChartShape];
        
    }
    return self;
}

- (void)startCountdownWithDuration:(NSUInteger)durationInSeconds {    
    // Animate the strokeStart of the shapeLayer to give the effect that the clock is ticking down
    CABasicAnimation *countdownAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    
    [countdownAnimation setDuration:            durationInSeconds];
    [countdownAnimation setRepeatCount:         1.0];  // Animate only once..
    [countdownAnimation setRemovedOnCompletion: NO];   // Remain stroked after the animation..
    
    // Animate from all of the stroke being drawn to the no part of the stroke being drawn (clock-wise)
    [countdownAnimation setFromValue:[NSNumber numberWithFloat:0.0]];
    [countdownAnimation setToValue:  [NSNumber numberWithFloat:1.0]];
    
    // The countdown should animate linearly to stay true to the actual amount of time left
    [countdownAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    
    // After the animation the strokeEnd should be set to 1.0 to completely hide the pie-chart clock
    [[self pieShape] setStrokeStart:1.0];
    // Add the animation to the circle
    [[self pieShape] addAnimation:countdownAnimation forKey:@"drawCircleAnimation"];
}


@end
