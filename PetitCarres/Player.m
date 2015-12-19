//
//  Player.m
//  PetitCarres
//
//  Created by Paul Lavoine on 09/09/2015.
//  Copyright (c) 2015 Paul Lavoine. All rights reserved.
//

#import "Player.h"
#import "BarButton.h"
#import "Minimax.h"

@interface Player ()

@property (nonatomic, strong) NSMutableArray *buttonsRecorded;
@property (nonatomic, strong) Minimax *minimax;
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
        _minimax = [Minimax sharedInstance];
    }
    
    return self;
}

#pragma mark - Utils

- (BarButton *)selectBarButton:(NSArray *)buttons pieces:(NSArray *)pieces
{
    BarButton *selectedBarButton;
    
    switch (self.botLevel) {
        case BotLevelEasy:
            selectedBarButton = [self takePieceIfPossible:pieces];
            selectedBarButton = selectedBarButton ? selectedBarButton : [self randomChoice:buttons];
            break;
        case BotLevelDifficult:
            selectedBarButton = [self takePieceIfPossible:pieces];
            selectedBarButton = selectedBarButton ? selectedBarButton : [self selectFreePlace:buttons];
            selectedBarButton = selectedBarButton ? selectedBarButton : [self selectTheSmallestChain:buttons actualBestScore:100000];
            break;
        case BotLevelExtreme:
            selectedBarButton = [self.minimax getBestActionWithMinimax:buttons];
            break;
        default:
        case BotLevelMedium:
            selectedBarButton = [self takePieceIfPossible:pieces];
            selectedBarButton = selectedBarButton ? selectedBarButton : [self selectFreePlace:buttons];
            selectedBarButton = selectedBarButton ? selectedBarButton : [self randomChoice:buttons];
            break;
    }
    
    return selectedBarButton ? selectedBarButton : NULL;
}

- (BarButton *)selectTheSmallestChain:(NSArray *)buttons actualBestScore:(NSInteger)actualBestScore
{
    self.buttonsRecorded = [buttons copy];
    BarButton *randomButton = [self randomChoice:self.buttonsRecorded];
    BarButton *selectedButton = nil;
    NSInteger chainPiece = 0;
    NSInteger bestMinScore = actualBestScore;
    
    for (Piece *piece in randomButton.pieceAssociated)
    {
        chainPiece += [self startChainingWithPiece:piece barButtonSelected:randomButton];
        
        if (chainPiece < bestMinScore)
        {
            bestMinScore = chainPiece;
            selectedButton = randomButton;
        }
    }
    
    NSInteger checkAllBarButtonVisited = true;
    for (BarButton *barButton in self.buttonsRecorded)
    {
        if (!barButton.hasAlreadyBeenSelected)
        {
            checkAllBarButtonVisited = false;
            break;
        }
    }
    
    if (!checkAllBarButtonVisited)
    {
        return [self selectTheSmallestChain:self.buttonsRecorded actualBestScore:bestMinScore];
    }
    
    return selectedButton;
}

- (NSInteger)startChainingWithPiece:(Piece *)piece barButtonSelected:(BarButton *)barButtonSelected
{
    for (BarButton *barButton in piece.barButtonsAssociated)
    {
        if (barButton != barButtonSelected && !barButton.hasAlreadyBeenSelected)
        {
            for (Piece *pieceAssociated in barButton.pieceAssociated)
            {
                if (pieceAssociated != piece && !piece.hasBeenWin)
                {
                    return ([self startChainingWithPiece:pieceAssociated barButtonSelected:barButton] + 1);
                }
            }
        }
        if ([self.buttonsRecorded containsObject:barButton])
        {
            [self.buttonsRecorded removeObject:barButton];
        }
    }
    
    return 0;
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
    
    NSLog(@"Info : There is no free piece ...");
    
    return nil;
}

- (BarButton *)selectFreePlace:(NSArray *)buttons
{
    for (BarButton *barButton in buttons)
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

- (BarButton *)randomChoice:(NSArray *)buttons
{
    for (BarButton *barButton in buttons)
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
