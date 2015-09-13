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

- (instancetype)initWithFrame:(CGRect)frame piece:(Piece *)piece;

- (void)hasBeenSelected:(Player *)owner;

// Data
@property (nonatomic, assign, readonly) Piece *piece;

@end
