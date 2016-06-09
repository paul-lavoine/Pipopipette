//
//  CGUViewController.m
//  PetitCarres
//
//  Created by Paul Lavoine on 08/02/2016.
//  Copyright © 2016 Paul Lavoine. All rights reserved.
//

#import "CGUViewController.h"
#import "Animation.h"

#define URL_MARINE_WEBSITE @"http://www.marine-difranco.fr"

@interface CGUViewController ()

// Outlets
@property (weak, nonatomic) IBOutlet UILabel *developmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *designLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleGameLabel;
@property (weak, nonatomic) IBOutlet UILabel *copyrightLabel;
@property (weak, nonatomic) IBOutlet UILabel *websiteAccessLabel;


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
    [[Animation sharedInstance] startAnimation:self.websiteAccessLabel];
    
    self.websiteAccessLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openWebsite)];
    [self.websiteAccessLabel addGestureRecognizer:tapGesture];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [Animation sharedInstance].stopAnimation = YES;
}

- (void)configureUI
{
    UIFont *regularFont = ROBOTO_REGULAR(15.0f);
    UIFont *lightFont = ROBOTO_LIGHT(16.5f);
    UIFont *lightBigFont = ROBOTO_LIGHT(23.5f);
    UIFont *thinFont = ROBOTO_THIN(20.0f);
    
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



#pragma mark - Utils

- (void)openWebsite
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:URL_MARINE_WEBSITE]];
}

@end
