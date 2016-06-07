//
//  WinnerViewController.h
//  Pipopipette
//
//  Created by Paul Lavoine on 07/06/2016.
//  Copyright © 2016 Paul Lavoine. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Player;

@interface WinnerViewController : ChildViewController

- (instancetype)initWithWinner:(Player *)player;

@end
