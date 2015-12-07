//
//  GlobalConfiguration.m
//  PetitCarres
//
//  Created by Paul Lavoine on 06/12/2015.
//  Copyright © 2015 Paul Lavoine. All rights reserved.
//

#import "GlobalConfiguration.h"

@interface GlobalConfiguration ()

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

- (instancetype)init
{
    if (self = [super init])
    {
        self.currentPlayer = 0;
        self.players = [NSMutableArray array];
        [self.players addObject:[[Player alloc] initWithColor:[UIColor blueColor] name:@"Paul" icone:@"croix"]];
        [self.players addObject:[[Player alloc] initWithColor:[UIColor redColor] name:@"Cyril" icone:@"rond"]];
    }
    
    return self;
}

- (Player *)getCurrentPlayer
{
    return self.players[self.currentPlayer];
}

- (void)resetCurrentPlayer
{
    self.currentPlayer = 0;
    
    for (Player *player in self.players)
    {
        player.score = 0;
    }
}

- (Player *)getWinner
{
    Player *winner = [self.players firstObject];
    // Retrieve high score
    for (Player *player in self.players)
    {
        if (player.score > winner.score)
        {
            winner = player;
        }
    }
    
    // Check if 2 player get the same score
    int nbPlayerWithTheSameScore = 0;
    for (Player *player in self.players)
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
    self.currentPlayer = (self.currentPlayer) % [self.players count];
}

@end
