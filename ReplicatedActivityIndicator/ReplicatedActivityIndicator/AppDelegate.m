//
//  AppDelegate.m
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

#import "AppDelegate.h"
#import "DRActivityIndicator.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // You can style all instances of the activity indicator via the appearance proxy
    // Just comment out this code to apply the sample custom appearance.
    
    // -------------------------------------------------
    // "Big blue" indicator customization
    // -------------------------------------------------
    // The following customization changes the colors of the indicator and
    // also uses the marker customization properties to change its size.
    // 
    // Comment out the following code to try it out.
    
//    [[DRActivityIndicator appearance] setHUDBackgroundColor:[UIColor clearColor]];
//    [[DRActivityIndicator appearance] setMarkerColor:[UIColor blueColor]];
//    [[DRActivityIndicator appearance] setMarkerLenght:40.0];
//    [[DRActivityIndicator appearance] setMarkerSpread:100.0];
//    [[DRActivityIndicator appearance] setMarkerThickness:30.0];
//    [[DRActivityIndicator appearance] setNumberOfSpinnerMarkers:18];
//    [[DRActivityIndicator appearance] setSpinnerSpeed:1.5];
    
    // End of "big blue" customization
    // -------------------------------------------------
    
    return YES;
}
							

@end
