//
//  BarButton.h
//  PetitCarres
//
//  Created by Paul Lavoine on 09/09/2015.
//  Copyright (c) 2015 Paul Lavoine. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Piece.h"

@interface BarButton : UIButton

- (instancetype)initWithFrame:(CGRect)frame position:(CGPoint)position;

- (void)selectWithPlayer:(Player *)owner;

// Data
@property (nonatomic, strong) NSMutableArray *pieceAssociated;
@property (assign, nonatomic) CGPoint position;
@property (assign, nonatomic) bool hasAlreadyBeenSelected;
@property (nonatomic, strong) Player *owner;

@end
