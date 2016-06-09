//
//  Animation.h
//  Pipopipette
//
//  Created by Paul Lavoine on 10/06/2016.
//  Copyright © 2016 Paul Lavoine. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Animation : NSObject


+ (instancetype)sharedInstance;
- (void)startAnimation:(UIView *)view;
- (void)startAnimation:(UIView *)view withTimer:(CGFloat)timer;

// Data
@property (nonatomic, assign) BOOL stopAnimation;

@end
