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
#import "Component.h"

@interface Player ()

@property (nonatomic, strong) Minimax *minimax;
@property (nonatomic, assign) BotLevel botLevel;
@property (nonatomic, strong) BarButton *selectedBarButton;
@property (nonatomic, strong) NSMutableArray *buttonsAvailable;
@property (nonatomic, strong) NSMutableArray *piecesAvailable;

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

- (BarButton *)selectBarWithButtons:(NSArray *)buttons pieces:(NSArray *)pieces
{
    // Shuffle array
    NSMutableArray *shuffleBarButtons = [[Component class] shuffleButtonsWithHorizontalButtons:buttons];
    BarButton *selectedBarButton;
    
    switch (self.botLevel) {
        case BotLevelEasy:
            selectedBarButton = [self takePieceIfPossible:pieces];
            selectedBarButton = selectedBarButton ? selectedBarButton : [self randomChoice:shuffleBarButtons];
            break;
        case BotLevelDifficult:
            selectedBarButton = [self difficultLevel:shuffleBarButtons pieces:pieces barButton:selectedBarButton];
            break;
        case BotLevelExtreme:
            //            if ([buttons count] < 0)
            //            {
            //                selectedBarButton = [self difficultLevel:buttons pieces:pieces barButton:selectedBarButton];
            //            }
            //            else
            //            {
            selectedBarButton = [self.minimax getBestActionWithButtons:buttons pieces:pieces];
            //            }
            break;
        default:
        case BotLevelMedium:
            selectedBarButton = [self takePieceIfPossible:pieces];
            selectedBarButton = selectedBarButton ? selectedBarButton : [self selectFreePlace:shuffleBarButtons];
            selectedBarButton = selectedBarButton ? selectedBarButton : [self randomChoice:shuffleBarButtons];
            break;
    }
    
    return selectedBarButton ? selectedBarButton : NULL;
}

- (NSMutableArray *)getBarAvailable:(NSArray *)buttons
{
    NSMutableArray *barButtonsAvailable = [NSMutableArray array];
    for (BarButton *barButton in buttons)
    {
        if (!barButton.hasAlreadyBeenSelected)
        {
            [barButtonsAvailable addObject:barButton];
        }
    }
    return  barButtonsAvailable;
}

- (BarButton *)selectTheSmallestChain:(NSArray *)buttons actualBestScore:(NSInteger)actualBestScore
{
    BarButton *randomButton = [buttons firstObject];
    NSInteger chainPiece = 0;
    NSInteger bestMinScore = actualBestScore;
    
    for (Piece *piece in randomButton.pieceAssociated)
    {
        chainPiece += [self computeChainPieceWithFirstPiece:piece barButtonSelected:randomButton];
    }
    
    if (chainPiece < bestMinScore)
    {
        bestMinScore = chainPiece;
        self.selectedBarButton = randomButton;
    }
    
    if ([self.buttonsAvailable count] != 0)
    {
        return [self selectTheSmallestChain:self.buttonsAvailable actualBestScore:bestMinScore];
    }
    
    return self.selectedBarButton;
}

- (NSInteger)computeChainPieceWithFirstPiece:(Piece *)piece barButtonSelected:(BarButton *)barButtonSelected
{
    NSInteger cpt = 0;
    
    if (![self.piecesAvailable containsObject:piece])
    {
        for (BarButton *barButton in piece.barButtonsAssociated)
        {
            if (barButton != barButtonSelected && !barButton.hasAlreadyBeenSelected)
            {
                if ([self.buttonsAvailable containsObject:barButton])
                {
                    for (Piece *pieceAssociated in barButton.pieceAssociated)
                    {
                        if (pieceAssociated != piece && !piece.hasBeenWin && [[piece barButtonNeededToCompletePiece] count] <= 2 && [self.buttonsAvailable containsObject:barButton] && ![self.piecesAvailable containsObject:pieceAssociated])
                        {
                            [self.piecesAvailable addObject:pieceAssociated];
                            [self.buttonsAvailable removeObject:barButton];
                            return ([self computeChainPieceWithFirstPiece:pieceAssociated barButtonSelected:barButton] + 1);
                        }
                    }
                    [self.buttonsAvailable removeObject:barButton];
                }
                else
                {
                    cpt++;
                }
            }
            if ([self.buttonsAvailable containsObject:barButton])
            {
                [self.buttonsAvailable removeObject:barButton];
            }
        }
    }
    
    return (1 - cpt);
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
    
    //    NSLog(@"Info : There is no free place ...");
    
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
    
    //    NSLog(@"Info : There is no choice ...");
    
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

- (BarButton *)difficultLevel:(NSArray *)buttons pieces:(NSArray *)pieces barButton:(BarButton *)barButton
{
    BarButton *selectedBarButton = barButton;
    
    selectedBarButton = [self takePieceIfPossible:pieces];
    selectedBarButton = selectedBarButton ? selectedBarButton : [self selectFreePlace:buttons];
    
    // Init
    self.selectedBarButton = nil;
    self.buttonsAvailable = [self getBarAvailable:buttons];
    
    // Search the smallest chain
    selectedBarButton = selectedBarButton ? selectedBarButton : [self selectTheSmallestChain:self.buttonsAvailable actualBestScore:100000];
    
    return  selectedBarButton;
}
@end
