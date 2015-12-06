//
//  BarButton.m
//  PetitCarres
//
//  Created by Paul Lavoine on 09/09/2015.
//  Copyright (c) 2015 Paul Lavoine. All rights reserved.
//

#import "BarButton.h"




@interface BarButton ()

// Outlets
@property (weak, nonatomic) IBOutlet UIView *barView;

@end




@implementation BarButton

+ (UINib *)horizontalButtonNib
{
    static UINib *cellNib;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cellNib = [UINib nibWithNibName:@"HorizontalBarButton" bundle:nil];
    });
    
    return cellNib;
}

+ (UINib *)verticaltalButtonNib
{
    static UINib *cellNib;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cellNib = [UINib nibWithNibName:@"VerticalBarButton" bundle:nil];
    });
    
    return cellNib;
}

- (instancetype)initWithFrame:(CGRect)frame position:(CGPoint)point
{
    if (self = [super initWithFrame:frame])
    {
        _hasAlreadyBeenSelected = false;
        _position = point;
        _pieceAssociated = [NSMutableArray array];
    }
    
    return self;
}

- (void)selectWithPlayer:(Player *)owner
{
    self.backgroundColor = owner.colorPlayer;
    self.owner = owner;
    _hasAlreadyBeenSelected = true;
}

@end
