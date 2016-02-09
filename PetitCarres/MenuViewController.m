//
//  MenuViewController.m
//  PetitCarres
//
//  Created by Paul Lavoine on 07/12/2015.
//  Copyright © 2015 Paul Lavoine. All rights reserved.
//

#import "MenuViewController.h"
#import "MapViewController.h"
#import "PlayerManager.h"
#import "BarButton.h"
#import "GlobalConfigurations.h"

#define NUMBER_PLAYER_LABEL @"Nombre de joueur :"
#define NUMBER_BOT_LABEL @"Nombre de Bot :"


@interface MenuViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

// Outlets
@property (weak, nonatomic) IBOutlet UILabel *nbPlayerLabel;
@property (weak, nonatomic) IBOutlet UIStepper *incrementPlayerStepper;

@property (weak, nonatomic) IBOutlet UILabel *nbBotLabel;
@property (weak, nonatomic) IBOutlet UIStepper *incrementBotStepper;

@property (weak, nonatomic) IBOutlet UIButton *startGameButton;
@property (weak, nonatomic) IBOutlet UIPickerView *columnPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *rowPicker;

// Switch button
@property (weak, nonatomic) IBOutlet UIView *contentLevelView;
@property (strong, nonatomic) UIButton *defaultSelectedButton;
@property (weak, nonatomic) IBOutlet UIButton *easyButton;
@property (weak, nonatomic) IBOutlet UIButton *mediumButton;
@property (weak, nonatomic) IBOutlet UIButton *difficultButton;
@property (weak, nonatomic) IBOutlet UIButton *extremeButton;

// Data
@property (nonatomic, strong) GlobalConfigurations *configurations;
@property (nonatomic, strong) UIView *colorSelectedButtonView;
@property (nonatomic, assign) BOOL alreadyAppear;

@end

@implementation MenuViewController

#pragma mark - Initializers

- (instancetype)init
{
    if (self = [super initWithNibName:@"MenuViewController" bundle:nil])
    {

    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.configurations = [GlobalConfigurations sharedInstance];
    self.defaultSelectedButton = self.extremeButton;
    
    [self configureDefaultMenu];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!self.alreadyAppear)
    {
        self.alreadyAppear = true;
        
        // Update view
        self.colorSelectedButtonView.frame = self.defaultSelectedButton.frame;
    }
}

- (void)configureDefaultMenu
{
    // Init game start button
    [self.startGameButton.layer setBorderWidth:1.0f];
    [self.startGameButton.layer setBorderColor:[UIColor blackColor].CGColor];
    self.startGameButton.layer.cornerRadius = 13.0f;
    
    // Init Stepper
    [self.nbPlayerLabel setText:[NSString stringWithFormat:@"%@ %d",NUMBER_PLAYER_LABEL, NB_DEFAULT_PLAYER]];
    [self.nbBotLabel setText:[NSString stringWithFormat:@"%@ %d",NUMBER_BOT_LABEL, NB_DEFAULT_BOT]];
    [self.incrementPlayerStepper setValue:NB_DEFAULT_PLAYER];
    [self.incrementBotStepper setValue:NB_DEFAULT_BOT];
    
    // Init Picker View
    [self.columnPicker selectRow:NB_DEFAULT_COLUMNS - 1 inComponent:0 animated:NO];
    [self.rowPicker selectRow:NB_DEFAULT_ROWS - 1 inComponent:0 animated:NO];
    
    // Init level button
    [[self.easyButton layer] setBorderWidth:1.0f];
    [[self.easyButton layer] setBorderColor:[UIColor blackColor].CGColor];
    [[self.mediumButton layer] setBorderWidth:1.0f];
    [[self.mediumButton layer] setBorderColor:[UIColor blackColor].CGColor];
    [[self.difficultButton layer] setBorderWidth:1.0f];
    [[self.difficultButton layer] setBorderColor:[UIColor blackColor].CGColor];
    [[self.extremeButton layer] setBorderWidth:1.0f];
    [[self.extremeButton layer] setBorderColor:[UIColor blackColor].CGColor];
    
    [self initLevelBot:self.defaultSelectedButton];
}

- (void)initLevelBot:(UIButton *)button
{
    self.colorSelectedButtonView = [[UIView alloc] initWithFrame:button.frame];
    self.colorSelectedButtonView.backgroundColor = [UIColor blueColor];
    [self.contentLevelView insertSubview:self.colorSelectedButtonView atIndex:0];
    [self changeBotLevel:button];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
    int minSpaceBorder = (MIN_LARGER_TOUCH - BAR_BUTTON_SPACE) / 2;
    
    // Limite le nombre de case à l'espace possile dans la vue
    if (self.columnPicker == thePickerView)
    {
        return [self limitNumberOfSquarre:10
                        highSideBarButton:SIZE_PIECE
                                    space:BAR_BUTTON_SPACE
                           minSpaceBorder:minSpaceBorder
                                 widthMax:self.view.frame.size.width];
    }
    
    return [self limitNumberOfSquarre:10
                    highSideBarButton:SIZE_PIECE
                                space:BAR_BUTTON_SPACE
                       minSpaceBorder:minSpaceBorder
                             widthMax:self.view.frame.size.height];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%ld",(long)row + 1];
}

#pragma mark - Actions

- (IBAction)startGame:(id)sender
{
    BotLevel level = [self selectedLevel];
    [[PlayerManager sharedInstance] setNumberOfPlayers:self.configurations.nbPlayer numberOfBot:self.configurations.nbBot botLevel:level];

    MapViewController *mapViewController = [self.storyboard instantiateViewControllerWithIdentifier:MapViewControllerID];
    [mapViewController configureMapWithRows:([self.rowPicker selectedRowInComponent:0] + 1) columns:([self.columnPicker selectedRowInComponent:0] + 1)];
    
    [self.navigationController pushViewController:mapViewController animated:YES];
}

- (IBAction)valueChanged:(UIStepper *)sender
{
    if (sender == self.incrementPlayerStepper)
    {
        if (sender.value + self.configurations.nbBot + 1 > NB_MAX_PLAYER)
            self.incrementPlayerStepper.value = NB_MAX_PLAYER - self.configurations.nbBot;
        else if (sender.value - 1 < NB_MIN_PLAYER)
            self.incrementPlayerStepper.value = NB_MIN_PLAYER;
        
        self.configurations.nbPlayer = [sender value];
        [self.nbPlayerLabel setText:[NSString stringWithFormat:@"%@ %ld",NUMBER_PLAYER_LABEL, (long)self.configurations.nbPlayer]];
    }
    else
    {
        if (self.configurations.nbPlayer + sender.value + 1 > NB_MAX_PLAYER)
            self.incrementBotStepper.value = NB_MAX_PLAYER - self.configurations.nbPlayer;
        else if (self.configurations.nbPlayer + sender.value - 1 < NB_MIN_BOT)
            self.incrementBotStepper.value = NB_MIN_BOT;
        
        self.configurations.nbBot = [sender value];
        [self.nbBotLabel setText:[NSString stringWithFormat:@"%@ %ld",NUMBER_BOT_LABEL, (long)self.configurations.nbBot]];
    }
    
    if (self.configurations.nbBot + self.configurations.nbPlayer >= NB_MAX_PLAYER)
    {
        self.navigationItem.title = @"Nombre de joueur max atteint";
        self.navigationController.navigationBar.titleTextAttributes = @{
                                                                        NSForegroundColorAttributeName : [UIColor redColor],
                                                                        NSFontAttributeName : [UIFont fontWithName:@"Helvetica-Bold" size:15.0f]
                                                                        };
    }
    else
    {
        self.navigationItem.title = @"";
    }
}

- (IBAction)changeBotLevel:(UIButton *)sender
{
    [self.easyButton setSelected:NO];
    [self.mediumButton setSelected:NO];
    [self.difficultButton setSelected:NO];
    [self.extremeButton setSelected:NO];

    [sender setSelected:YES];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
    [UIView animateWithDuration:0.5f animations:^{
        self.colorSelectedButtonView.frame = CGRectOffset(sender.frame, 0, 0);
    }];
}

#pragma mark - Utils

- (BotLevel)selectedLevel
{
    if (self.easyButton.isSelected)
    {
        return BotLevelEasy;
    }
    else if (self.mediumButton.isSelected)
    {
        return BotLevelMedium;
    }
    else if (self.extremeButton.isSelected)
    {
        return BotLevelExtreme;
    }
    else
    {
        return BotLevelDifficult;
    }
}

- (NSInteger)limitNumberOfSquarre:(NSInteger)cases highSideBarButton:(NSInteger)highSideBarButton space:(NSInteger)space minSpaceBorder:(NSInteger)minSpaceBorder widthMax:(NSInteger)widthMax
{
    NSInteger nbCaseAvailable = cases;
    while (widthMax < ((nbCaseAvailable*highSideBarButton) + (space*(nbCaseAvailable+1) + 2*minSpaceBorder)))
    {
        nbCaseAvailable --;
    }
    
    return nbCaseAvailable;
}

@end
