//
//  MapViewController.m
//  PetitCarres
//
//  Created by Paul Lavoine on 09/09/2015.
//  Copyright (c) 2015 Paul Lavoine. All rights reserved.
//

#import "MapViewController.h"

#import "Board.h"
#import "barButton.h"

@interface MapViewController ()

// Outlets
@property (strong, nonatomic) IBOutlet UIView *mapView;

// Data
@property (nonatomic, strong) Board *board;
@property (nonatomic, strong) NSArray *map;
@property (nonatomic, strong) NSArray *players;

@property (nonatomic, strong) NSArray *colorUsers;
@property (nonatomic, assign) NSInteger currentPlayer;

@end

@implementation MapViewController

#pragma mark - Initializers
- (instancetype)init
{
    if (self = [super init])
    {
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.currentPlayer = 0;
    
    self.map = [self buildMapWithRows:3 columns:3];
}

- (NSArray *)buildMapWithRows:(NSInteger)rows columns:(NSInteger)columns
{
    self.board = [[Board alloc] initWithRows:rows columns:columns];
    
    NSMutableArray *map;
    for (int j = 0; j < rows ; j++)
    {
        for (int i = 0; i < columns ; i++)
        {
            BarButton *button = [[BarButton alloc] initWithFrame:CGRectMake(i*20, j*20, 20, 20) piece:[[Piece alloc] init]];
            [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
            [self.mapView addSubview:button];
            [map addObject:button];
        }
    }
    
    return map;
}

- (void)buttonTapped:(BarButton *)button
{
    // Retrieve player
    Player *player = self.players[self.currentPlayer];
    
    // Change Background BarButton
    [button hasBeenSelected:player];
    
    // Set state of piece
    Piece *piece = button.piece;
    piece.owner = player;
    
    if ([self didCompleteRectWithPiece:piece])
    {
        // TODO
    }
    
    if ([self isMapComplete])
    {
        // TODO
    }

    
    self.currentPlayer = (self.currentPlayer + 1) % [self.players count];
}

- (BOOL)didCompleteRectWithPiece:(Piece *)piece
{
    return NO;
}

- (void)didSelectVerticalBar:(CGPoint)point
{
    // TODO check if button exist, arrayOutOfIndex
    BarButton *leftVerticalBarButton = self.map[(NSInteger)point.x-1][(NSInteger)point.y];
    BarButton *leftHorizontalTopBarButton = self.map[(NSInteger)point.x-1][(NSInteger)point.y-1];
    BarButton *leftHorizontalBottomBarButton = self.map[(NSInteger)point.x-1][(NSInteger)point.y+1];
    
    BarButton *rightVerticalBarButton = self.map[(NSInteger)point.x+1][(NSInteger)point.y];
    BarButton *rightHorizontalTopBarButton = self.map[(NSInteger)point.x+1][(NSInteger)point.y-1];
    BarButton *rightHorizontalBottomBarButton = self.map[(NSInteger)point.x+1][(NSInteger)point.y+1];
    
    // Check button
    if ([leftVerticalBarButton isSelected] && [leftHorizontalTopBarButton isSelected] && [leftHorizontalBottomBarButton isSelected])
    {
        // TODO Create image
        NSLog(@"gg");
    }
    
    if ([rightVerticalBarButton isSelected] && [rightHorizontalTopBarButton isSelected] && [rightHorizontalBottomBarButton isSelected])
    {
        // TODO Create image
        NSLog(@"gg");
    }
}

- (void)didSelectHorizontalBar:(CGPoint)point
{
    // TODO check if button exist, arrayOutOfIndex
    BarButton *topHorizontalBarButton = self.map[(NSInteger)point.x][(NSInteger)point.y-2];
    BarButton *topLeftVerticalTopBarButton = self.map[(NSInteger)point.x][(NSInteger)point.y-1];
    BarButton *topRightVerticalBottomBarButton = self.map[(NSInteger)point.x+1][(NSInteger)point.y-1];
    
    BarButton *bottomHorizontalBarButton = self.map[(NSInteger)point.x][(NSInteger)point.y+2];
    BarButton *bottomLeftVerticalTopBarButton = self.map[(NSInteger)point.x][(NSInteger)point.y+1];
    BarButton *bottomRightVerticalBottomBarButton = self.map[(NSInteger)point.x+1][(NSInteger)point.y+1];
    
    // Check button
    if ([topHorizontalBarButton isSelected] && [topLeftVerticalTopBarButton isSelected] && [topRightVerticalBottomBarButton isSelected])
    {
        // TODO Create image
    }
    
    if ([bottomHorizontalBarButton isSelected] && [bottomLeftVerticalTopBarButton isSelected] && [bottomRightVerticalBottomBarButton isSelected])
    {
        // TODO Create image
    }
}

- (BOOL)isMapComplete
{
    return NO;
}

#pragma mark - Utils


@end
