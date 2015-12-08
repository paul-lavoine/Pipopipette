//
//  StartViewController.m
//  PetitCarres
//
//  Created by Paul Lavoine on 07/12/2015.
//  Copyright © 2015 Paul Lavoine. All rights reserved.
//

#import "StartViewController.h"
#import "MapViewController.h"
#import "GlobalConfiguration.h"
#import "BarButton.h"

#define NUMBER_PLAYER_LABEL @"Nombre de joueur :"
#define NB_MAX_PLAYER 4
#define NB_MIN_PLAYER 1
#define NB_DEFAULT_PLAYER 2

@interface StartViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

// Outlets
@property (weak, nonatomic) IBOutlet UILabel *nbPlayerLabel;
@property (weak, nonatomic) IBOutlet UIStepper *incrementStepper;
@property (weak, nonatomic) IBOutlet UIButton *startGameButton;
@property (weak, nonatomic) IBOutlet UIPickerView *columnPicker;
@property (weak, nonatomic) IBOutlet UIPickerView *rowPicker;



// Data
@property (assign, nonatomic) NSInteger nbPlayer;

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

- (void)configureDefaultMenu
{
    self.nbPlayer = NB_DEFAULT_PLAYER;
    [self.nbPlayerLabel setText:[NSString stringWithFormat:@"%@ %d",NUMBER_PLAYER_LABEL, NB_DEFAULT_PLAYER]];
    [self.incrementStepper setValue:NB_DEFAULT_PLAYER];
    
    [self.columnPicker selectRow:2 inComponent:0 animated:NO];
    [self.rowPicker selectRow:2 inComponent:0 animated:NO];
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

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
}

#pragma mark - Actions

- (IBAction)startGame:(id)sender
{
    [[GlobalConfiguration sharedInstance] setNumberOfPlayers:self.nbPlayer];
    
    MapViewController *mapViewController = [self.storyboard instantiateViewControllerWithIdentifier:MapViewControllerID];
    [mapViewController configureMapWithRows:([self.rowPicker selectedRowInComponent:0] + 1) columns:([self.columnPicker selectedRowInComponent:0] + 1)];
    
    [self.navigationController pushViewController:mapViewController animated:YES];
}

- (IBAction)valueChanged:(UIStepper *)sender
{
    if ([sender value] > NB_MAX_PLAYER)
    {
        sender.value = NB_MAX_PLAYER;
    }
    else if ([sender value] < NB_MIN_PLAYER)
    {
        sender.value = NB_MIN_PLAYER;
    }
    
    self.nbPlayer = [sender value];
    [self.nbPlayerLabel setText:[NSString stringWithFormat:@"%@ %ld",NUMBER_PLAYER_LABEL, (long)self.nbPlayer]];
}

#pragma mark - Utils

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
