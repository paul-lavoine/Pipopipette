//
//  Piece.m
//  PetitCarres
//
//  Created by Paul Lavoine on 09/09/2015.
//  Copyright (c) 2015 Paul Lavoine. All rights reserved.
//

#import "Piece.h"
#import "Player.h"

@interface Piece ()

@property (nonatomic, strong) IBOutlet UIImageView *iconeView;

@end


@implementation Piece

- (instancetype)initWithFrame:(CGRect)frame position:(CGPoint)point
{
    if (self = [super initWithFrame:frame])
    {
        _hasBeenWin = false;
        _position = point;
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

- (void)selectWithPlayer:(Player *)owner
{
    self.owner = owner;
    self.iconeView.tintColor = owner.colorPlayer;
    self.iconeView.image = owner.icone;
}

@end
