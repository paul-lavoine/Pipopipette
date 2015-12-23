//
//  Player.h
//  PetitCarres
//
//  Created by Paul Lavoine on 09/09/2015.
//  Copyright (c) 2015 Paul Lavoine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BotLevel) {
    BotLevelEasy         = 0,
    BotLevelMedium       = 1,
    BotLevelDifficult    = 2,
    BotLevelExtreme      = 3,
};

@class BarButton;

#define DEFAULT_NAME                @"Player"
#define DEFAULT_BOT_NAME            @"Bot"
#define MIN_TIME_BEFORE_PLAYING     0.7f // 0.7

@interface Player : NSObject

- (instancetype)initWithColor:(UIColor *)color name:(NSString *)name icone:(NSString *)icone position:(NSInteger)position isABot:(BOOL)isABot botLevel:(BotLevel)botLevel;

- (BarButton *)selectBarWithHorizontalButtons:(NSArray *)horizontalButtons verticalButtons:(NSArray *)verticalButtons pieces:(NSArray *)pieces;

@property (nonatomic, strong) UIColor *colorPlayer;
@property (nonatomic, assign) NSInteger score;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) UIImage *icone;
@property (nonatomic, assign) NSInteger position;
@property (nonatomic, assign) BOOL isABot;

@end
