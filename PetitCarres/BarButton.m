//
//  BarButton.m
//  PetitCarres
//
//  Created by Paul Lavoine on 09/09/2015.
//  Copyright (c) 2015 Paul Lavoine. All rights reserved.
//

#import "BarButton.h"
#import "GlobalConfiguration.h"



@interface BarButton ()

// Outlets
@property (weak, nonatomic) IBOutlet UIView *contentView;


@end




@implementation BarButton

- (instancetype)initWithFrame:(CGRect)frame type:(NSString *)type
{
    if (self = [super initWithFrame:frame])
    {
        _hasAlreadyBeenSelected = false;
        _pieceAssociated = [NSMutableArray array];
        [self commonInit:type];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionSelectButton:)]];
    }
    
    return self;
}

- (void)commonInit:(NSString *)type
{
    [[NSBundle mainBundle] loadNibNamed:type owner:self options:nil];
    [self addSubview:self.contentView];
}

#pragma mark - Action Button
- (IBAction)actionSelectButton:(UIButton *)sender
{
    [_delegate setButton:self];
}

- (void)selectWithPlayer:(Player *)owner
{
    self.barView.backgroundColor = owner.colorPlayer;
    self.owner = owner;
    _hasAlreadyBeenSelected = true;
}



@end
