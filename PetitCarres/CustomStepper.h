//
//  CustomStepper.h
//  Pipopipette
//
//  Created by Paul Lavoine on 03/04/2016.
//  Copyright © 2016 Paul Lavoine. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomStepperDelegate <NSObject>

- (IBAction)valueChanged:(UIStepper *)sender;

@end


@interface CustomStepper : UIStepper

@property (nonatomic, strong) id<CustomStepperDelegate> delegate;

@end
