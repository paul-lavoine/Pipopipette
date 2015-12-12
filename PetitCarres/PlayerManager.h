//
//  PlayerManager.h
//  PetitCarres
//
//  Created by Paul Lavoine on 06/12/2015.
//  Copyright © 2015 Paul Lavoine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"

@interface PlayerManager : NSObject

+ (instancetype)sharedInstance;
- (void)setNumberOfPlayers:(NSInteger)players numberOfBot:(NSInteger)nbBot botLevel:(BotLevel)botLevel;
- (Player *)currentPlayer;
- (Player *)winner;
- (void)nextPlayer;
- (void)previousPlayer;
- (void)resetCurrentPlayer;
- (NSInteger)playersArraySize;

@property (nonatomic, strong) NSMutableArray *playersArray;

@end
