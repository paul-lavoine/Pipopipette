//
//  Piece.h
//  PetitCarres
//
//  Created by Paul Lavoine on 09/09/2015.
//  Copyright (c) 2015 Paul Lavoine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"

#define SIZE_PIECE          60

@class Player;

@interface Piece : UIView

- (instancetype)initWithFrame:(CGRect)frame position:(CGPoint)point uid:(NSInteger)uid;
- (void)selectedByPlayer:(Player *)owner;
- (NSArray *)barButtonNeededToCompletePiece;
- (BOOL)isCompletePiece;
- (id)copyWithZone:(NSZone *)zone;

@property (nonatomic, strong) NSMutableArray *barButtonsAssociated;
@property (nonatomic, assign) CGPoint position;
@property (nonatomic, assign) bool hasBeenWin;
@property (nonatomic, strong) Player *owner;
@property (nonatomic, assign) NSInteger uid;

@end
