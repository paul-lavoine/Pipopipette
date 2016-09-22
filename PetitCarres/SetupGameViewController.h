//
//  SetupGameViewController.h
//  PetitCarres
//
//  Created by Paul Lavoine on 07/12/2015.
//  Copyright © 2015 Paul Lavoine. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PlayerManager.h"

#define SetupGameViewControllerID @"SetupGameViewControllerID"

#define LEVEL_PREFERENCE    @"preferenceLevel"
#define COLUMN_PREFERENCE   @"preferenceColumn"
#define ROW_PREFERENCE      @"preferenceRow"


@interface SetupGameViewController : ChildViewController

- (instancetype)init;
+ (BotLevel)selectedLevel:(CGFloat)value;

@end
