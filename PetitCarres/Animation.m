//
//  Animation.m
//  Pipopipette
//
//  Created by Paul Lavoine on 10/06/2016.
//  Copyright © 2016 Paul Lavoine. All rights reserved.
//

#import "Animation.h"

#define MIN_ZOOM_OUT                0.9
#define ANIMATION_DURATION          ((self.animationDuration != NAN) ?: ANIMATION_DEFAULT_DURATION)
#define ANIMATION_DEFAULT_DURATION  2.0

@interface Animation ()

@property (nonatomic ,assign) CGFloat animationDuration;

@end

@implementation Animation

#pragma mark - Shared instance

+ (instancetype)sharedInstance
{
    static Animation *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[Animation alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init
{
    if (self = [super init])
    {
        _animationDuration = NAN;
    }
    
    return self;
}

#pragma mark - Animations
- (void)startAnimation:(UIView *)view withTimer:(CGFloat)timer
{
    self.animationDuration = timer;
    [self startAnimation:view];
}

- (void)startAnimation:(UIView *)view
{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        //Background Thread
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self popUpZoomIn:view];
        });
    });
}

- (void)popUpZoomIn:(UIView *)view
{
    view.transform = CGAffineTransformScale(CGAffineTransformIdentity, MIN_ZOOM_OUT, MIN_ZOOM_OUT);
    [UIView animateWithDuration:ANIMATION_DURATION
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
                     } completion:^(BOOL finished) {
                         if (!self.stopAnimation)
                         {
                             [self popZoomOut:view];
                         }
                     }];
}

- (void)popZoomOut:(UIView *)view
{
    [UIView animateWithDuration:ANIMATION_DURATION
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         view.transform = CGAffineTransformScale(CGAffineTransformIdentity, MIN_ZOOM_OUT, MIN_ZOOM_OUT);
                     } completion:^(BOOL finished){
                         if (!self.stopAnimation)
                         {
                             [self popUpZoomIn:view];
                         }
                     }];
}

- (void)setStopAnimation:(BOOL)stopAnimation
{
    if (stopAnimation)
    {
        self.animationDuration = NAN;
    }
}

#pragma mark - Object lifecycle

- (void)dealloc
{
    
}

@end
