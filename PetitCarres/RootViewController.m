//
//  RootViewController.m
//  PetitCarres
//
//  Created by Paul Lavoine on 09/02/2016.
//  Copyright © 2016 Paul Lavoine. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController () <UINavigationControllerDelegate>

// Outlets
@property (weak, nonatomic) IBOutlet UIView *backButton;
@property (weak, nonatomic) IBOutlet UIImageView *titleImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *childView;

// Data
@property (nonatomic, strong) UIView *subView;
@property (nonatomic, strong) NSString *titleView;
@property (nonatomic, strong) UIImage *image;
@end

@implementation RootViewController


#pragma mark - Constructor

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image subView:(UIView *)subView
{
    if (self = [super initWithNibName:@"RootViewController" bundle:nil])
    {
        self.navigationController.delegate = self;
        self.navigationController.navigationBarHidden = YES;
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
        _subView = subView;
        _titleView = title;
        _image = image;
    }
    
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    // Title
    self.titleLabel.text = self.titleView;
    
    // Image
    self.titleImageView.image = self.image;
    [self.titleImageView setTintColor:BLACK_COLOR];
    
    // ChildView
    [self addConstraintToContentView];
    
    // Gesture Recognizer
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backViewAction:)];
    [self.backButton addGestureRecognizer:tapRecognizer];
}

- (void)addConstraintToContentView
{
    self.subView.translatesAutoresizingMaskIntoConstraints = NO;
    self.childView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.childView addSubview:self.subView];
    
    [self.childView addConstraint:[NSLayoutConstraint constraintWithItem:self.subView
                                                     attribute:NSLayoutAttributeTrailing
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.childView
                                                     attribute:NSLayoutAttributeTrailing
                                                    multiplier:1.0
                                                      constant:0.0]];
    
    [self.childView addConstraint:[NSLayoutConstraint constraintWithItem:self.subView
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.childView
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0
                                                      constant:0.0]];
    
    [self.childView addConstraint:[NSLayoutConstraint constraintWithItem:self.subView
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.childView
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0
                                                      constant:0.0]];
    
    [self.childView addConstraint:[NSLayoutConstraint constraintWithItem:self.subView
                                                     attribute:NSLayoutAttributeLeading
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.childView
                                                     attribute:NSLayoutAttributeLeading
                                                    multiplier:1.0
                                                      constant:0.0]];
}


#pragma mark - Actions
- (IBAction)backViewAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
