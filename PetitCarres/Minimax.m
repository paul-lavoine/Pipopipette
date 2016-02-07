//
//  Minimax.m
//  PetitCarres
//
//  Created by Paul Lavoine on 18/12/2015.
//  Copyright © 2015 Paul Lavoine. All rights reserved.
//

#import "Minimax.h"
#import "Component.h"

#define DEPTH 3
#define IS_HORIZONTAL_BUTTON_KEY    @"isHorizontalButtonKey"
#define INDEX_ARRAY_ASSOCIATE_PIECE @"indexArrayAssociatePieceKey"

@interface Minimax ()

@property (nonatomic, assign) NSInteger cpt;
@property (nonatomic, assign) NSInteger bestScore;
@property (nonatomic, strong) NSArray *pieces;
@property (nonatomic, strong) NSArray *barButtons;
@property (nonatomic, strong) NSMutableArray *isHorizontalButton;
@property (nonatomic, strong) Player *playerMin;
@property (nonatomic, strong) Player *playerMax;

@end

@implementation Minimax

#pragma mark - Shared instance

+ (instancetype)sharedInstance
{
    static Minimax *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[Minimax alloc] init];
    });
    
    return sharedInstance;
}

- (BarButton *)getBestActionWithButtons:(NSArray *)buttons pieces:(NSArray *)pieces
{
    self.cpt = 0;
    self.bestScore = [pieces count];
    self.pieces = pieces;
    self.barButtons =  buttons; // Shuffle array TODO
    
    NSArray *barButtonsInteger = [self buttonsIntegerWithButtons:self.barButtons];
    NSArray *piecesInteger = [self piecesIntegerWithPieces:pieces];
    NSInteger actualScore = [self getScoreWithPlayer:self.playerMax pieces:pieces];
    NSInteger depth = DEPTH;
    NSInteger barButtonSelectedAtIndex = 0;
    NSInteger maxScore = -self.bestScore;
    [self configureHorizontalButtons:buttons pieces:pieces];
    
    for (NSInteger i = 0; i < [barButtonsInteger count] ; i++)
    {
        if ([(barButtonsInteger[i]) isEqualToNumber:@0])
        {
            NSMutableArray *buttonsCopy = [barButtonsInteger mutableCopy];
            buttonsCopy[i] = @1;
            NSInteger score = [self getScoreWithPlayer:self.playerMax pieces:pieces]; // A piece is win should replay
            if (score > actualScore)
            {
                score = [self getMaxScore:buttonsCopy pieces:piecesInteger depth:depth - 1];
            }
            else
            {
                score = [self getMinScore:buttonsCopy pieces:piecesInteger depth:depth - 1];
            }
            
            if (score > maxScore) {
                maxScore = score;
                barButtonSelectedAtIndex = i;
            }
        }
    }
    
    if ([[barButtonsInteger objectAtIndex:barButtonSelectedAtIndex] isEqualToNumber:@3])
    {
        NSLog(@"PROBLEM BUTTON EQUALS 3");
    }
    BarButton *barButtonSelected = [self.barButtons objectAtIndex:barButtonSelectedAtIndex];
    return barButtonSelected;
}

- (NSInteger)getMinScore:(NSArray *)buttons pieces:(NSArray *)pieces depth:(NSInteger)depth
{
    if ([self testFinalState:buttons depth:depth])
        return [self getScoreWithPlayer:self.playerMin pieces:pieces];
    
    NSInteger minScore = self.bestScore;
    NSInteger actualScore = [self getScoreWithPlayer:self.playerMax pieces:pieces];
    
    for (int i = 0; i < [buttons count] ; i++)
    {
        if ([(buttons[i])isEqualToNumber:@0])
        {
            NSMutableArray *buttonsCopy = [buttons mutableCopy];
            buttonsCopy[i] = @1;
            
            NSInteger score = [self getScoreWithPlayer:self.playerMin pieces:pieces];
            if (score > actualScore)
            {
                // A piece is win should replay
                score = [self getMinScore:buttonsCopy pieces:pieces depth:depth - 1];
            }
            else
            {
                score = [self getMaxScore:buttonsCopy pieces:pieces depth:depth - 1];
            }
            
            minScore = [self min:minScore childScore:score];
        }
    }
    
    return minScore;
}

- (NSInteger)getMaxScore:(NSArray *)buttons pieces:(NSArray *)pieces depth:(NSInteger)depth
{
    if ([self testFinalState:buttons depth:depth])
        return [self getScoreWithPlayer:self.playerMax pieces:pieces];
    
    NSInteger maxScore = - self.bestScore;
    NSInteger actualScore = [self getScoreWithPlayer:self.playerMax pieces:pieces];
    
    //     La méthode getActions() retourne tous les coups possibles
    for (int i = 0; i < [buttons count] ; i++)
    {
        if ([(buttons[i])isEqualToNumber:@0])
        {
            NSMutableArray *buttonsCopy = [buttons mutableCopy];
            buttonsCopy[i] = @2;
            NSInteger score = [self getScoreWithPlayer:self.playerMax pieces:pieces];
            if (score > actualScore)
            {
                // A piece is win should replay
                score = [self getMaxScore:buttonsCopy pieces:pieces depth:depth - 1];
            }
            else
            {
                score = [self getMinScore:buttonsCopy pieces:pieces depth:depth - 1];
            }
            
            maxScore = [self max:maxScore childScore:score];
        }
    }
    
    return maxScore;
}

- (NSArray *)updatePiecesArray:(NSArray *)pieces buttons:(NSArray *)buttons selectedButton:(NSInteger)selectedButton player:(Player *)player
{
    NSMutableArray *piecesUpdates = [[NSMutableArray arrayWithArray:pieces] mutableCopy];
    BOOL isHorizontalButton = [[[self.isHorizontalButton objectAtIndex:selectedButton] objectForKey:IS_HORIZONTAL_BUTTON_KEY] boolValue];
    
    if (isHorizontalButton)
    {
        NSInteger leftButton, rightButton;
        NSInteger topHorizontalButton = selectedButton - (2*self.columns +1);
        if (topHorizontalButton > 0)
        {
            leftButton = selectedButton - (self.columns + 1);
            rightButton = selectedButton - self.columns;
            
            BOOL isSelectedleftButton = ([[buttons objectAtIndex:leftButton] isEqual:@1]);
            BOOL isSelectedRightButton = ([[buttons objectAtIndex:rightButton] isEqual:@1]);
            BOOL isSelectedTopButton = ([[buttons objectAtIndex:topHorizontalButton] isEqual:@1]);
            
            if (isSelectedleftButton && isSelectedRightButton && isSelectedTopButton)
            {
                [piecesUpdates replaceObjectAtIndex:[self indexPieceWithSelectedHorizontalButtonIndex:selectedButton] withObject:[self valueWithPlayer:player]];
            }
        }
        
        NSInteger botHorizontalButton = selectedButton + (2*self.columns +1);
        if (botHorizontalButton <= [buttons count])
        {
            leftButton = selectedButton + self.columns;
            rightButton = selectedButton + self.columns + 1;
            
            BOOL isSelectedleftButton = ([[buttons objectAtIndex:leftButton] isEqual:@1]);
            BOOL isSelectedRightButton = ([[buttons objectAtIndex:rightButton] isEqual:@1]);
            BOOL isSelectedBotButton = ([[buttons objectAtIndex:botHorizontalButton] isEqual:@1]);
            
            if (isSelectedleftButton && isSelectedRightButton && isSelectedBotButton)
            {
                [piecesUpdates replaceObjectAtIndex:[self indexPieceWithSelectedVerticalButtonIndex:selectedButton] withObject:[self valueWithPlayer:player]];
            }
        }
    }
    else
    {
        
    }
    
    return piecesUpdates;
}

- (void)configureHorizontalButtons:(NSArray *)buttons pieces:(NSArray *)pieces
{
    NSInteger cpt = 0;
    NSInteger globalCpt = 0;
    
    NSInteger indexPiece = 0;
    NSInteger nbHorizontalPiece = 0;
    NSInteger nbVerticalPiece = 0;
    BOOL isHorizontalButton = true;
    
    while (cpt < [buttons count])
    {
        cpt++;
        globalCpt++;
        
        if (isHorizontalButton && cpt == self.columns)
        {
            nbHorizontalPiece ++;
            cpt = 0;
            isHorizontalButton = false;
            
            NSMutableArray *indexPieces = [NSMutableArray array];
            if (nbHorizontalPiece >= self.columns)
            {
                [indexPieces addObject:@(nbHorizontalPiece - self.columns)];
            }
            if (nbHorizontalPiece <= [pieces count])
            {
                [indexPieces addObject:@(nbHorizontalPiece)];
            }
            [self.isHorizontalButton addObject:@{
                                                 IS_HORIZONTAL_BUTTON_KEY : @YES,
                                                 INDEX_ARRAY_ASSOCIATE_PIECE : indexPieces
                                                 }];
            
        }
        else if (!isHorizontalButton && cpt == self.columns +1)
        {
            nbVerticalPiece ++;
            cpt = 0;
            isHorizontalButton = true;
            
            NSMutableArray *indexPieces = [NSMutableArray array];
            if (nbHorizontalPiece >= self.columns)
            {
                [indexPieces addObject:@(nbHorizontalPiece - self.columns)];
            }
            if (nbHorizontalPiece <= [pieces count])
            {
                [indexPieces addObject:@(nbHorizontalPiece)];
            }
            [self.isHorizontalButton addObject:@{
                                                 IS_HORIZONTAL_BUTTON_KEY : @NO,
                                                 INDEX_ARRAY_ASSOCIATE_PIECE : indexPieces
                                                 }];
        }
    }
}

- (NSInteger)getScoreWithPlayer:(Player *)player pieces:(NSArray *)pieces
{
    NSInteger score = 0;
    
    for (Piece *piece in pieces)
    {
        if (piece.owner == player)
        {
            score ++;
        }
    }
    
    return score;
}

- (BOOL)testFinalState:(NSArray *)buttons depth:(NSInteger)depth
{
    BOOL isComplete = true;
    for (NSNumber *barButton in buttons)
    {
        if (![barButton isEqualToNumber:@0])
        {
            isComplete = false;
            break;
        }
    }
    
    return (isComplete || depth == 0);
}

- (BOOL)max:(NSInteger)maxScore childScore:(NSInteger)childScore
{
    if (maxScore > childScore)
        return maxScore;
    return childScore;
}

- (BOOL)min:(NSInteger)maxScore childScore:(NSInteger)childScore
{
    if (maxScore < childScore)
        return maxScore;
    return childScore;
}

- (NSMutableArray *)piecesIntegerWithPieces:(NSArray *)pieces
{
    NSMutableArray *integerPieces = [NSMutableArray array];
    for (Piece *piece in pieces)
    {
        [integerPieces addObject:[self valuePlayerWithButton:piece]];
    }
    
    return integerPieces;
}

- (NSMutableArray *)buttonsIntegerWithButtons:(NSArray *)buttons
{
    NSMutableArray *integerButtons = [NSMutableArray array];
    for (BarButton *button in buttons)
    {
        // Todo see for refactor @button.owner
        if (button.owner)
        {
            [integerButtons addObject:@1];
        }
        else
        {
            [integerButtons addObject:@0];
        }
    }
    
    return integerButtons;
}

- (NSNumber *)valuePlayerWithButton:(Piece *)piece
{
    if (piece.hasBeenWin)
    {
        if (piece.owner == self.playerMin)
            return @1; // joueur 1 Max
        return @2; // joueur 2 Min
    }
    else
    {
        return @0; // Free button
    }
}

- (NSNumber *)valueWithPlayer:(Player *)player
{
    if (player == self.playerMin)
        return @1;
    return @2;
}

- (NSInteger)indexPieceWithSelectedHorizontalButtonIndex:(NSInteger)selectedButton
{
    NSInteger columnSelected = selectedButton/self.columns;
    return 0;
}

- (NSInteger)indexPieceWithSelectedVerticalButtonIndex:(NSInteger)selectedButton
{
    return 0;
}

@end