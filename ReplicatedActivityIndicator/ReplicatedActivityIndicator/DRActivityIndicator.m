//
//  DRActivityIndicator.m
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

#import "DRActivityIndicator.h"
#import <QuartzCore/QuartzCore.h>

// Appearance proxy defaults
#define kDefaultNumberOfSpinnerMarkers 12
#define kDefaultSpread 35.0
#define kDefaultColor ([UIColor whiteColor])
#define kDefaultThickness 8.0
#define kDefaultLength 25.0
#define kDefaultSpeed 1.0

// HUD defaults
#define kDefaultHUDSide 160.0
#define kDefaultHUDColor ([UIColor colorWithWhite:0.0 alpha:0.5])

#define kMarkerAnimationKey @"MarkerAnimationKey"

@interface DRActivityIndicator (/*Private*/)
- (CALayer *)_newSpinnerMarker;
- (void)_fillUnsetPropertiesWithDefaultValues;
@end

@implementation DRActivityIndicator
@synthesize numberOfSpinnerMarkers = _numberOfSpinnerMarkers;
@synthesize markerSpread = _markerSpread;
@synthesize spinnerMarkerLayer = _spinnerMarkerLayer;
@synthesize markerColor = _markerColor;
@synthesize markerThickness = _markerThickness;
@synthesize markerLenght = _markerLenght;
@synthesize spinnerSpeed = _spinnerSpeed;
@synthesize HUDBackgroundColor = _HUDbackgroundColor;

- (void)startAnimating {
    [self _fillUnsetPropertiesWithDefaultValues];
    
    if (![self spinnerMarkerLayer]) {
        // There was no set spinner marker
        // Create one from the other properties
        [self setSpinnerMarkerLayer:[self _newSpinnerMarker]];
    } 
    [[self spinnerMarkerLayer] setPosition:CGPointMake(kDefaultHUDSide*0.5, kDefaultHUDSide*0.5+[self markerSpread])];
    
    // Create a replicator layer that is centered in the activity indicator view
    CAReplicatorLayer * spinnerReplicator = [CAReplicatorLayer layer];
    [spinnerReplicator setBounds:CGRectMake(0, 0, kDefaultHUDSide, kDefaultHUDSide)];
    [spinnerReplicator setCornerRadius:10.0];
    [spinnerReplicator setBackgroundColor:[[self HUDBackgroundColor] CGColor]];
    [spinnerReplicator setPosition:CGPointMake(CGRectGetMidX([self frame]), 
                                               CGRectGetMidY([self frame]))];
    
    // Calculate the angle which each spinner marker should be rotated from
    // the previous spinner marker. To acheive an evenly distributed circle
    // the angle should be 2*PI / N, where N is the number of markers.
    CGFloat angle = (2.0*M_PI)/([self numberOfSpinnerMarkers]);
    CATransform3D instanceRotation = CATransform3DMakeRotation(angle, 0.0, 0.0, 1.0);
    [spinnerReplicator setInstanceCount:[self numberOfSpinnerMarkers]];
    [spinnerReplicator setInstanceTransform:instanceRotation];
    
    // Add the spinner marker to the replicator
    [spinnerReplicator addSublayer:[self spinnerMarkerLayer]];
    [[self layer] addSublayer:spinnerReplicator];
    
    // All markers start of as completely invisible, then they jump to fully
    // opaque and slowly fade out again to acheive the illusion of the rotation.
    // Each instance has the delay of one rotatoin divided by the number of 
    // markers in the spinnet to create a circle where the last marker barely
    // fades out as the first becomes fully opaque
    [[self spinnerMarkerLayer] setOpacity:0.0];
    CABasicAnimation * fade = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [fade setToValue:[NSNumber numberWithFloat:0.0]];
    [fade setFromValue:[NSNumber numberWithFloat:1.0]];
    [fade setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    [fade setRepeatCount:HUGE_VALF];
    [fade setDuration:[self spinnerSpeed]];
    CGFloat markerAnimationDuration = [self spinnerSpeed]/[self numberOfSpinnerMarkers];
    [spinnerReplicator setInstanceDelay:markerAnimationDuration];
    [[self spinnerMarkerLayer] addAnimation:fade forKey:kMarkerAnimationKey];
}

/*!
 * Create a new spinner with the siz eand position set from the customizable properties
 */
- (CALayer *)_newSpinnerMarker {
    CALayer * marker = [CALayer layer];
    [marker setBounds:CGRectMake(0, 0, [self markerThickness], [self markerLenght])];
    [marker setCornerRadius:[self markerThickness]*0.5];
    [marker setBackgroundColor:[[self markerColor] CGColor]];
    [marker setPosition:CGPointMake(kDefaultHUDSide*0.5, kDefaultHUDSide*0.5+[self markerSpread])];

    
    return marker;
}

/*!
 * Set all, non-customized properties with their default values
 */
- (void)_fillUnsetPropertiesWithDefaultValues {
    if (![self numberOfSpinnerMarkers]) { [self setNumberOfSpinnerMarkers:kDefaultNumberOfSpinnerMarkers]; }
    if (![self markerSpread]) { [self setMarkerSpread:kDefaultSpread]; }
    if (![self markerColor]) { [self setMarkerColor:kDefaultColor]; }
    if (![self markerThickness]) { [self setMarkerThickness:kDefaultThickness]; }
    if (![self markerLenght]) { [self setMarkerLenght:kDefaultLength]; }
    if (![self spinnerSpeed]) { [self setSpinnerSpeed:kDefaultSpeed]; }
    if (![self HUDBackgroundColor]) { [self setHUDBackgroundColor:kDefaultHUDColor]; }
}


@end
