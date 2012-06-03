//
//  ViewController.m
//  MarchingAnts
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

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Create a light blue rectangle with a dark blue stroke
    CAShapeLayer *myLayer = [CAShapeLayer layer];
    [myLayer setFillColor:[[UIColor colorWithRed:0.9 green:0.9 blue:1.0 alpha:1.0] CGColor]];
    [myLayer setStrokeColor:[[UIColor colorWithRed:0.2 green:0.2 blue:0.8 alpha:1.0] CGColor]];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(50, 100, 140, 80)];
    [myLayer setPath:[path CGPath]];
    
    // Style the dashed line
    // ------------------------------------
    // The line dash pattern is 2 points wide and 4 points long with
    // a 6 point space between the dashes. 
    // The animation phase is one whole phase (4+6 = 10 points)
    //
    //                          <-4-><--6-->          <----10--->
    //     ___        ___        ___        ___        ___        ___ 
    //    |___|      |___|    2{|___|      |___|      |___|      |___|
    //
    [myLayer setLineWidth:2.0];
    [myLayer setLineDashPattern:[NSArray arrayWithObjects:
                                   [NSNumber numberWithFloat:4.0],
                                   [NSNumber numberWithFloat:6.0], nil]];
    [[[self view] layer] addSublayer:myLayer];
    
    // Animate the line dash phase from 0 to 10 (one whole phase) for
    // ever. This will make it look like infite marching ants.
    CABasicAnimation *march = [CABasicAnimation animationWithKeyPath:@"lineDashPhase"];
    [march setDuration:0.25];
    [march setFromValue:[NSNumber numberWithFloat:0.0]];
    [march setToValue:[NSNumber numberWithFloat:10.0]];
    [march setRepeatCount:INFINITY];
    
    [myLayer addAnimation:march forKey:@"marchTheAnts"];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
