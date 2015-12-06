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
- (void)nextPlayer;
- (void)previousPlayer;

@end
