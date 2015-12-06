//
//  Piece.m
//  PetitCarres
//
//  Created by Paul Lavoine on 09/09/2015.
//  Copyright (c) 2015 Paul Lavoine. All rights reserved.
//

#import "Piece.h"
#import "Player.h"

@interface Piece ()

@end


@implementation Piece

- (instancetype)initWithFrame:(CGRect)frame position:(CGPoint)point
{
    if (self = [super initWithFrame:frame])
    {
        _hasBeenWin = false;
        _position = point;
        _barButtonsAssociated = [NSMutableArray array];
    }
    
    return self;
}

- (void)selectWithPlayer:(Player *)owner
{
    self.backgroundColor = owner.colorPlayer;
    self.owner = owner;
}

@end
