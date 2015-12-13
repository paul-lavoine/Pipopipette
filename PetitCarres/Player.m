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

- (BarButton *)selectBarButton:(NSArray *)buttons pieces:(NSArray *)pieces
{
    NSMutableArray *arrayShuffleButton = [NSMutableArray arrayWithArray:buttons];
    [arrayShuffleButton shuffle];
    
    BarButton *selectedBarButton;
    
    switch (self.botLevel) {
        case BotLevelEasy:
            selectedBarButton = [self takePieceIfPossible:pieces];
            selectedBarButton = selectedBarButton ? selectedBarButton : [self randomChoice:arrayShuffleButton];
            break;
        case BotLevelDifficult:
            selectedBarButton = [self takePieceIfPossible:pieces];
            selectedBarButton = selectedBarButton ? selectedBarButton : [self selecteButtonWithMediumLevel:arrayShuffleButton];
            selectedBarButton = selectedBarButton ? selectedBarButton : [self selectTheSmallestChain:arrayShuffleButton];
            break;
        case BotLevelHardCore:
            NSLog(@"TODO, not implemented");
            break;
        default:
        case BotLevelMedium:
            selectedBarButton = [self takePieceIfPossible:pieces];
            selectedBarButton = selectedBarButton ? selectedBarButton : [self selecteButtonWithMediumLevel:arrayShuffleButton];
            selectedBarButton = selectedBarButton ? selectedBarButton : [self randomChoice:arrayShuffleButton];
            break;
    }
    
    return selectedBarButton ? selectedBarButton : NULL;
}

- (BarButton *)selectTheSmallestChain:(NSArray *)arrayWithBarButton
{
    // TODO not implemented
    
    // TMP
    return [self randomChoice:arrayWithBarButton];
}

- (BarButton *)takePieceIfPossible:(NSArray *)pieces
{
    for (Piece *piece in pieces)
    {
        NSArray *barButtonMissing = [piece barButtonNeededToCompletePiece];
        if ([barButtonMissing count] == 1)
        {
            return [barButtonMissing firstObject];
        }
    }
    
    return nil;
}

- (BarButton *)selecteButtonWithMediumLevel:(NSArray *)arrayWithBarButton
{
    for (BarButton *barButton in arrayWithBarButton)
    {
        if (!barButton.hasAlreadyBeenSelected)
        {
            BOOL eachPieceGetThreeBarButton = true;
            for (Piece *piece in barButton.pieceAssociated)
            {
                NSArray *barButtonMissing = [piece barButtonNeededToCompletePiece];
                if ([barButtonMissing count] <= 2)
                {
                    eachPieceGetThreeBarButton = false;
                }
            }
            if (eachPieceGetThreeBarButton)
            {
                return barButton;
            }
        }
    }
    
    NSLog(@"Info Hard : There is no choice ...");
    
    return nil;
}

- (BarButton *)randomChoice:(NSArray *)arrayWithBarButton
{
    for (BarButton *barButton in arrayWithBarButton)
    {
        if (!barButton.hasAlreadyBeenSelected)
        {
            return barButton;
        }
    }
    
    NSLog(@"PROBLEM : SelectBarButton Easy level : There is no more accessible barButton");
    
    return nil;
}

@end
