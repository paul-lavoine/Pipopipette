//
//  GlobalConfiguration.m
//  PetitCarres
//
//  Created by Paul Lavoine on 06/12/2015.
//  Copyright © 2015 Paul Lavoine. All rights reserved.
//

#import "GlobalConfiguration.h"

@interface GlobalConfiguration ()

@property (nonatomic, strong) NSMutableArray *players;
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
        [self.players addObject:[[Player alloc] initWithColor:[UIColor blueColor] name:@"Paul"]];
        [self.players addObject:[[Player alloc] initWithColor:[UIColor redColor] name:@"Cyril"]];
    }
    
    return self;
}

- (Player *)getCurrentPlayer
{
    return self.players[self.currentPlayer];
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
