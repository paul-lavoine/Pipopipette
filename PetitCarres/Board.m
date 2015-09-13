//
//  Board.m
//  PetitCarres
//
//  Created by Paul Lavoine on 09/09/2015.
//  Copyright (c) 2015 Paul Lavoine. All rights reserved.
//

#import "Board.h"



@interface Board ()

@property (nonatomic, assign) NSInteger rows;
@property (nonatomic, assign) NSInteger columns;
@property (nonatomic, strong) NSMutableArray *matrix;

@end



@implementation Board

- (instancetype)initWithRows:(NSInteger)rows columns:(NSInteger)columns
{
    if (self = [super init])
    {
        _rows = rows;
        _columns = columns;
        _matrix = [NSMutableArray arrayWithCapacity:(columns * rows)];
    }
    
    return self;
}

- (Piece *)pieceAtPosition:(Point)position
{
    return self.matrix[position.h * self.columns + position.v];
}

@end
