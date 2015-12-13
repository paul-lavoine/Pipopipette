//
//  StartViewController.m
//  PetitCarres
//
//  Created by Paul Lavoine on 07/12/2015.
//  Copyright © 2015 Paul Lavoine. All rights reserved.
//

#import "StartViewController.h"
#import "MapViewController.h"
#import "PlayerManager.h"
#import "BarButton.h"

#define NUMBER_PLAYER_LABEL @"Nombre de joueur :"
#define NUMBER_BOT_LABEL @"Nombre de Bot :"
#define NB_MAX_PLAYER 4
#define NB_MIN_PLAYER 1
#define NB_MIN_BOT 0
#define NB_DEFAULT_PLAYER 2
#define NB_DEFAULT_BOT 0

@interface StartViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

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
@property (weak, nonatomic) IBOutlet UIButton *easyButton;
@property (weak, nonatomic) IBOutlet UIButton *mediumButton;
@property (weak, nonatomic) IBOutlet UIButton *difficultButton;

// Data
@property (nonatomic, strong) UIView *colorSelectedButtonView;
@property (assign, nonatomic) NSInteger nbPlayer;
@property (assign, nonatomic) NSInteger nbBot;
@property (assign, nonatomic) NSInteger botLevel;
@property (nonatomic, assign) BOOL alreadyAppear;

@end

@implementation StartViewController

#pragma mark - Initializers
- (instancetype)init
{
    if (self = [super init])
    {
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
        self.colorSelectedButtonView.frame = self.mediumButton.frame;
    }
}

- (void)configureDefaultMenu
{
    self.nbPlayer = NB_DEFAULT_PLAYER;
    self.nbBot = NB_DEFAULT_BOT;
    
    // Init Stepper
    [self.nbPlayerLabel setText:[NSString stringWithFormat:@"%@ %d",NUMBER_PLAYER_LABEL, NB_DEFAULT_PLAYER]];
    [self.nbBotLabel setText:[NSString stringWithFormat:@"%@ %d",NUMBER_BOT_LABEL, NB_DEFAULT_BOT]];
    [self.incrementPlayerStepper setValue:NB_DEFAULT_PLAYER];
    [self.incrementBotStepper setValue:NB_DEFAULT_BOT];
    
    // Init Picker View
    [self.columnPicker selectRow:2 inComponent:0 animated:NO];
    [self.rowPicker selectRow:2 inComponent:0 animated:NO];
    
    // Init button
    [[self.easyButton layer] setBorderWidth:1.0f];
    [[self.easyButton layer] setBorderColor:[UIColor blackColor].CGColor];
    [[self.mediumButton layer] setBorderWidth:1.0f];
    [[self.mediumButton layer] setBorderColor:[UIColor blackColor].CGColor];
    [[self.difficultButton layer] setBorderWidth:1.0f];
    [[self.difficultButton layer] setBorderColor:[UIColor blackColor].CGColor];
    
    // Init
    self.colorSelectedButtonView = [[UIView alloc] initWithFrame:self.mediumButton.frame];
    self.colorSelectedButtonView.backgroundColor = [UIColor blueColor];
    [self.contentLevelView insertSubview:self.colorSelectedButtonView atIndex:0];
    [self changeBotLevel:self.mediumButton];
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
    NSLog(@"level %d", level);
    [[PlayerManager sharedInstance] setNumberOfPlayers:self.nbPlayer numberOfBot:self.nbBot botLevel:level];

    MapViewController *mapViewController = [self.storyboard instantiateViewControllerWithIdentifier:MapViewControllerID];
    [mapViewController configureMapWithRows:([self.rowPicker selectedRowInComponent:0] + 1) columns:([self.columnPicker selectedRowInComponent:0] + 1)];
    
    [self.navigationController pushViewController:mapViewController animated:YES];
}

- (IBAction)valueChanged:(UIStepper *)sender
{
    if (sender == self.incrementPlayerStepper)
    {
        if (sender.value + self.nbBot + 1 > NB_MAX_PLAYER)
            self.incrementPlayerStepper.value = NB_MAX_PLAYER - self.nbBot;
        else if (sender.value - 1 < NB_MIN_PLAYER)
            self.incrementPlayerStepper.value = NB_MIN_PLAYER;
        
        self.nbPlayer = [sender value];
        [self.nbPlayerLabel setText:[NSString stringWithFormat:@"%@ %ld",NUMBER_PLAYER_LABEL, (long)self.nbPlayer]];
    }
    else
    {
        if (self.nbPlayer + sender.value + 1 > NB_MAX_PLAYER)
            self.incrementBotStepper.value = NB_MAX_PLAYER - self.nbPlayer;
        else if (self.nbPlayer + sender.value - 1 < NB_MIN_BOT)
            self.incrementBotStepper.value = NB_MIN_BOT;
        
        self.nbBot = [sender value];
        [self.nbBotLabel setText:[NSString stringWithFormat:@"%@ %ld",NUMBER_BOT_LABEL, (long)self.nbBot]];
    }
}

- (IBAction)changeBotLevel:(UIButton *)sender
{
    [self.easyButton setSelected:NO];
    [self.mediumButton setSelected:NO];
    [self.difficultButton setSelected:NO];

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
