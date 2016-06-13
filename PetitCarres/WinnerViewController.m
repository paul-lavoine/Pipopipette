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
@property (weak, nonatomic) IBOutlet UIImageView *logoWinnerImageView;
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
    if (_player)
    {
        [self configureWinnerUI];
    }
    else
    {
        [self configureDraw];
    }
}


- (void)configureWinnerUI
{
    self.winnerIsLabel.text = [[NSString stringWithFormat:@"le gagnant\nest"] uppercaseString];
    self.playerIsImageView.image = self.player.icone;
    
    NSMutableAttributedString *winnerPlayer = [[NSMutableAttributedString alloc] initWithString:[@"le joueur " uppercaseString] attributes:@{NSFontAttributeName : ROBOTO_LIGHT(25.0f)}];
    [winnerPlayer appendAttributedString:[[NSAttributedString alloc] initWithString:[[NSString stringWithFormat:@"%@", self.player.name] uppercaseString]
                                                                         attributes:@{NSFontAttributeName : ROBOTO_REGULAR(25.0f)}]];
    
    
    self.playerIsLabel.attributedText = winnerPlayer;
}

- (void)configureDraw
{
    self.logoWinnerImageView.hidden = YES;
    self.playerIsImageView.hidden = YES;
    self.playerIsLabel.hidden = YES;
    self.winnerIsLabel.text = [[NSString stringWithFormat:@"match nul"] uppercaseString];
}

@end
