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
- (BarButton *)getBestActionWithHorizontalButtons:(NSArray *)horizontalButtons verticalButtons:(NSArray *)verticalButtons pieces:(NSArray *)pieces player:(Player *)player;

@property (nonatomic, assign) NSInteger columns;

@end
