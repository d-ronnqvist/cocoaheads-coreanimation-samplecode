//
//  ViewController.m
//  OvershootTimingFunction
//
//  Created by David Rönnqvist on 2012-05-27.
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

#define kTimeBetweenAnimations 0.75

@interface ViewController ()
@property (strong, nonatomic) NSArray *allAnimations;
@property NSInteger currentAnimationIndex;
- (void)_performAnimationAtIndex:(NSInteger)index;
@end

@implementation ViewController
@synthesize allAnimations = _allAnimations;
@synthesize currentAnimationIndex = _currentAnimationIndex;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// This is a very short demo, used to illustrate the use of custom timing functions.
    // The custom timing function is being used to create an "overshoot" effect where
    // the animiation "misses" its value by going to far and have to back to end up at
    // the final value. 
    //
    // The effect is acheived by leaving the range of 0-1 in the timing function by 
    // having the end control points y value (used for the value at time "x") be bigger
    // than 1.
    
    
    // Create a smaple orange box and add it to the view
    CALayer *myLayer = [CALayer layer];
    [myLayer setFrame:CGRectMake(100, 140, 150, 150)];
    [myLayer setBackgroundColor:[[UIColor orangeColor] CGColor]];
    [myLayer setTransform:CATransform3DMakeScale(.001, .001, 1.0)];
    [self.view.layer addSublayer:myLayer];
    
    // Create our timing function. 
    // Yes, this is all it really takes. It's a one-liner to acheive this effect.
    // Now we only need to set it as the timing funcion of our animations, just
    // like we would set them to ease in or be linear.
    CAMediaTimingFunction *overShoot = [CAMediaTimingFunction functionWithControlPoints:0.25 // c1x
                                                                                       :0.0  // c1y
                                                                                       :0.4  // c2x
                                                                                       :1.6];// c2y
    
    
    // Create a set of animations that all use the above timing function and add
    // them to an array. Then animate them one by one, over and over.
    
    
    // -------------------------------------
    // All the different animations
    
    // Scale up with a "pop"
    void (^popAnimationBlock)(void) = ^(void) {
        CABasicAnimation *pop = [CABasicAnimation animationWithKeyPath:@"transform"];
        [pop setFromValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.001, 0.001, 1.0)]];
        [pop setToValue:[NSValue valueWithCATransform3D:CATransform3DIdentity]];
        
        [pop setDuration:0.4];
        [pop setBeginTime:CACurrentMediaTime() + kTimeBetweenAnimations];
        [pop setTimingFunction:overShoot];
        [pop setFillMode:kCAFillModeBoth];
        [pop setDelegate:self];
        
        [myLayer setTransform:CATransform3DIdentity];
        [myLayer addAnimation:pop forKey:@"pop"];
    };
    
    void (^rotateAnimationBlock)(void) = ^(void) {
        CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform"];
        [rotate setToValue:[NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI_4, 0.0, 0.0, 1.0)]];
        [rotate setFromValue:[NSValue valueWithCATransform3D:CATransform3DIdentity]];
        
        [rotate setDuration:0.6];
        [rotate setBeginTime:CACurrentMediaTime() + kTimeBetweenAnimations];
        [rotate setTimingFunction:overShoot];
        [rotate setFillMode:kCAFillModeBoth];
        [rotate setDelegate:self];

        [myLayer setTransform:CATransform3DMakeRotation(M_PI_4, 0.0, 0.0, 1.0)];
        [myLayer addAnimation:rotate forKey:@"rotate"];
    };
    
    void (^rotateBackAnimationBlock)(void) = ^(void) {
        CABasicAnimation *rotateBack = [CABasicAnimation animationWithKeyPath:@"transform"];
        [rotateBack setToValue:[NSValue valueWithCATransform3D:CATransform3DIdentity]];
        [rotateBack setFromValue:[NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI_4, 0.0, 0.0, 1.0)]];
        
        [rotateBack setDuration:0.6];
        [rotateBack setBeginTime:CACurrentMediaTime() + kTimeBetweenAnimations];
        [rotateBack setTimingFunction:overShoot];
        [rotateBack setFillMode:kCAFillModeBoth];
        [rotateBack setDelegate:self];

        [myLayer setTransform:CATransform3DIdentity];
        [myLayer addAnimation:rotateBack forKey:@"rotateBack"];
    };
    
    void (^moveDownAnimationBlock)(void) = ^(void) {
        CABasicAnimation *moveDown = [CABasicAnimation animationWithKeyPath:@"position"];
        [moveDown setFromValue:[NSValue valueWithCGPoint:[myLayer position]]];
        [moveDown setToValue:[NSValue valueWithCGPoint:CGPointMake(170, 320)]];
        
        [moveDown setDuration:0.5];
        [moveDown setBeginTime:CACurrentMediaTime() + kTimeBetweenAnimations];
        [moveDown setTimingFunction:overShoot];
        [moveDown setFillMode:kCAFillModeBoth];
        [moveDown setDelegate:self];
        
        [myLayer setPosition:CGPointMake(170, 320)];
        [myLayer addAnimation:moveDown forKey:@"moveDown"];
    };
    
    void (^moveUpAnimationBlock)(void) = ^(void) {
        CABasicAnimation *moveUp = [CABasicAnimation animationWithKeyPath:@"position"];
        [moveUp setFromValue:[NSValue valueWithCGPoint:[myLayer position]]];
        [moveUp setToValue:[NSValue valueWithCGPoint:CGPointMake(170, 140)]];
        
        [moveUp setDuration:0.5];
        [moveUp setBeginTime:CACurrentMediaTime() + kTimeBetweenAnimations];
        [moveUp setTimingFunction:overShoot];
        [moveUp setFillMode:kCAFillModeBoth];
        [moveUp setDelegate:self];
        
        [myLayer setPosition:CGPointMake(170, 140)];
        [myLayer addAnimation:moveUp forKey:@"moveUp"];
    };
    
    void (^scaleDownAnimationBlock)(void) = ^(void) {
        CABasicAnimation *scaleDown = [CABasicAnimation animationWithKeyPath:@"transform"];
        [scaleDown setFromValue:[NSValue valueWithCATransform3D:CATransform3DIdentity]];
        [scaleDown setToValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.001, 0.001, 1.0)]];
        
        [scaleDown setDuration:0.4];
        [scaleDown setBeginTime:CACurrentMediaTime() + kTimeBetweenAnimations];
        
        // Don't use the custom timing function here.
        // This animation is only added to create a nice cycle of animations.
        // Overshooting negatively will have a strange visual artifact where
        // it looks like the animation scales back again but upside down.
        [scaleDown setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
        [scaleDown setFillMode:kCAFillModeBoth];
        [scaleDown setDelegate:self];
        
        [myLayer setTransform:CATransform3DMakeScale(0.001, 0.001, 1.0)];
        [myLayer addAnimation:scaleDown forKey:@"pop"];
    };
    
    [self setAllAnimations:[NSArray arrayWithObjects:
                            popAnimationBlock,
                            rotateAnimationBlock,
                            rotateBackAnimationBlock,
                            moveDownAnimationBlock,
                            moveUpAnimationBlock,
                            scaleDownAnimationBlock, nil]];
    
    // Start animating with the first animation.
    [self _performAnimationAtIndex:0];
}

#pragma mark - Animation delegate

- (void)animationDidStart:(CAAnimation *)anim {
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    // Increment the current index (and keep it with the size of the animation
    [self setCurrentAnimationIndex:(([self currentAnimationIndex] + 1)%[[self allAnimations] count])];
    // Perform the next animation
    [self _performAnimationAtIndex:[self currentAnimationIndex]];
}

#pragma mark - Perform the next animation

- (void)_performAnimationAtIndex:(NSInteger)index {
    // Run the block at 'index'
    void (^animationBlock)(void) = [[self allAnimations] objectAtIndex:[self currentAnimationIndex]];
    animationBlock();
}

#pragma mark - Autorotate

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
