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
- (Player *)getCurrentPlayer;
- (Player *)getWinner;
- (void)nextPlayer;
- (void)previousPlayer;
- (void)resetCurrentPlayer;

@property (nonatomic, strong) NSMutableArray *players;

@end
