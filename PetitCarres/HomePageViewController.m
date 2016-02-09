//
//  HomePageViewController.m
//  PetitCarres
//
//  Created by Paul Lavoine on 07/02/2016.
//  Copyright © 2016 Paul Lavoine. All rights reserved.
//

#import "HomePageViewController.h"
#import "MapViewController.h"
#import "PlayerManager.h"
#import "GlobalConfigurations.h"
#import "MenuViewController.h"
#import "TutorielViewController.h"

@interface HomePageViewController ()

// Outlets
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *configureGameButton;
@property (weak, nonatomic) IBOutlet UIView *logoView;
@property (weak, nonatomic) IBOutlet UIView *playView;
@property (weak, nonatomic) IBOutlet UIView *setupView;
@property (weak, nonatomic) IBOutlet UIView *creditView;

// Data

@end

@implementation HomePageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureUI];
}

- (void)configureUI
{
    [self.navigationController setNavigationBarHidden:YES];

    
    // Background Color
    self.playView.backgroundColor = GREEN_COLOR;
    self.setupView.backgroundColor = PINK_COLOR;
    self.creditView.backgroundColor = [UIColor whiteColor];
    self.logoView.backgroundColor = [UIColor whiteColor];
}

#pragma mark - Actions

- (IBAction)startGameAction:(id)sender
{
    [[PlayerManager sharedInstance] setNumberOfPlayers:NB_DEFAULT_PLAYER numberOfBot:NB_DEFAULT_BOT botLevel:BotLevelMedium];
    
    MapViewController *mapViewController = [self.storyboard instantiateViewControllerWithIdentifier:MapViewControllerID];
    [mapViewController configureMapWithRows:NB_DEFAULT_ROWS columns:NB_DEFAULT_COLUMNS];
    
    [self.navigationController pushViewController:mapViewController animated:YES];
}

@end
