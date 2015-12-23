//
//  Component.m
//  PetitCarres
//
//  Created by Paul Lavoine on 22/12/2015.
//  Copyright © 2015 Paul Lavoine. All rights reserved.
//

#import "Component.h"

@implementation Component

+ (void)linkComponentsWithPieces:(NSArray *)pieces horizontalButtons:(NSArray *)horizontalButtons verticalButtons:(NSArray *)verticalButtons nbColumnsAvailable:(NSInteger)nbColumnsAvailable
{
    for (int i = 0; i < [pieces count] ; i++ )
    {
        Piece *piece = pieces[i];
        BarButton *button = horizontalButtons[i];
        [piece.barButtonsAssociated addObject: button];
        [button.pieceAssociated addObject:piece];
        
        button = horizontalButtons[i + nbColumnsAvailable];
        [piece.barButtonsAssociated addObject:button];
        [button.pieceAssociated addObject:piece];
        
        int ligne = i/nbColumnsAvailable;
        button = verticalButtons[i + ligne];
        [piece.barButtonsAssociated addObject:button];
        [button.pieceAssociated addObject:piece];
        
        button = verticalButtons[i+1 + ligne];
        [piece.barButtonsAssociated addObject:button];
        [button.pieceAssociated addObject:piece];
    }
}


+ (NSMutableArray *)shuffleButtonsWithHorizontalButtons:(NSArray *)horizontalButtons verticalButtons:(NSArray *)verticalButtons
{
    NSArray *barButtons = [horizontalButtons arrayByAddingObjectsFromArray:verticalButtons];
    NSMutableArray *shuffleBarButtons = [NSMutableArray arrayWithArray:barButtons];
    [shuffleBarButtons shuffle];
    
    return shuffleBarButtons;
}

@end
