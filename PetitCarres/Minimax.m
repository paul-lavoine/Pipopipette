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

@interface Minimax ()

@property (nonatomic, assign) NSInteger cpt;
@property (nonatomic, assign) NSInteger bestScore;
@property (nonatomic, strong) NSArray *pieces;
@property (nonatomic, strong) NSArray *barButtons;

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

- (BarButton *)getBestActionWithHorizontalButtons:(NSArray *)horizontalButtons verticalButtons:(NSArray *)verticalButtons pieces:(NSArray *)pieces player:(Player *)player
{
    self.cpt = 0;
    NSInteger actualScore = player.score;
    self.bestScore = [pieces count];
    self.pieces = pieces;
    self.barButtons =  [horizontalButtons arrayByAddingObjectsFromArray:verticalButtons]; // Shuffle array TODO
    NSArray *barButtonsInteger = [self buttonsIntegerWithButtons:self.barButtons player:player];
    
    NSInteger depth = DEPTH;
    NSInteger barButtonSelectedAtIndex = 3;
    NSInteger maxScore = -self.bestScore;
    
    for (NSInteger i = 0; i < [barButtonsInteger count] ; i++)
    {
        if ([(barButtonsInteger[i]) isEqualToNumber:@0])
        {
            NSMutableArray *buttonsCopy = [barButtonsInteger mutableCopy];
            buttonsCopy[i] = @1;
            NSInteger score = [self getScoreWithPlayer:barButtonsInteger]; // A piece is win should replay
            if (score > actualScore)
            {
                actualScore = score;
                score = [self getMaxScore:buttonsCopy player:player actualScore:score depth:depth - 1];
            }
            else
            {
                score = [self getMinScore:buttonsCopy player:player actualScore:score depth:depth - 1];
            }
            
            if (score > maxScore && score != 0) {
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

- (NSInteger)getMinScore:(NSArray *)buttons player:(Player *)player actualScore:(NSInteger)actualScore depth:(NSInteger)depth
{
    if ([self testFinalState:buttons depth:depth])
        return [self getScoreWithPlayer:buttons];
    
    NSInteger minScore = self.bestScore;
    
    for (int i = 0; i < [buttons count] ; i++)
    {
        if ([(buttons[i])isEqualToNumber:@0])
        {
            NSMutableArray *buttonsCopy = [buttons mutableCopy];
            buttonsCopy[i] = @1;
            
            NSInteger score = [self getScoreWithPlayer:buttons];
            if (score > actualScore)
            {
                // A piece is win should replay
                actualScore = score;
                score = [self getMinScore:buttonsCopy player:player actualScore:score depth:depth - 1];
            }
            else
            {
                score = [self getMaxScore:buttonsCopy player:player actualScore:score depth:depth - 1];
            }
            
            minScore = [self min:minScore childScore:score];
        }
    }

    return minScore;
}

- (NSInteger)getMaxScore:(NSArray *)buttons player:(Player *)player actualScore:(NSInteger)actualScore depth:(NSInteger)depth
{
    if ([self testFinalState:buttons depth:depth])
        return [self getScoreWithPlayer:buttons];
    
    NSInteger maxScore = - self.bestScore;
    
    //     La méthode getActions() retourne tous les coups possibles
    for (int i = 0; i < [buttons count] ; i++)
    {
        if ([(buttons[i])isEqualToNumber:@0])
        {
            NSMutableArray *buttonsCopy = [buttons mutableCopy];
            buttonsCopy[i] = @2;
            NSInteger score = [self getScoreWithPlayer:buttons];
            if (score > actualScore)
            {
                // A piece is win should replay
                actualScore = score;
                score = [self getMaxScore:buttonsCopy player:player actualScore:score depth:depth - 1];
            }
            else
            {
                score = [self getMinScore:buttonsCopy player:player actualScore:score depth:depth - 1];
            }
            
            maxScore = [self max:maxScore childScore:score];
        }
    }
    
    return maxScore;
}

- (NSMutableArray *)getCopyPieces:(NSArray *)pieces
{
    NSMutableArray *piecesCopy = [NSMutableArray array];
    for (Piece *piece in pieces)
    {
        [piecesCopy addObject:[piece copyWithZone:(__bridge NSZone *)(piece)]];
    }
    
    return piecesCopy;
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

- (NSInteger)getScoreWithPlayer:(NSArray *)buttons
{
    NSInteger score = 0;
    for (Piece *piece in self.pieces)
    {
        if ([self isPieceComplete:piece.barButtonsAssociated buttons:buttons])
        {
            score ++;
        }
    }

    return score;
}

- (BOOL)isPieceComplete:(NSArray *)barButtonsAssociated buttons:(NSArray *)buttons
{
    for (BarButton *barButton in barButtonsAssociated)
    {
        NSInteger indexButton = [self.barButtons indexOfObject:barButton];

        if ([[buttons objectAtIndex:indexButton] isEqualToNumber:@0])
        {
            return false;
        }
    }
    
//    for (BarButton *barButton in barButtonsAssociated)
//    {
//        NSLog(@"Button : %.0f - %.0f", barButton.position.x, barButton.position.y);
//    }
//    
//    NSLog(@"\n");
    return true;
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

- (NSMutableArray *)buttonsIntegerWithButtons:(NSArray *)buttons player:(Player *)player
{
    NSMutableArray *integerButtons = [NSMutableArray array];
    for (BarButton *button in buttons)
    {
        [integerButtons addObject:[self valuePlayerWithButton:button player:player]];
    }
    
    return integerButtons;
}

- (NSNumber *)valuePlayerWithButton:(BarButton *)button player:(Player *)player
{
    if (button.hasAlreadyBeenSelected)
    {
        if (button.owner == player)
            return @1; // joueur 1 Max
        return @2; // joueur 2 Min
    }
    else
    {
        return @0;
    }
}

- (void)displaySelectedButton:(NSMutableArray *)buttons
{
    for (BarButton *button in buttons)
    {
        if (button.hasAlreadyBeenSelected)
        {
            NSLog(@"Button : %.0f - %.0f", button.position.x, button.position.y);
        }
    }
    
    NSLog(@"End display\n");
}

@end
