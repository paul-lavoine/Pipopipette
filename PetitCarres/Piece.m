//
//  Piece.m
//  PetitCarres
//
//  Created by Paul Lavoine on 09/09/2015.
//  Copyright (c) 2015 Paul Lavoine. All rights reserved.
//

#import "Piece.h"
#import "Player.h"
#import "BarButton.h"

@interface Piece ()

@property (nonatomic, strong) IBOutlet UIImageView *iconeView;

@end


@implementation Piece

- (instancetype)initWithFrame:(CGRect)frame position:(CGPoint)point uid:(NSInteger)uid
{
    if (self = [super initWithFrame:frame])
    {
        _hasBeenWin = false;
        _position = point;
        _uid = uid;
        _barButtonsAssociated = [NSMutableArray array];
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit
{
    [[NSBundle mainBundle] loadNibNamed:@"Piece" owner:self options:nil];
    [self addSubview:self.iconeView];
}

- (void)selectedByPlayer:(Player *)owner
{
    self.owner = owner;
    self.iconeView.tintColor = owner.colorPlayer;
    self.iconeView.image = owner.icone;
}

- (NSArray *)barButtonNeededToCompletePiece
{
    NSMutableArray *barButtonMissing = [NSMutableArray array];
    for (BarButton *barButton in self.barButtonsAssociated)
    {
        if (!barButton.hasAlreadyBeenSelected)
        {
            [barButtonMissing addObject:barButton];
        }
    }
    
    return barButtonMissing;
}


- (BOOL)isCompletePiece
{
    for (BarButton *button in self.barButtonsAssociated)
    {
        if (!button.hasAlreadyBeenSelected)
        {
            return false;
        }
    }
    return true;
}

- (id)copyWithZone:(NSZone *)zone
{
    Piece *copy = [[Piece allocWithZone:zone] init];
    
    [copy setHasBeenWin:self.hasBeenWin];
    [copy setOwner:self.owner];
    [copy setPosition:self.position];
    [copy setUid:self.uid];
    NSMutableArray *barButtonsCopy = [NSMutableArray array];
    for (BarButton *barButton in self.barButtonsAssociated)
    {
        [barButtonsCopy addObject:[barButton copyWithZone:(__bridge NSZone *)(barButton)]];
    }
    
    return copy;
}

@end
