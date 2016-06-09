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
#define BAR_BUTTON_SPACE    4

#define VERTICAL_BAR_BUTTON_XIB     @"VerticalBarButton"
#define HORIZONTAL_BAR_BUTTON_XIB   @"HorizontalBarButton"

#define DEFAULT_COLOR_BAR_BUTTON [UIColor yellowColor];

@class BarButton;
@class Player;

@protocol CustomButtonDelegate <NSObject>

/**
 Called when button in tab bar (header section) is select
 */
- (void)setButton:(BarButton *)button;

@end

@interface BarButton : UIButton

- (instancetype)initWithFrame:(CGRect)frame type:(NSString *)type idPosition:(NSInteger)idPosition;
- (void)selectedByPlayer:(Player *)owner animate:(BOOL)animate;
- (void)setColorBackground;
- (id)copyWithZone:(NSZone *)zone;

// Outlets
@property (weak, nonatomic) IBOutlet UIView *barView;

// Delegate
@property (nonatomic, weak) id<CustomButtonDelegate> delegate;

// Data
@property (nonatomic, strong) NSMutableArray *pieceAssociated;
@property (nonatomic, assign) BOOL hasAlreadyBeenSelected;
@property (nonatomic, strong) Player *owner;
@property (nonatomic, assign) CGPoint position;
@property (nonatomic, assign) NSInteger uid;

@end
