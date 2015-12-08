//
//  GlobalConfiguration.m
//  PetitCarres
//
//  Created by Paul Lavoine on 06/12/2015.
//  Copyright © 2015 Paul Lavoine. All rights reserved.
//

#import "GlobalConfiguration.h"
#import "Player.h"

@interface GlobalConfiguration ()

@property (nonatomic, strong) NSArray *iconesArray;
@property (nonatomic, strong) NSArray *colorsArray;
@property (nonatomic, assign) NSInteger currentPlayer;


@end

@implementation GlobalConfiguration

#pragma mark - Shared instance

+ (instancetype)sharedInstance
{
    static GlobalConfiguration *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[GlobalConfiguration alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark - Initializers

- (void)setNumberOfPlayers:(NSInteger)players
{
    _currentPlayer = 0;
    [self startDefaultGameWithPlayers:players];
}

- (void)startDefaultGameWithPlayers:(NSInteger)nbPlayers
{
    [self initDefaultData];
    [self initDefaultPlayers:nbPlayers];
}

- (void)initDefaultData
{
    self.iconesArray =  @[ @"croix", @"rond", @"squarre", @"triangle" ];
    self.colorsArray = @[[UIColor redColor], [UIColor blueColor], [UIColor greenColor], [UIColor purpleColor]];
}

- (void)initDefaultPlayers:(NSInteger)nbPlayers
{
    self.playersArray = [NSMutableArray array];
    for (int i = 0; i < nbPlayers; i++)
    {
        [self.playersArray addObject:[[Player alloc] initWithColor:self.colorsArray[i] name:[NSString stringWithFormat:@"%@", self.iconesArray[i]] icone:self.iconesArray[i] position:i]];
    }
}

#pragma mark - Utils

- (NSInteger)playersArraySize
{
    return [self.playersArray count];
}

- (Player *)getCurrentPlayer
{
    return self.playersArray[self.currentPlayer];
}

- (void)resetCurrentPlayer
{
    self.currentPlayer = 0;
    
    for (Player *player in self.playersArray)
    {
        player.score = 0;
    }
}

- (Player *)getWinner
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
    self.currentPlayer ++;
    [self changeCurrentPlayer];
}

- (void)previousPlayer
{
    self.currentPlayer --;
    [self changeCurrentPlayer];
}

- (void)changeCurrentPlayer
{
    self.currentPlayer = (self.currentPlayer) % [self.playersArray count];
}

@end
