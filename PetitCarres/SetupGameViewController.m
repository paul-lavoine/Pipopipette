//
//  SetupGameViewController.m
//  PetitCarres
//
//  Created by Paul Lavoine on 07/12/2015.
//  Copyright © 2015 Paul Lavoine. All rights reserved.
//

#import "SetupGameViewController.h"
#import "MapViewController.h"
#import "PlayerManager.h"
#import "BarButton.h"
#import "CustomStepper.h"
#import "GlobalConfigurations.h"
#import "NSAttributedString+CCLFormat.h"

#define DEFAULT_LEVEL           3
#define OFFSET_IPAD_FONT_SIZE   (IS_IPAD ? 8.0f : 0.0f)
#define BUTTON_IPAD_HEIGHT      80

@interface SetupGameViewController () <UINavigationControllerDelegate, CustomStepperDelegate>

// Outlets
@property (weak, nonatomic) IBOutlet UILabel *nbPlayerLabel;
@property (weak, nonatomic) IBOutlet UIButton *firstPlayerButton;
@property (weak, nonatomic) IBOutlet UIButton *secondPlayerButton;
@property (weak, nonatomic) IBOutlet UIButton *thirdPlayerButton;
@property (weak, nonatomic) IBOutlet UIButton *fourthPlayerButton;

@property (weak, nonatomic) IBOutlet UILabel *nbBotLabel;
@property (weak, nonatomic) IBOutlet UIButton *firstBotButton;
@property (weak, nonatomic) IBOutlet UIButton *secondBotButton;
@property (weak, nonatomic) IBOutlet UIButton *thirdBotButton;
@property (weak, nonatomic) IBOutlet UIButton *fourthBotButton;

@property (weak, nonatomic) IBOutlet UILabel *nbColumnLabel;
@property (weak, nonatomic) IBOutlet CustomStepper *nbColumnStepper;
@property (weak, nonatomic) IBOutlet UILabel *nbRowLabel;
@property (weak, nonatomic) IBOutlet CustomStepper *nbRowStepper;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet CustomStepper *levelStepper;

@property (weak, nonatomic) IBOutlet UIButton *startGameButton;
@property (weak, nonatomic) IBOutlet UIView *playersButtonView;
@property (weak, nonatomic) IBOutlet UIView *botsButtonView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstPlayerButtonHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstBotButtonHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *playButtonHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *botTitlePlayerButtonVerticalConstraint;


// Data
@property (nonatomic, strong) NSArray *players;
@property (nonatomic, strong) NSArray *realPlayers;
@property (nonatomic, strong) NSArray *botPlayers;
@property (nonatomic, assign) BOOL reachMaxPlayers;
@property (nonatomic, assign) NSInteger nbColumnMax;
@property (nonatomic, assign) NSInteger nbRowMax;

// Data
@property (nonatomic, strong) GlobalConfigurations *configurations;
//@property (nonatomic, strong) UIView *colorSelectedButtonView;
@property (nonatomic, assign) BOOL alreadyAppear;

@end

@implementation SetupGameViewController

#pragma mark - Initializers

- (instancetype)init
{
    if (self = [super initWithNibName:@"SetupGameViewController" bundle:nil])
    {
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.configurations = [GlobalConfigurations sharedInstance];
    [self.levelStepper setValue:DEFAULT_LEVEL];
    self.navigationController.delegate = self;
    self.nbColumnStepper.delegate = self;
    self.nbRowStepper.delegate = self;
    self.levelStepper.delegate = self;
    
    if (IS_IPAD)
    {
        CGRect tmp = self.playersButtonView.frame;
        tmp.size.height = 75.0f;
        self.playersButtonView.frame = tmp;
        self.botsButtonView.frame = tmp;
        
        self.firstPlayerButtonHeightConstraint.constant = self.firstBotButtonHeightConstraint.constant = BUTTON_IPAD_HEIGHT;
        
        self.playButtonHeightConstraint.constant = 2*BUTTON_IPAD_HEIGHT/3;
        
        self.botTitlePlayerButtonVerticalConstraint.constant = 40;
        
    }
    
    [self.nbPlayerLabel setFont:ROBOTO_LIGHT(13.0f + OFFSET_IPAD_FONT_SIZE)];
    [self.nbBotLabel setFont:ROBOTO_LIGHT(13.0f + OFFSET_IPAD_FONT_SIZE)];
    [self.nbColumnLabel setFont:ROBOTO_LIGHT(13.0f + OFFSET_IPAD_FONT_SIZE)];
    
    self.players = @[self.firstPlayerButton, self.firstBotButton, self.secondBotButton, self.secondPlayerButton, self.thirdBotButton, self.thirdPlayerButton, self.fourthBotButton, self.fourthPlayerButton];
    
    self.realPlayers = @[self.firstPlayerButton, self.secondPlayerButton, self.thirdPlayerButton, self.fourthPlayerButton];
    
    self.botPlayers = @[self.firstBotButton, self.secondBotButton, self.thirdBotButton, self.fourthBotButton];
    
    [self configureDefaultMenu];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    int minSpaceBorder = (MIN_LARGER_TOUCH - BAR_BUTTON_SPACE) / 2;
    self.nbColumnMax = [self limitNumberOfSquarre:30
                                highSideBarButton:SIZE_PIECE
                                            space:BAR_BUTTON_SPACE
                                   minSpaceBorder:minSpaceBorder
                                         widthMax:self.rootParentViewController.view.frame.size.width];
    
    self.nbRowMax = [self limitNumberOfSquarre:30
                             highSideBarButton:SIZE_PIECE
                                         space:BAR_BUTTON_SPACE
                                minSpaceBorder:minSpaceBorder
                                      widthMax:self.rootParentViewController.view.frame.size.height - 120];
// 120 espace pour les boutons et le design ...
}

- (void)configureDefaultMenu
{
    // Init game start button
    self.startGameButton.backgroundColor = GREEN_COLOR;
    self.startGameButton.titleLabel.text = [LOCALIZED_STRING(@"setup.play.label") uppercaseString];
    self.startGameButton.titleLabel.textColor = [UIColor whiteColor];
    self.startGameButton.titleLabel.font = IS_IPAD ? ROBOTO_REGULAR(30.0f) : ROBOTO_REGULAR(15.0f);
    
    // Init Stepper
    [self.nbPlayerLabel setText:[LOCALIZED_STRING(@"setup.nb_player.label") uppercaseString]];
    [self.nbBotLabel setText:[LOCALIZED_STRING(@"setup.nb_bot.label") uppercaseString]];
    [self initPlayers];

    [self configureSteppers:self.nbColumnStepper label:self.nbColumnLabel string:LOCALIZED_STRING(@"setup.nb_column.label") value:NB_DEFAULT_COLUMNS];
    [self configureSteppers:self.nbRowStepper label:self.nbRowLabel string:LOCALIZED_STRING(@"setup.nb_row.label") value:NB_DEFAULT_ROWS];
    
    // Stepper
    self.nbColumnStepper.leftButton.backgroundColor = PINK_COLOR;
    self.nbColumnStepper.rightButton.backgroundColor = GREEN_COLOR;
    self.nbRowStepper.leftButton.backgroundColor = PINK_COLOR;
    self.nbRowStepper.rightButton.backgroundColor = GREEN_COLOR;
    self.levelStepper.leftButton.backgroundColor = PINK_COLOR;
    self.levelStepper.rightButton.backgroundColor = GREEN_COLOR;
    
    // Init level button
    [self.levelStepper setValue:DEFAULT_LEVEL];
    [self configureSteppers:self.levelStepper label:self.levelLabel string:LOCALIZED_STRING(@"setup.difficulty_player.label") value:DEFAULT_LEVEL];
}

- (void)initPlayers
{
    [self selectButton:self.firstBotButton isSelected:YES];
    [self selectButton:self.firstPlayerButton isSelected:YES];
    self.firstPlayerButton.userInteractionEnabled = NO;
    [self selectButton:self.secondPlayerButton isSelected:NO];
    [self selectButton:self.secondBotButton isSelected:NO];
    [self selectButton:self.thirdPlayerButton isSelected:NO];
    [self selectButton:self.thirdBotButton isSelected:NO];
    [self selectButton:self.fourthPlayerButton isSelected:NO];
    [self selectButton:self.fourthBotButton isSelected:NO];
}

#pragma mark - Actions

- (IBAction)startGame:(id)sender
{
    BotLevel level = [self selectedLevel];
    self.configurations.nbPlayer = [self computeNbPlayers:self.realPlayers];
    self.configurations.nbBot = [self computeNbPlayers:self.botPlayers];
    [[PlayerManager sharedInstance] setNumberOfPlayers:self.configurations.nbPlayer numberOfBot:self.configurations.nbBot botLevel:level];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    MapViewController *mapViewController = [mainStoryboard instantiateViewControllerWithIdentifier:MapViewControllerID];
    [mapViewController configureMapWithRows:self.nbRowStepper.value columns:self.nbColumnStepper.value];
    
    [self.rootParentViewController pushViewController:mapViewController];
}

- (IBAction)valueChanged:(UIStepper *)sender
{
    NSInteger maxValue = 0;
    NSInteger minValue = DIFFICULTY_LEVEL_MIN;
    UILabel *label;
    NSString *string;
    
    if (sender == self.nbColumnStepper)
    {
        maxValue = self.nbColumnMax;
        string = LOCALIZED_STRING(@"setup.nb_column.label");
        label = self.nbColumnLabel;
    }
    else if (sender == self.nbRowStepper)
    {
        maxValue = self.nbRowMax;
        string = LOCALIZED_STRING(@"setup.nb_row.label");
        label = self.nbRowLabel;
    }
    else if (sender == self.levelStepper)
    {
        maxValue = DIFFICULTY_LEVEL_MAX;
        string = LOCALIZED_STRING(@"setup.difficulty_player.label");
        label = self.levelLabel;
    }
    else
    {
        NSLog(@"stepper not found");
    }
    
    
    if (sender.value + 1 > maxValue)
    {
        sender.value = maxValue;
    }
    else if (sender.value <= minValue)
    {
        sender.value = minValue;
    }
    
    [self configureSteppers:nil label:label string:string value:sender.value];
}

#pragma mark - Actions

- (IBAction)selectPlayer:(UIButton *)sender
{
    if (!sender.isSelected && self.reachMaxPlayers)
        return;
    
    [self selectButton:sender isSelected:!sender.selected];
    [self isFullPlayerSelected];
}

#pragma mark - Utils

- (void)selectButton:(UIButton *)button isSelected:(BOOL)isSelected
{
    button.selected = isSelected;
    button.tintColor = button.selected ? GREEN_COLOR : [UIColor blackColor];
}

- (BOOL)isFullPlayerSelected
{
    NSInteger nbPlayers = 0;
    for (UIButton *player in self.players)
    {
        if (player.isSelected)
        {
            nbPlayers ++;
            if (nbPlayers >= NB_MAX_PLAYER)
            {
                self.reachMaxPlayers = YES;
                [self colorPlayersNotSelected:YES];
                return YES;
            }
        }
    }
    
    self.reachMaxPlayers = NO;
    [self colorPlayersNotSelected:NO];
    return NO;
}

- (void)colorPlayersNotSelected:(BOOL)shouldColor
{
    for (UIButton *player in self.players)
    {
        if (!player.isSelected)
        {
            player.tintColor = shouldColor ? GRAY_COLOR : [UIColor blackColor];
        }
        else
        {
            player.tintColor = GREEN_COLOR;
        }
    }
}

- (NSInteger)computeNbPlayers:(NSArray *)players
{
    NSInteger nbPlayer = 0;
    for (UIButton *player in players)
    {
        if (player.isSelected)
        {
            nbPlayer++;
        }
    }
    return nbPlayer;
}

- (BotLevel)selectedLevel
{
    if (self.levelStepper.value == 1)
    {
        return BotLevelEasy;
    }
    else if (self.levelStepper.value == 2)
    {
        return BotLevelMedium;
    }
    else if (self.levelStepper.value == 3)
    {
        return BotLevelDifficult;
    }
    else
    {
        return BotLevelExtreme;
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

- (void)configureSteppers:(UIStepper *)stepper label:(UILabel *)label string:(NSString *)string value:(NSInteger)value
{
    NSDictionary *steppersAttributes = @{NSFontAttributeName:ROBOTO_MEDIUM(13.0f + OFFSET_IPAD_FONT_SIZE)};
    [stepper setValue:value];
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:[@(value) stringValue]
                                                                           attributes:steppersAttributes];
    label.attributedText = [NSAttributedString attributedStringWithFormat:string, attributedString];
    [label setFont:ROBOTO_LIGHT(13.0f + OFFSET_IPAD_FONT_SIZE)];
}

@end
