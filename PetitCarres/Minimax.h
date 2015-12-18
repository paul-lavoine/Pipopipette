//
//  Minimax.h
//  PetitCarres
//
//  Created by Paul Lavoine on 18/12/2015.
//  Copyright © 2015 Paul Lavoine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BarButton.h"

@interface Minimax : NSObject

+ (instancetype)sharedInstance;
- (void)configureWithMaxScore:(NSInteger)bestScore player:(Player *)player pieces:(NSArray *)pieces;
- (BarButton *)getBestActionWithMinimax:(NSArray *)buttons;

@end
