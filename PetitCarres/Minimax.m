//
//  Minimax.m
//  PetitCarres
//
//  Created by Paul Lavoine on 18/12/2015.
//  Copyright © 2015 Paul Lavoine. All rights reserved.
//

#import "Minimax.h"

@interface Minimax ()

@property (nonatomic, strong) Player *player;
@property (nonatomic, strong) NSArray *pieces;
@property (nonatomic, assign) NSInteger bestScore;

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

- (void)configureWithMaxScore:(NSInteger)bestScore player:(Player *)player pieces:(NSArray *)pieces
{
    _player = player;
    _bestScore = bestScore;
    _pieces = pieces;
}

// Cette méthode est proche du comportement de getMaxSCore()
// sauf qu'elle retourne l'action associée au meilleur score
- (BarButton *)getBestActionWithMinimax:(NSArray *)buttons
{
    NSInteger depth = 5;
    BarButton *barButtonSelected = nil;
    NSInteger maxScore = -_bestScore;
    
    for (BarButton *barButton in buttons)
    {
        NSArray *childState = [self getChildState:buttons button:barButton];
        NSInteger score = [self getMinScore:childState depth:depth - 1];
        
        if (score > maxScore) {
            maxScore = score;
            barButtonSelected = barButton;
        }
    }
    return barButtonSelected;
}

// Cette méthode symbolise le tour de notre agent, elle
// sélectionne le score le plus élevé parmi les états
// enfants
- (NSInteger)getMaxScore:(NSArray *)buttons depth:(NSInteger)depth
{
    // testFinalState() va borner notre exploration en vérifiant la
    // fin du jeu ou une profondeur d'exploration maximum
    if ([self testFinalState:buttons depth:depth]) {
        // La fonction d'évaluation
        return [self getScore];
    }
    
    NSInteger maxScore = -_bestScore;
    
    //     La méthode getActions() retourne tous les coups possibles
    for (BarButton *barButton in buttons) {
        // La méthode getChildState() détermine l'état
        // du jeu en simulant l'action sélectionée
        NSArray *childState = [self getChildState:buttons button:barButton];
        // La récursion caractérise l'exploration en profondeur d'abord
        NSInteger childScore = [self getMinScore:childState depth:depth - 1];
        
        maxScore = [self max:maxScore childScore:childScore];
    }
    return maxScore;
}

// Cette méthode symbolise le tour de l'adversaire,
// elle sélectionne le score le moins élevé parmi
// les états enfants
- (NSInteger)getMinScore:(NSArray *)buttons depth:(NSInteger)depth
{
    if ([self testFinalState:buttons depth:depth]) {
        // La fonction d'évaluation
        return [self getScore];
    }
    
    NSInteger minScore = self.bestScore;
    
    for (BarButton *barButton in buttons) {
        NSArray *childState = [self getChildState:buttons button:barButton];
        // La récursion caractérise l'exploration en profondeur d'abord
        NSInteger childScore = [self getMaxScore:childState depth:depth - 1];
        
        minScore = [self min:minScore childScore:childScore];
    }
    return minScore;
}


- (NSMutableArray *)getChildState:(NSArray *)buttons button:(BarButton *)barButton
{
    NSMutableArray *newStateButtons = [[NSMutableArray alloc] initWithArray:buttons];
    [newStateButtons removeObject:barButton];
    return newStateButtons;
}

- (BOOL)testFinalState:(NSArray *)buttons depth:(NSInteger)depth
{
    return (([buttons count] == 0) || (depth == 0));
}

- (NSInteger)getScore
{
    NSInteger score = 0;
    for (Piece *piece in self.pieces)
    {
        if (piece.owner == self.player)
        {
            score++;
        }
    }
    return score;
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

@end
