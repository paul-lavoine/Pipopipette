//
//  GlobalConfigurations.h
//  PetitCarres
//
//  Created by Paul Lavoine on 07/02/2016.
//  Copyright © 2016 Paul Lavoine. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NB_MAX_PLAYER 4
#define NB_MIN_PLAYER 1
#define NB_MIN_BOT 0

#define DIFFICULTY_LEVEL_MAX 3
#define DIFFICULTY_LEVEL_MIN 1

#define NB_DEFAULT_PLAYER   1
#define NB_DEFAULT_BOT      1
#define NB_DEFAULT_ROWS     4
#define NB_DEFAULT_COLUMNS  3

#define FAST_LAUNCH_SHORTCUT_KEY    @"fastLaunch"
#define RULES_SHORTCUT_KEY          @"rules"
#define SETTINGS_SHORTCUT_KEY       @"settings"
#define CREDITS_SHORTCUT_KEY        @"credits"

@interface GlobalConfigurations : NSObject

+ (instancetype)sharedInstance;

@property (assign, nonatomic) NSInteger nbPlayer;
@property (assign, nonatomic) NSInteger nbBot;
@property (assign, nonatomic) NSInteger botLevel;
@property (strong, nonatomic) NSString *fastGame;

@end
