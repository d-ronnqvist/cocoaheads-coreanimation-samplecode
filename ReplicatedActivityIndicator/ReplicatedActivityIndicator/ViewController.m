//
//  ViewController.m
//  ReplicatedActivityIndicator
//
//  Created by David Rönnqvist on 2012-05-08.
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
#import "DRActivityIndicator.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self view] setBackgroundColor:[UIColor colorWithWhite:0.7 alpha:1.0]];
    
    // Create and add a new indicator
    DRActivityIndicator * indicator = [[DRActivityIndicator alloc] initWithFrame:[[self view] frame]];
    [[self view] addSubview:indicator];
    
    // The activity indicator can be used without any styling at all and will
    // try to look like the HUD that is used for things like changing the volume
    // or locking screen rotation in the OS. 
    //
    // If that style doesn't suite you, you can style it either by changing
    // properties on each instance (like below) or by changing properties
    // using the appearance selector.
    //
    // Both kinds of styling is available (commented out) in this sample.
    // The direct instance custimizatoin is done below (chaning the indicator
    // to red spinning hearts) and the appearance proxy customization is avaiable
    // in the app delegate (also commented out).
    
    
    // -------------------------------------------------
    // "Waiting for love" indicator customization
    // -------------------------------------------------
    // The following customization changes the colors of the indicator and
    // also sets a custom layer (a shape layer) for its spinner marker.
    // 
    // Comment out the following code to try it out.
    
//    [indicator setNumberOfSpinnerMarkers:9];  
//    [indicator setMarkerSpread:35.0];
//    [indicator setHUDBackgroundColor:[UIColor colorWithRed:1 
//                                                     green:0.7 
//                                                      blue:0.7 
//                                                     alpha:1.0]];
//    CAShapeLayer * heartMarkerLayer = [CAShapeLayer layer];
//    [heartMarkerLayer setFillColor:[[UIColor colorWithRed:1.0 
//                                                    green:0.3 
//                                                     blue:0.3 
//                                                    alpha:1.0] CGColor]];
//    [heartMarkerLayer setStrokeColor:[[UIColor colorWithRed:0.7 
//                                                      green:0.0 
//                                                       blue:0.0 
//                                                      alpha:1.0] CGColor]];
//    UIBezierPath * heartPath = [UIBezierPath bezierPath];
//    [heartPath moveToPoint:CGPointMake(0, 0)];
//    [heartPath addCurveToPoint:CGPointMake(0, 20) 
//                 controlPoint1:CGPointMake(-30, 20) 
//                 controlPoint2:CGPointMake(-5, 40)];
//    [heartPath addCurveToPoint:CGPointMake(0, 0) 
//                 controlPoint1:CGPointMake(5, 40) 
//                 controlPoint2:CGPointMake(30, 20)];
//    [heartMarkerLayer setPath:[heartPath CGPath]];
//    
//    [heartMarkerLayer setLineWidth:1.0];
//    [heartMarkerLayer setLineJoin:kCALineCapRound];
//    [indicator setSpinnerMarkerLayer:heartMarkerLayer];
    
    // End of heart customization
    // -------------------------------------------------
    
    
    // Wait a short while before beginning the animatoin just because it looks good
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [indicator startAnimating];
        
    });
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end
