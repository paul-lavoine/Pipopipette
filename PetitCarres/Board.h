//
//  Board.h
//  PetitCarres
//
//  Created by Paul Lavoine on 09/09/2015.
//  Copyright (c) 2015 Paul Lavoine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Piece.h"



@interface Board : NSObject

- (instancetype)initWithRows:(NSInteger)rows columns:(NSInteger)columns;

- (Piece *)pieceAtPosition:(Point)position;

@end
