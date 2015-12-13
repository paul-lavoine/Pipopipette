//
//  BarButton.h
//  PetitCarres
//
//  Created by Paul Lavoine on 09/09/2015.
//  Copyright (c) 2015 Paul Lavoine. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Piece.h"

#define MIN_LARGER_TOUCH    35
#define BAR_BUTTON_SPACE    7

#define VERTICAL_BAR_BUTTON_XIB     @"VerticalBarButton"
#define HORIZONTAL_BAR_BUTTON_XIB   @"HorizontalBarButton"

@class BarButton;
@class Player;

@protocol CustomButtonDelegate <NSObject>

/**
 Called when button in tab bar (header section) is select
 */
- (void)setButton:(BarButton *)button;

@end

@interface BarButton : UIButton

- (instancetype)initWithFrame:(CGRect)frame type:(NSString *)type;
- (void)selectWithPlayer:(Player *)owner;


// Outlets
@property (weak, nonatomic) IBOutlet UIView *barView;

// Delegate
@property (nonatomic, weak) id<CustomButtonDelegate> delegate;

// Data
@property (nonatomic, strong) NSMutableArray *pieceAssociated;
@property (nonatomic, assign) BOOL hasAlreadyBeenSelected;
@property (nonatomic, strong) Player *owner;

@end
