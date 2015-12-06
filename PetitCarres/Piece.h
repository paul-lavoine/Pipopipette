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

@interface Piece : UIView

- (instancetype)initWithFrame:(CGRect)frame position:(CGPoint)point;
- (void)selectWithPlayer:(Player *)owner;


@property (nonatomic, strong) NSMutableArray *barButtonsAssociated;
@property (nonatomic, assign, readonly) CGPoint position;
@property (nonatomic, assign, readonly) bool hasBeenWin;
@property (nonatomic, strong) Player *owner;

@end
