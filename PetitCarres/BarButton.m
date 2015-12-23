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

- (instancetype)initWithFrame:(CGRect)frame type:(NSString *)type idPosition:(NSInteger)idPosition
{
    if (self = [super initWithFrame:frame])
    {
        _hasAlreadyBeenSelected = false;
        _pieceAssociated = [NSMutableArray array];
        _type = type;
        _uid = idPosition;
        [self commonInit];
        _barView.layer.cornerRadius = 4;
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

- (void)selectedByPlayer:(Player *)owner animate:(BOOL)animate
{
    self.owner = owner;
    self.hasAlreadyBeenSelected = true;
    
    if (animate)
    {
        [UIView beginAnimations:@"test" context:NULL];
        [UIView setAnimationDuration:0.2f];
        self.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        
        if ([VERTICAL_BAR_BUTTON_XIB isEqualToString:self.type])
        {
            self.widthConstraint.constant = BAR_BUTTON_SPACE;
        }
        else
        {
            self.heightConstraint.constant = BAR_BUTTON_SPACE;
        }
        
        CGFloat hue;
        CGFloat saturation;
        CGFloat brightness;
        CGFloat alpha;
        
        [owner.colorPlayer getHue:&hue
                       saturation:&saturation
                       brightness:&brightness
                            alpha:&alpha];
        
        brightness -= 0.6f;
        
        self.barView.backgroundColor = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:alpha];
    }
}

- (void)setColorBackground
{
    self.barView.backgroundColor = self.owner.colorPlayer;
}

- (id)copyWithZone:(NSZone *)zone
{
    BarButton *copy = [[BarButton allocWithZone: zone] init];
    
    [copy setHasAlreadyBeenSelected:self.hasAlreadyBeenSelected];
    [copy setOwner:self.owner];
    [copy setPosition:self.position];
    [copy setUid:self.uid];
    
    return copy;
}

@end
