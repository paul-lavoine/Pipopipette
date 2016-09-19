//
//  MenuViewController.m
//  PetitCarres
//
//  Created by Paul Lavoine on 07/02/2016.
//  Copyright © 2016 Paul Lavoine. All rights reserved.
//

#import "MenuViewController.h"
#import "MapViewController.h"
#import "PlayerManager.h"
#import "GlobalConfigurations.h"
#import "SetupGameViewController.h"
#import "TutorielViewController.h"
#import "CGUViewController.h"

#define IMAGE_WIDTH (IS_IPAD ? 90 : 56)

@interface MenuViewController ()

// Outlets
@property (weak, nonatomic) IBOutlet UILabel *playLabelButton;
@property (weak, nonatomic) IBOutlet UILabel *creditsLabelButton;
@property (weak, nonatomic) IBOutlet UILabel *setupLabelButton;
@property (weak, nonatomic) IBOutlet UILabel *tutorielLabelButton;
@property (weak, nonatomic) IBOutlet UILabel *firstPartTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondPartTitleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleHeightConstraint;

@property (weak, nonatomic) IBOutlet UIView *logoView;
@property (weak, nonatomic) IBOutlet UIView *playView;
@property (weak, nonatomic) IBOutlet UIView *setupView;
@property (weak, nonatomic) IBOutlet UIView *creditView;
@property (weak, nonatomic) IBOutlet UIImageView *creditImageView;

@property (weak, nonatomic) IBOutlet UIImageView *setupImageView;
@property (weak, nonatomic) IBOutlet UIView *setupButtonView;

@property (weak, nonatomic) IBOutlet UIImageView *tutorielImageView;
@property (weak, nonatomic) IBOutlet UIView *tutorielButtonView;

// Constraint
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthImageLogoConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthPlayButtonConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthTutorialButtonConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthSetupButtonConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthCGUButtonConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingCGUConstraint;

@end

@implementation MenuViewController

#pragma mark - View lifeCycle
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
    
    // Tint color button
    [self.setupImageView setTintColor:[UIColor whiteColor]];
    [self.creditImageView setTintColor:GREEN_COLOR];
    
    self.playLabelButton.text = [LOCALIZED_STRING(@"menu.play.button") uppercaseString];
    self.tutorielLabelButton.text = [LOCALIZED_STRING(@"menu.tutoriel.button") uppercaseString];
    self.setupLabelButton.text = [LOCALIZED_STRING(@"menu.setup.button") uppercaseString];
    self.creditsLabelButton.text = [LOCALIZED_STRING(@"menu.credits.button") uppercaseString];
    
    UIFont *fontName = IS_IPAD ? ROBOTO_BOLD(25.0f) : ROBOTO_REGULAR(18.0f);
    [self.playLabelButton setFont:fontName];
    [self.tutorielLabelButton setFont:fontName];
    [self.setupLabelButton setFont:fontName];
    [self.creditsLabelButton setFont:fontName];
    
    if (IS_IPAD)
    {
        self.widthImageLogoConstraint.constant = 200;
        [self.firstPartTitleLabel setFont:ROBOTO_THIN(30.0f)];
        [self.secondPartTitleLabel setFont:ROBOTO_REGULAR(30.0f)];
        
        self.widthPlayButtonConstraint.constant = IMAGE_WIDTH;
        self.widthTutorialButtonConstraint.constant = IMAGE_WIDTH;
        self.widthSetupButtonConstraint.constant = IMAGE_WIDTH;
        self.widthCGUButtonConstraint.constant = IMAGE_WIDTH + 5;
        
        self.trailingCGUConstraint.constant = 30;
        self.titleHeightConstraint.constant = 30;
    } else {
        [self.firstPartTitleLabel setFont:ROBOTO_THIN(17.0f)];
        [self.secondPartTitleLabel setFont:ROBOTO_REGULAR(17.0f)];
    }
    
    self.firstPartTitleLabel.text = [LOCALIZED_STRING(@"credits.title_determinant.label") uppercaseString];
    self.secondPartTitleLabel.text = [LOCALIZED_STRING(@"credits.title_game_name.label") uppercaseString];
}

#pragma mark - Actions

- (IBAction)startGameAction:(id)sender
{
    [[PlayerManager sharedInstance] setNumberOfPlayers:NB_DEFAULT_PLAYER numberOfBot:NB_DEFAULT_BOT botLevel:BotLevelMedium];
    
    MapViewController *mapViewController = [self.storyboard instantiateViewControllerWithIdentifier:MapViewControllerID];
    [mapViewController configureMapWithRows:NB_DEFAULT_ROWS columns:NB_DEFAULT_COLUMNS];
    
    [self.navigationController pushViewController:mapViewController animated:YES];
}

- (IBAction)creditAction:(id)sender
{
    CGUViewController *cguViewController = [[CGUViewController alloc] init];
    [self pushViewController:cguViewController title:[LOCALIZED_STRING(@"menu.credits.button") uppercaseString] image:[UIImage imageNamed:@"credit_button"]];
}

- (IBAction)tutorielAction:(id)sender
{
    TutorielViewController *tutorielViewController = [[TutorielViewController alloc] init];
    [self pushViewController:tutorielViewController title:[LOCALIZED_STRING(@"menu.tutoriel.button") uppercaseString ]image:[UIImage imageNamed:@"tutoriel_icon"]];
}

- (IBAction)setupAction:(id)sender
{
    SetupGameViewController *setupGameViewController = [[SetupGameViewController alloc] init];
    [self pushViewController:setupGameViewController title:[LOCALIZED_STRING(@"menu.setup.button") uppercaseString] image:[UIImage imageNamed:@"setup_button"]];
}

- (void)pushViewController:(ChildViewController *)viewController title:(NSString *)title image:(UIImage *)image
{
    RootViewController *rootViewController = [[RootViewController alloc] initWithTitle:title image:image subView:viewController];
    [self.navigationController pushViewController:rootViewController animated:YES];
}

@end
