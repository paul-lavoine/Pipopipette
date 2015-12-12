//
//  Player.m
//  PetitCarres
//
//  Created by Paul Lavoine on 09/09/2015.
//  Copyright (c) 2015 Paul Lavoine. All rights reserved.
//

#import "Player.h"
#import "NSMutableArray+Additions.h"
#import "BarButton.h"

@interface Player ()

@property (nonatomic, assign) BotLevel botLevel;

@end


@implementation Player

- (instancetype)initWithColor:(UIColor *)color name:(NSString *)name icone:(NSString *)icone position:(NSInteger)position isABot:(BOOL)isABot botLevel:(BotLevel)botLevel
{
    if (self = [super init])
    {
        _colorPlayer = color;
        _name = name;
        _position = position;
        _isABot = isABot;
        _botLevel = botLevel;
        _icone = [UIImage imageNamed:icone];
    }
    
    return self;
}

#pragma mark - Utils

- (BarButton *)selectBarButton:(NSArray *)buttons
{
    NSMutableArray *arrayButton = [NSMutableArray arrayWithArray:buttons];
    [arrayButton shuffle];
    
    BarButton *selectedBarButton;
    
    switch (self.botLevel) {
        case BotLevelEasy:
            selectedBarButton = [self selecteButtonWithEasyLevel:arrayButton];
            break;
        case BotLevelDifficult:
            selectedBarButton = [self selecteButtonWithDifficultLevel:arrayButton];
            break;
        default:
        case BotLevelMedium:
            selectedBarButton = [self selecteButtonWithMediumLevel:arrayButton];
            break;
    }
    
    return selectedBarButton ? selectedBarButton : NULL;
}

- (BarButton *)selecteButtonWithEasyLevel:(NSArray *)arrayWithBarButton
{
    for (BarButton *barButton in arrayWithBarButton)
    {
        if (!barButton.hasAlreadyBeenSelected)
        {
            return barButton;
        }
    }
    
    NSLog(@"PROBLEM : SelectBarButton Easy level : There is no more accessible barButton");
    
    return NULL;
}

- (BarButton *)selecteButtonWithMediumLevel:(NSArray *)arrayWithBarButton
{
    for (BarButton *barButton in arrayWithBarButton)
    {
        if (!barButton.hasAlreadyBeenSelected)
        {
            return barButton;
        }
    }
    
    NSLog(@"PROBLEM : SelectBarButton Medium level : There is no more accessible barButton");
    
    return NULL;
}

- (BarButton *)selecteButtonWithDifficultLevel:(NSArray *)arrayWithBarButton
{
    for (BarButton *barButton in arrayWithBarButton)
    {
        if (!barButton.hasAlreadyBeenSelected)
        {
            return barButton;
        }
    }
    
    NSLog(@"PROBLEM : SelectBarButton Difficult level : There is no more accessible barButton");
    
    return NULL;
}

@end
