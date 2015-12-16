//
//  BarButton.m
//  PetitCarres
//
//  Created by Paul Lavoine on 09/09/2015.
//  Copyright (c) 2015 Paul Lavoine. All rights reserved.
//

#import "BarButton.h"
#import "PlayerManager.h"



@interface BarButton ()

// Data
@property (weak, nonatomic) NSString *type;

// Outlets
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;

@end




@implementation BarButton

- (instancetype)initWithFrame:(CGRect)frame type:(NSString *)type
{
    if (self = [super initWithFrame:frame])
    {
        _hasAlreadyBeenSelected = false;
        _pieceAssociated = [NSMutableArray array];
        _type = type;
        [self commonInit];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionSelectButton:)]];
    }
    
    return self;
}

- (void)commonInit
{
    [[NSBundle mainBundle] loadNibNamed:self.type owner:self options:nil];
    [self addSubview:self.contentView];
}

#pragma mark - Action Button
- (IBAction)actionSelectButton:(UIButton *)sender
{
    [_delegate setButton:self];
}

- (void)selectWithPlayer:(Player *)owner
{
    self.barView.backgroundColor = DEFAULT_COLOR_BAR_BUTTON;
    self.owner = owner;
    _hasAlreadyBeenSelected = true;
    
    if ([VERTICAL_BAR_BUTTON_XIB isEqualToString:self.type])
    {
        self.widthConstraint.constant = BAR_BUTTON_SPACE;
    }
    else
    {
        self.heightConstraint.constant = BAR_BUTTON_SPACE;
    }
}

- (void)setColorBackground
{
    self.barView.backgroundColor = self.owner.colorPlayer;
}


@end
