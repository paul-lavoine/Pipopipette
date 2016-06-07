//
//  WinnerViewController.m
//  Pipopipette
//
//  Created by Paul Lavoine on 07/06/2016.
//  Copyright © 2016 Paul Lavoine. All rights reserved.
//

#import "WinnerViewController.h"
#import "Player.h"

@interface WinnerViewController ()

@property (nonatomic, strong) Player *player;
@property (weak, nonatomic) IBOutlet UILabel *winnerIsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *playerIsImageView;
@property (weak, nonatomic) IBOutlet UILabel *playerIsLabel;

@end

@implementation WinnerViewController

- (instancetype)initWithWinner:(Player *)player
{
    if (self = [super init])
    {
        _player = player;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureUI];
}

- (void)configureUI
{
    self.winnerIsLabel.text = [[NSString stringWithFormat:@"le gagnant\nest"] uppercaseString];
    self.playerIsImageView.image = self.player.icone;
    self.playerIsLabel.text = [[NSString stringWithFormat:@"le joueur %@", self.player.name] uppercaseString];
}


@end
