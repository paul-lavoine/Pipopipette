//
//  CGUViewController.m
//  PetitCarres
//
//  Created by Paul Lavoine on 08/02/2016.
//  Copyright © 2016 Paul Lavoine. All rights reserved.
//

#import "CGUViewController.h"

#define MIN_ZOOM_OUT 0.9
#define ANIMATION_DURATION 0.7

@interface CGUViewController ()

// Outlets
@property (weak, nonatomic) IBOutlet UILabel *developmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *designLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleGameLabel;
@property (weak, nonatomic) IBOutlet UILabel *copyrightLabel;
@property (weak, nonatomic) IBOutlet UILabel *websiteAccessLabel;

// Data
@property (nonatomic, assign) BOOL stopAnimation;

@end


@implementation CGUViewController

#pragma mark - Initializers

- (instancetype)init
{
    if (self = [super initWithNibName:@"CGUViewController" bundle:nil])
    {
        
    }
    
    return self;
}

#pragma mark - Life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureUI];
    [self startAnimation];
    
    self.websiteAccessLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openWebsite)];
    [self.websiteAccessLabel addGestureRecognizer:tapGesture];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.stopAnimation = YES;
}

- (void)configureUI
{
    UIFont *regularFont = [UIFont fontWithName:@"Roboto-Regular" size:15.0f];
    UIFont *lightFont = [UIFont fontWithName:@"Roboto-Light" size:16.5f];
    UIFont *lightBigFont = [UIFont fontWithName:@"Roboto-Light" size:23.5f];
    UIFont *thinFont = [UIFont fontWithName:@"Roboto-Thin" size:20.0f];
    
    NSMutableAttributedString *development = [[NSMutableAttributedString alloc] initWithString:@"application développé par\n" attributes:@{NSFontAttributeName : lightFont}];
    [development appendAttributedString:[[NSAttributedString alloc] initWithString:@"PAUL LAVOINE" attributes:@{NSFontAttributeName : regularFont}]];
    
    
    self.designLabel.attributedText = [[NSAttributedString alloc] initWithString:@"design par" attributes:@{NSFontAttributeName : lightFont}];
    
    self.websiteAccessLabel.attributedText = [[NSAttributedString alloc] initWithString:@"MARINE DI FRANCO"
                                                                             attributes:@{NSFontAttributeName : regularFont,
                                                                                          NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)}];
    
    NSMutableAttributedString *titleThin = [[NSMutableAttributedString alloc] initWithString:@"LA "
                                                                                  attributes:@{NSFontAttributeName : thinFont}];
    
    [titleThin appendAttributedString:[[NSAttributedString alloc] initWithString:@"PIPOPIPETTE"
                                                                      attributes:@{NSFontAttributeName : lightBigFont}]];
    
    NSAttributedString *copyrightLight = [[NSAttributedString alloc] initWithString:@"© copyright Paul Lavoine - 2016"
                                                                         attributes:@{NSFontAttributeName : lightFont}];
    
    self.developmentLabel.attributedText = development;
    self.titleGameLabel.attributedText = titleThin;
    self.copyrightLabel.attributedText = copyrightLight;
}

#pragma mark - Animations
- (void)startAnimation
{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        //Background Thread
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self popUpZoomIn];
        });
    });
    
    
}

- (void)popUpZoomIn
{
    self.websiteAccessLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, MIN_ZOOM_OUT, MIN_ZOOM_OUT);
    [UIView animateWithDuration:ANIMATION_DURATION
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.websiteAccessLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0);
                     } completion:^(BOOL finished) {
                         if (!self.stopAnimation)
                         {
                             [self popZoomOut];
                         }
                     }];
}

- (void)popZoomOut
{
    [UIView animateWithDuration:ANIMATION_DURATION
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.websiteAccessLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, MIN_ZOOM_OUT, MIN_ZOOM_OUT);
                     } completion:^(BOOL finished){
                         if (!self.stopAnimation)
                         {
                             [self popUpZoomIn];
                         }
                     }];
}

#pragma mark - Utils

- (void)openWebsite
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.marine-difranco.fr"]];
}

@end
