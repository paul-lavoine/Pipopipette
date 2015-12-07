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

    self.nbPlayer = 0;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    
    return 7;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%ld",(long)row + 1];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
}

#pragma mark - Actions
- (IBAction)startGame:(id)sender {
    [[GlobalConfiguration sharedInstance] setNumberOfPlayers:self.nbPlayer];

    MapViewController *mapViewController = [self.storyboard instantiateViewControllerWithIdentifier:MapViewControllerID];
    [mapViewController configureMapWithRows:([self.rowPicker selectedRowInComponent:0] + 1) columns:([self.columnPicker selectedRowInComponent:0] + 1)];
    
    [self.navigationController pushViewController:mapViewController animated:YES];
}

- (IBAction)valueChanged:(UIStepper *)sender {
    self.nbPlayer = [sender value];
    
    [self.nbPlayerLabel setText:[NSString stringWithFormat:@"Nombre de joueur : %ld", (long)self.nbPlayer]];
}

@end
