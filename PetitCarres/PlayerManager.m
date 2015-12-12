//
//  PlayerManager.m
//  PetitCarres
//
//  Created by Paul Lavoine on 06/12/2015.
//  Copyright © 2015 Paul Lavoine. All rights reserved.
//

#import "PlayerManager.h"
#import "Player.h"

@interface PlayerManager ()

@property (nonatomic, strong) NSArray *iconesArray;
@property (nonatomic, strong) NSArray *colorsArray;
@property (nonatomic, assign) NSInteger positionCurrentPlayer;


@end

@implementation PlayerManager

#pragma mark - Shared instance

+ (instancetype)sharedInstance
{
    static PlayerManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PlayerManager alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark - Initializers

- (void)setNumberOfPlayers:(NSInteger)players numberOfBot:(NSInteger)nbBot botLevel:(BotLevel)botLevel
{
    self.positionCurrentPlayer = 0;
    [self initDefaultData];
    [self initDefaultPlayers:players numberOfBot:nbBot botLevel:botLevel];
}

- (void)initDefaultData
{
    self.iconesArray =  @[ @"croix", @"rond", @"squarre", @"triangle" ];
    self.colorsArray = @[[UIColor redColor], [UIColor blueColor], [UIColor greenColor], [UIColor purpleColor]];
}

- (void)initDefaultPlayers:(NSInteger)nbPlayers numberOfBot:(NSInteger)nbBot botLevel:(BotLevel)botLevel
{
    NSInteger j = 0;
    
    self.playersArray = [NSMutableArray array];
    for (int i = 0; i < nbPlayers; i++)
    {
        j++;
        [self.playersArray addObject:[[Player alloc] initWithColor:self.colorsArray[i] name:[NSString stringWithFormat:@"%@", self.iconesArray[i]] icone:self.iconesArray[i] position:i isABot:NO botLevel:botLevel]];
    }
    
    for (int i = 0; i < nbBot; i++)
    {
        [self.playersArray addObject:[[Player alloc] initWithColor:self.colorsArray[i+j] name:[NSString stringWithFormat:@"%@%d",DEFAULT_BOT_NAME, i] icone:self.iconesArray[i+j] position:(i+j) isABot:YES botLevel:botLevel]];
    }
}

#pragma mark - Utils

- (NSInteger)playersArraySize
{
    return [self.playersArray count];
}

- (Player *)currentPlayer
{
    return self.playersArray[self.positionCurrentPlayer];
}

- (void)resetCurrentPlayer
{
    self.positionCurrentPlayer = 0;
    
    for (Player *player in self.playersArray)
    {
        player.score = 0;
    }
}

- (Player *)winner
{
    Player *winner = [self.playersArray firstObject];
    // Retrieve high score
    for (Player *player in self.playersArray)
    {
        if (player.score > winner.score)
        {
            winner = player;
        }
    }
    
    // Check if 2 player get the same score
    int nbPlayerWithTheSameScore = 0;
    for (Player *player in self.playersArray)
    {
        if (winner.score == player.score)
        {
            nbPlayerWithTheSameScore++;
            if (nbPlayerWithTheSameScore >=2)
            {
                return nil;
            }
        }
    }
    
    return winner;
}

- (void)nextPlayer
{
    self.positionCurrentPlayer ++;
    [self changeCurrentPlayer];
}

- (void)previousPlayer
{
    self.positionCurrentPlayer --;
    [self changeCurrentPlayer];
}

- (void)changeCurrentPlayer
{
    self.positionCurrentPlayer = (self.positionCurrentPlayer) % [self.playersArray count];
}

@end
