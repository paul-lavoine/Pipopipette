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
@property (weak, nonatomic) IBOutlet UIView *contentChildView;

// Constraint
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthImageConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingContentViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingContentViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topContentViewConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomContentViewConstraint;


// Data
@property (nonatomic, strong) ChildViewController *subView;
@property (nonatomic, strong) NSString *titleView;
@property (nonatomic, strong) UIImage *image;
@end

@implementation RootViewController


#pragma mark - Initializers

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image subView:(ChildViewController *)subView
{
    if (self = [super initWithNibName:@"RootViewController" bundle:nil])
    {
        self.navigationController.delegate = self;
        self.navigationController.navigationBarHidden = YES;
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
        _subView = subView;
        _subView.navigationController.delegate = self;
        _subView.rootParentViewController = self;
        _titleView = title;
        _image = image;
    }
    
    return self;
}

#pragma mark - View lifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Title
    self.titleLabel.text = self.titleView;
    
    // Image
    self.titleImageView.image = self.image;
    [self.titleImageView setTintColor:BLACK_COLOR];
    
    // Manage constraint for background image
    [self updateConstraintContentViewSize];
    
    // ChildView
    [self addConstraintToContentView];
    
    if (IS_IPAD)
    {
        self.widthImageConstraint.constant = 60;
        [self.titleLabel setFont:ROBOTO_REGULAR(24.0f)];
    }
    
    // Gesture Recognizer
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backViewAction:)];
    [self.backButton addGestureRecognizer:tapRecognizer];
    
    
    UISwipeGestureRecognizer *gestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandler:)];
    [gestureRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.view addGestureRecognizer:gestureRecognizer];
}

- (void)addConstraintToContentView
{
    self.subView.view.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentChildView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.contentChildView addSubview:self.subView.view];
    
    [self.contentChildView addConstraint:[NSLayoutConstraint constraintWithItem:self.subView.view
                                                     attribute:NSLayoutAttributeTrailing
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.contentChildView
                                                     attribute:NSLayoutAttributeTrailing
                                                    multiplier:1.0
                                                      constant:0.0]];
    
    [self.contentChildView addConstraint:[NSLayoutConstraint constraintWithItem:self.subView.view
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.contentChildView
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0
                                                      constant:0.0]];
    
    [self.contentChildView addConstraint:[NSLayoutConstraint constraintWithItem:self.subView.view
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.contentChildView
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0
                                                      constant:0.0]];
    
    [self.contentChildView addConstraint:[NSLayoutConstraint constraintWithItem:self.subView.view
                                                     attribute:NSLayoutAttributeLeading
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.contentChildView
                                                     attribute:NSLayoutAttributeLeading
                                                    multiplier:1.0
                                                      constant:0.0]];
}

- (void)updateConstraintContentViewSize
{
    if (IS_IPAD) {
        self.leadingContentViewConstraint.constant += 23;
        self.trailingContentViewConstraint.constant += 25;
        self.topContentViewConstraint.constant += 5;
        self.bottomContentViewConstraint.constant += 5;
    } if (IS_IPHONE_5 || IS_IPHONE_4) {
        self.leadingContentViewConstraint.constant -= 3;
        self.trailingContentViewConstraint.constant -= 2;
        self.topContentViewConstraint.constant -= 3;
        self.bottomContentViewConstraint.constant -= 3;
    } else if (IS_IPHONE_6) {
     // it's ok
    } else {
        self.leadingContentViewConstraint.constant += 2;
        self.trailingContentViewConstraint.constant += 3;
        self.topContentViewConstraint.constant += 3;
        self.bottomContentViewConstraint.constant += 3;
    }
}

#pragma mark - Actions
- (IBAction)backViewAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)swipeHandler:(UISwipeGestureRecognizer *)recognizer
{
    if(recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Utils

- (void)pushViewController:(UIViewController *)viewController
{
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
