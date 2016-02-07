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

@interface HomePageViewController ()

@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *configureGameButton;

@end

@implementation HomePageViewController




#pragma mark - Actions

- (IBAction)startGameAction:(id)sender
{
    [[PlayerManager sharedInstance] setNumberOfPlayers:NB_DEFAULT_PLAYER numberOfBot:NB_DEFAULT_BOT botLevel:BotLevelMedium];
    
    MapViewController *mapViewController = [self.storyboard instantiateViewControllerWithIdentifier:MapViewControllerID];
    [mapViewController configureMapWithRows:NB_DEFAULT_ROWS columns:NB_DEFAULT_COLUMNS];
    
    [self.navigationController pushViewController:mapViewController animated:YES];
}

@end
