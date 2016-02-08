//
//  TutorielViewController.m
//  PetitCarres
//
//  Created by Paul Lavoine on 08/02/2016.
//  Copyright © 2016 Paul Lavoine. All rights reserved.
//

#import "TutorielViewController.h"

@interface TutorielViewController ()

@property (weak, nonatomic) IBOutlet UIView *backButton;

@property (weak, nonatomic) IBOutlet UILabel *introLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstRule;
@property (weak, nonatomic) IBOutlet UILabel *secondRule;
@property (weak, nonatomic) IBOutlet UILabel *thirdRule;
@property (weak, nonatomic) IBOutlet UILabel *titleNoteLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstQuoteLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondQuoteLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdQuoteLabel;

@end

@implementation TutorielViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureUI];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self.backButton addGestureRecognizer:tapRecognizer];
}

- (void)configureUI
{
    self.introLabel.text = @"La pipopipette est un jeu de société qui se joue de 1 à 4 joueurs. ";
    self.firstQuoteLabel.text = @"1.";
    self.secondQuoteLabel.text = @"2.";
    self.thirdQuoteLabel.text = @"3.";
    self.firstRule.text = @"A tour de rôle, chaque joueur sélectionne un coté de l'une des cases du carré. ";
    self.secondRule.text = @"Le joueur qui selectionne le dernier côté d’une des cases ferme cette case et compte 1 pont. Il rejoue.";
    self.thirdRule.text = @"Le gagnant est celui qui a fermé le plus grand nombre de cases.";
    self.titleNoteLabel.text = @"Remarque";
    self.noteLabel.text = @"Il arrive qu'un joueur ferme deux carrés avec un seul trait. Dans ce cas, son symbole est inscrit sur les deux carrés.";
    
}

#pragma mark - Actions
- (IBAction)tapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
