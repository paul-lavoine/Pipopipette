//
//  GlobalConfiguration.h
//  PetitCarres
//
//  Created by Paul Lavoine on 06/12/2015.
//  Copyright © 2015 Paul Lavoine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"

@interface GlobalConfiguration : NSObject

+ (instancetype)sharedInstance;
- (void)setNumberOfPlayers:(NSInteger)players;
- (Player *)getCurrentPlayer;
- (Player *)getWinner;
- (void)nextPlayer;
- (void)previousPlayer;
- (void)resetCurrentPlayer;
- (NSInteger)playersArraySize;

@property (nonatomic, strong) NSMutableArray *playersArray;

@end
