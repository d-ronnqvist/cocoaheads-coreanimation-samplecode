//
//  ViewController.m
//  HeavyJumpingView
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

typedef enum {
    dustDirectionLeft = -1,
    dustDirectionRight = 1
} dustDirection;


@interface ViewController ()
@property (strong, nonatomic) CALayer *myLayer;
@property (strong, nonatomic) CALayer *currentShadow;
@end

@implementation ViewController
@synthesize myLayer = _myLayer;
@synthesize currentShadow = _currentShadow;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    // Create a box, filled with an orange gradient.
    CALayer *layer = [CALayer layer];
    layer.backgroundColor = [[UIColor orangeColor] CGColor];
    layer.frame = CGRectMake(300, 700, 100, 100);
    layer.borderColor = [UIColor colorWithRed:.6 green:.3 blue:.1 alpha:1.0].CGColor;
    layer.borderWidth = 2.0;
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    [gradient setType:kCAGradientLayerAxial];
    [gradient setColors:[NSArray arrayWithObjects:
                         (id)([UIColor colorWithRed:1 green:0.7 blue:0.2 alpha:1.0].CGColor),
                         (id)([UIColor colorWithRed:1 green:0.6 blue:0.1 alpha:1.0].CGColor),
                         (id)([UIColor colorWithRed:.9 green:0.5 blue:0.1 alpha:1.0].CGColor),
                         (id)([UIColor colorWithRed:.8 green:0.4 blue:0.0 alpha:1.0].CGColor), nil]];
    
    [layer addSublayer:gradient];
    [gradient setFrame:layer.bounds];

    // Change the anchor point. This means that the "position" property
    // of the layer will be at the bottom (i.e. it will land on the point
    // where you pressed, so no need to recalculate the position).
    layer.anchorPoint = CGPointMake(0.5, 1.0);
    
    // There is no shadow before the first jump. I know, I'm lazy.
    // This sample code is meant to be used for learning about
    // using multiple different animations at once and usign the
    // CAEmitterLayer for particle effects.
    
    [self.view.layer addSublayer:layer];
    self.myLayer = layer;
    
    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

/*!
 * The jumping layer does have a drop shadow, a round circle at the 
 * bottom of the layer.
 * When the layer jumps, the drop shadow should fade out as the blur
 * radius increases. This is to have it look more realistic.
 */
- (void)animateShadowAtPoint:(CGPoint)point jumpDuration:(NSInteger)jumpDuration {
    // Animate the old shadow as we jump up into the air...
    if ([self currentShadow]) {
        // If there is a previous shadow, then it should animate out as
        // the layer jumps up into the air.
        // This is done by animating the opacity and the radius in a group.
        CAAnimationGroup *fadeOutAndBlur = [CAAnimationGroup animation];
        [fadeOutAndBlur setDuration:0.4];
        [fadeOutAndBlur setBeginTime:CACurrentMediaTime()+0.2];
        [fadeOutAndBlur setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        [fadeOutAndBlur setFillMode:kCAFillModeBoth];
        
        CABasicAnimation *fadeOut = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
        [fadeOut setFromValue:[NSNumber numberWithFloat:0.6]];
        [fadeOut setToValue:[NSNumber numberWithFloat:0.0]];
        
        CABasicAnimation *blur = [CABasicAnimation animationWithKeyPath:@"shadowRadius"];
        [blur setFromValue:[NSNumber numberWithFloat:4.0]];
        [blur setToValue:[NSNumber numberWithFloat:30.0]];
        
        [fadeOutAndBlur setAnimations:[NSArray arrayWithObjects:fadeOut, blur, nil]];
        
        [[self currentShadow] setShadowOpacity:0.0];
        [[self currentShadow] addAnimation:fadeOutAndBlur forKey:@"liftOffShadow"];
    }
    
    // ...next we create the new shadow (where we will land). 
    // The shadow is simply an oval inside a long rectangle with
    // a low height. The blur radius is very small one the layer 
    // has landed but is very big before it lands.
    CGFloat shadowWidth = CGRectGetWidth([[self myLayer] bounds]);
    CALayer *shadow = [CALayer layer];
    [shadow setPosition:point];
    [shadow setShadowPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectInset(CGRectMake(-shadowWidth*0.5, 0, shadowWidth, 5), -15, 0)] CGPath]];
    [shadow setShadowOpacity:0.6];
    [shadow setShadowOffset:CGSizeMake(0, -2.0)];
    [shadow setShadowColor:[[UIColor blackColor] CGColor]];
    [shadow setShadowRadius:4.0];
    [[[self view] layer] insertSublayer:shadow below:[self myLayer]];
    
    [self setCurrentShadow:shadow];
    
    // The animation for the new should start some way into the jump.
    // The shadow will fade in and "focus" (become less blurred).
    CAAnimationGroup *fadeInAndFocus = [CAAnimationGroup animation];
    [fadeInAndFocus setDuration:0.4];
    [fadeInAndFocus setBeginTime:CACurrentMediaTime() + jumpDuration - 0.35];
    [fadeInAndFocus setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [fadeInAndFocus setFillMode:kCAFillModeBoth];
    
    CABasicAnimation *fadeIn = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
    [fadeIn setFromValue:[NSNumber numberWithFloat:0.0]];
    [fadeIn setToValue:[NSNumber numberWithFloat:0.6]];
    
    CABasicAnimation *focus = [CABasicAnimation animationWithKeyPath:@"shadowRadius"];
    [focus setFromValue:[NSNumber numberWithFloat:30.0]];
    [focus setToValue:[NSNumber numberWithFloat:4.0]];
    
    [fadeInAndFocus setAnimations:[NSArray arrayWithObjects:fadeIn, focus, nil]];
    
    [shadow addAnimation:fadeInAndFocus forKey:@"landingShadow"];
}

/*!
 * Create a new dust cloud emitter for the given direction
 * The cloud is an emitter that emitts dust cells over its
 * life time. This is done so that there can be a quick burst
 * of dust that lives for a longer duration.
 * The dust cells are configured to move swiftly and decellerate
 * swiftly to look like a burst. Each particle will have a 
 * sligthly different size and opacity.
 *
 * There are a lot of "magic numbers below. They are all
 * chosen to look good and have no real relation to each other.
 */
- (CAEmitterCell *)dustCloud:(dustDirection)direction {
    CAEmitterCell *dustCell = [[CAEmitterCell alloc] init];
    [dustCell setColor:[[UIColor colorWithWhite:0.7 alpha:0.75] CGColor]];
    [dustCell setVelocity:190.0];
    [dustCell setVelocityRange:100];
    [dustCell setAlphaRange:0.5];
    [dustCell setAlphaSpeed:-1.3];
    [dustCell setBirthRate:7000];
    [dustCell setLifetime:3.5];
    [dustCell setScale:0.4];
    [dustCell setScaleRange:0.1];
    [dustCell setScaleSpeed:-0.1];
    [dustCell setContents:(id)[[UIImage imageNamed:@"dust.png"] CGImage]];
    [dustCell setEmissionLongitude:(direction == dustDirectionLeft) ? -M_PI_4*.25 : M_PI+M_PI_4*.25];
    [dustCell setEmissionRange:M_PI_4/2];
    [dustCell setName:@"dust"];
    [dustCell setXAcceleration:direction*1000.0];
    [dustCell setYAcceleration:20.0];
    
    CAEmitterCell *dustCloud = [CAEmitterCell emitterCell];
    [dustCloud setBirthRate:1.0];
    [dustCloud setLifetime:0.06];
    [dustCloud setBeginTime:0.01];
    [dustCloud setEmitterCells:[NSArray arrayWithObject:dustCell]];
    [dustCloud setName:@"cloud"];
    
    return dustCloud;
}

/*!
 * When the user taps on the screen the layer will jump from
 * its current position to the point where the user tapped.
 * 
 * There are many things that happen in this animation:
 * First: the layer becomes smaller as it presses itself to
 *        the ground in preparation for the jump.
 * Second: The shadow animates out as the layer jumps up
 *         into the air.
 * Third: The new shadow animates in as the layer is about
 *        to land on the new location.
 * Forth: As the layer lands it becomes flat from the heavy
 *        landing. At the same time there is a burst of dust
 *        from the left and right bottom edges of the layer.
 */
- (IBAction)jumpToPoint:(UITapGestureRecognizer *)sender {
    CGPoint point = [sender locationOfTouch:0 inView:self.view];
    CGFloat jumpDuration = 1.0;
    
    // Animate the shadows
    // This includes the duration and begin times to have
    // them begin at the correct times.
    [self animateShadowAtPoint:point jumpDuration:jumpDuration];
    
    // Flatten the layer in preperation for the jump
    CABasicAnimation *flatten = [CABasicAnimation animationWithKeyPath:@"transform"];
    [flatten setDuration:0.1];
    [flatten setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [flatten setToValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.15, 0.7, 1.0)]];
    [flatten setAutoreverses:YES];
    [flatten setDelegate:self];
    [[self myLayer] addAnimation:flatten forKey:@"prepareForJump"];
    
    // Change the actual position along a cubic path for the actual jump
    CAKeyframeAnimation *jump = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [jump setDuration:0.8];
    [jump setBeginTime:CACurrentMediaTime()+0.2];
    [jump setCalculationMode:kCAAnimationCubic];
    [jump setTimingFunctions:[NSArray arrayWithObjects:
                              [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                              [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn], nil]];
    CGPoint middle = CGPointMake([[self myLayer] position].x-([[self myLayer] position].x - point.x)*0.5, 150);
    [jump setValues:[NSArray arrayWithObjects:
                     [NSValue valueWithCGPoint:[[self myLayer] position]], 
                     [NSValue valueWithCGPoint:middle], 
                     [NSValue valueWithCGPoint:point], nil]];
    [jump setFillMode:kCAFillModeBoth];
    
    [[self myLayer] setPosition:point];
    [[self myLayer] addAnimation:jump forKey:@"jump"];
    
    // Create the dust emitters for the left and right corners
    CAEmitterLayer *rightDustEmitter = [CAEmitterLayer layer];
    CAEmitterLayer *leftDustEmitter = [CAEmitterLayer layer];
    CAEmitterCell *leftDustCloud = [self dustCloud:dustDirectionLeft];
    CAEmitterCell *rightDustCloud = [self dustCloud:dustDirectionRight];
    CGPoint leftCorner = CGPointMake(CGRectGetMaxX(_myLayer.frame), CGRectGetMaxY(_myLayer.frame)-1);
    CGPoint rightCorner = CGPointMake(CGRectGetMinX(_myLayer.frame), CGRectGetMaxY(_myLayer.frame)-1);
    
    [rightDustEmitter setEmitterPosition:rightCorner];
    [rightDustEmitter setEmitterCells:[NSArray arrayWithObject:rightDustCloud]];
    [leftDustEmitter setEmitterPosition:leftCorner];
    [leftDustEmitter setEmitterCells:[NSArray arrayWithObject:leftDustCloud]];
    
    
    // This is not the correct way of chaining animations.
    // This example code should only be used as an example
    // of how to use the CAEmitterLayer.
    
    // Once the jump animation finishes...
    double delayInSeconds = jumpDuration;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        // flatten the orange box again
        CABasicAnimation *flatten = [CABasicAnimation animationWithKeyPath:@"transform"];
        [flatten setDuration:0.05];
        [flatten setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        [flatten setToValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 0.8, 1.0)]];
        [flatten setAutoreverses:YES];
        [[self myLayer] addAnimation:flatten forKey:@"boom"];
        
        // Add a deceleration animation on the dust clouds
        CABasicAnimation *slowDown = [CABasicAnimation animationWithKeyPath:@"emitterCells.cloud.emitterCells.dust.xAcceleration"];
        [slowDown setToValue:[NSNumber numberWithFloat:0.0]];
        [slowDown setDuration:.3];
        [slowDown setBeginTime:CACurrentMediaTime()+.05];
        [slowDown setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        [slowDown setFillMode:kCAFillModeBoth];
        [slowDown setRemovedOnCompletion:NO];
        
        [rightDustEmitter addAnimation:slowDown forKey:@"slowDownDust"];
        [leftDustEmitter addAnimation:slowDown forKey:@"slowDownDust"];
        
        // Add the dust emitters to the view so that they will start emitting particles
        [self.view.layer insertSublayer:rightDustEmitter below:self.myLayer];
        [self.view.layer insertSublayer:leftDustEmitter below:self.myLayer];
        
        // After one burst, change the birth rate of the cloud to 0
        // so that there is only one burst per side.
        double delayInSeconds = .5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
            
            [leftDustEmitter setValue:[NSNumber numberWithFloat:0.0] forKeyPath:@"emitterCells.cloud.birthRate"];
            [rightDustEmitter setValue:[NSNumber numberWithFloat:0.0] forKeyPath:@"emitterCells.cloud.birthRate"];
        });
    });
    
}




@end
