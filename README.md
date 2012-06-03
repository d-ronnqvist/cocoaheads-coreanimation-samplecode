cocoaheads-coreanimation-samplecode
===================================

#About
This is the presentation and the sample code discussed in my presentation on Core Animation for the June 2012 CocoaHeads Stockholm meet up. 

The code is intended to be material for learning Core Animation so that people who see the presentation can later look at the all the code. 

#Sample projects
There are five sample projects related to the presentation (in the order they appear in the presentation):

##1. Replicated activity indicator
A custom activity indicator which was built using a `CAReplicatorLayer`. The purpose is to illustrate how a replicator layer works.

##2. Pie chart progress indicator
A progress indicator where the stroke of a circle is animated to achieve the visual effect of counting down.

##3. Marching ants
A rectangle with a dashed stroke. The line dash phase is animated to create a "marching ants" effect, commonly used to indicate a selection.

##4. Overshoot timing function
A small demo where multiple basic animations are run with a custom timing function. Meant to illustrate how you can use custom timing functions.

##5. Heavy jumping view
A orange box that jumps to where the user taps on the screen. Uses a combination of many small animations to create the jumping effect and simulating a jelly-like material for the box. Also uses particle effects to create a dust cloud when the box lands. This sample is mostly intended to be used as sample code for the `CAEmitterLayer`. It should not be used as reference for how you do complex animations.