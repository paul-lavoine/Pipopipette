//
//  CustomStepper.m
//  Pipopipette
//
//  Created by Paul Lavoine on 03/04/2016.
//  Copyright © 2016 Paul Lavoine. All rights reserved.
//

#import "CustomStepper.h"

@interface CustomStepper ()

// Outlets
@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (nonatomic, weak) IBOutlet UIView *separator;

@end

@implementation CustomStepper

#pragma mark - Initializers

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self commonInit];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit
{
    [[NSBundle mainBundle] loadNibNamed:@"CustomStepper" owner:self options:nil];
    [self addConstraintToContentView];
}

- (void)addConstraintToContentView
{
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addSubview:self.contentView];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView
                                                     attribute:NSLayoutAttributeTrailing
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTrailing
                                                    multiplier:1.0
                                                      constant:0.0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0
                                                      constant:0.0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0
                                                      constant:0.0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView
                                                     attribute:NSLayoutAttributeLeading
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeading
                                                    multiplier:1.0
                                                      constant:0.0]];
}

- (IBAction)valueChange:(id)sender
{
    if (sender == self.leftButton) { self.value --; }
    else { self.value ++; }
    [self.delegate valueChanged:self];
}

@end
