//
//  Component.h
//  PetitCarres
//
//  Created by Paul Lavoine on 22/12/2015.
//  Copyright © 2015 Paul Lavoine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Piece.h"
#import "BarButton.h"
#import "NSMutableArray+Additions.h"

@interface Component : NSObject

+ (void)linkComponentsWithPieces:(NSArray *)pieces horizontalButtons:(NSArray *)horizontalButtons verticalButtons:(NSArray *)verticalButtons nbColumnsAvailable:(NSInteger)nbColumnsAvailable;
+ (NSMutableArray *)shuffleButtonsWithHorizontalButtons:(NSArray *)horizontalButtons verticalButtons:(NSArray *)verticalButtons;

@end
