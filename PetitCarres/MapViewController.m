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

#define MIN_LARGER_TOUCH    45
#define SIZE_PIECE          60
#define BAR_BUTTON_SPACE    5

@interface MapViewController ()

// Outlets
@property (strong, nonatomic) IBOutlet UIView *mapView;

// Data
@property (nonatomic, strong) Board *board;
@property (nonatomic, strong) NSMutableArray *horizontalButtons;
@property (nonatomic, strong) NSMutableArray *verticalButtons;
@property (nonatomic, strong) NSMutableArray *players;
@property (nonatomic, strong) NSMutableArray *pieces;

@property (nonatomic, strong) NSArray *colorUsers;
@property (nonatomic, assign) NSInteger currentPlayer;
@property (nonatomic, assign) NSInteger rows;
@property (nonatomic, assign) NSInteger columns;
@property (nonatomic, assign) NSInteger pieceSelected;

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
    
    self.rows = 9;
    self.columns = 6;
    self.currentPlayer = 0;
    
    self.players = [NSMutableArray array];
    [self.players addObject:[[Player alloc] initWithColor:[UIColor blueColor] name:@"Paul"]];
    [self.players addObject:[[Player alloc] initWithColor:[UIColor redColor] name:@"Cyril"]];
    
    [self buildMapWithRows:self.rows columns:self.columns];
}

- (void)buildMapWithRows:(NSInteger)rows columns:(NSInteger)columns
{
    NSArray *colors = @[[UIColor blueColor], [UIColor redColor], [UIColor purpleColor], [UIColor brownColor], [UIColor blackColor], [UIColor greenColor]];
    int smallSideBarButton = BAR_BUTTON_SPACE;
    int highSideBarButton = SIZE_PIECE;
    int pieceSize = SIZE_PIECE;
    int space = BAR_BUTTON_SPACE;
    int minSpaceBorder = (MIN_LARGER_TOUCH - smallSideBarButton) / 2;
    
    // Limite le nombre de case à l'espace possile dans la vue
    int nbColumnsAvailable = columns;
    while (self.view.frame.size.width < ((nbColumnsAvailable*highSideBarButton) + (space*(nbColumnsAvailable+1) + 2*minSpaceBorder)))
    {
        nbColumnsAvailable --;
    }
    self.columns = nbColumnsAvailable;
    
    int nbRowsAvailable = rows;
    while ( (self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height) < ((nbRowsAvailable*highSideBarButton) + (space*(nbRowsAvailable+1) + 2*minSpaceBorder)))
    {
        nbRowsAvailable --;
    }
    self.rows = nbRowsAvailable;
    
    // Offset est l'espace à gauche du plateau et à droite du plateau pour aiérer.
    int offset = (self.view.frame.size.width - (nbColumnsAvailable*highSideBarButton) - (space*(nbColumnsAvailable+1)))/2;
    
    // Vertical bar
    self.pieces = [NSMutableArray array];
    self.horizontalButtons = [NSMutableArray array];
    self.verticalButtons = [NSMutableArray array];
    
    // Insert UI components
    for (int j = 1; j <= nbRowsAvailable + 1; j++)
    {
        for (int i = 1; i <= nbColumnsAvailable + 1 ; i++)
        {
            // Vertical button
            BarButton *verticalButton;
            if (j <= nbRowsAvailable)
            {
                verticalButton = [[BarButton alloc] initWithFrame:CGRectMake(i*pieceSize + (i*smallSideBarButton) - highSideBarButton - space + offset,
                                                                             j*pieceSize + (j*space) - highSideBarButton + offset,
                                                                             smallSideBarButton,
                                                                             highSideBarButton)
                                                         position:CGPointMake(i - 1, j - 1)];
                verticalButton.backgroundColor = colors[4];
                [verticalButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
                [self.mapView addSubview:verticalButton];
                [self.verticalButtons addObject:verticalButton];
            }
            
            // Horizontal button
            BarButton *horizontalButton;
            if (i <= nbColumnsAvailable)
            {
                horizontalButton = [[BarButton alloc] initWithFrame:CGRectMake(i*pieceSize + (i*smallSideBarButton) - highSideBarButton + offset,
                                                                               j*pieceSize + (j*space) - space - highSideBarButton + offset,
                                                                               highSideBarButton,
                                                                               smallSideBarButton)
                                                           position:CGPointMake(i - 1, j - 1)];
                horizontalButton.backgroundColor = colors[4];
                [horizontalButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
                [self.mapView addSubview:horizontalButton];
                [self.horizontalButtons addObject:horizontalButton];
            }
            
            if (i <= nbColumnsAvailable && j <= nbRowsAvailable)
            {
                // Piece
                int sizePiece = 10;
                Piece *piece = [[Piece alloc] initWithFrame:CGRectMake(verticalButton.frame.origin.x + space + (highSideBarButton/2) - (sizePiece/2),
                                                                       verticalButton.frame.origin.y + (highSideBarButton/2) - (sizePiece/2),
                                                                       sizePiece,
                                                                       sizePiece)
                                                   position:CGPointMake(i - 1, j - 1)];
                piece.backgroundColor = colors[3];
                [self.mapView addSubview:piece];
                [self.pieces addObject:piece];
            }
        }
    }
    
    // Associate buttons to correct piece and vice versa
    for (int i = 0; i < [self.pieces count] ; i++ )
    {
        Piece *piece = self.pieces[i];
        BarButton *button = self.horizontalButtons[i];
        [piece.barButtonsAssociated addObject: button];
        [button.pieceAssociated addObject:piece];
        
        button = self.horizontalButtons[i + nbColumnsAvailable];
        [piece.barButtonsAssociated addObject:button];
        [button.pieceAssociated addObject:piece];
        
        int ligne = i/nbColumnsAvailable;
        button = self.verticalButtons[i + ligne];
        [piece.barButtonsAssociated addObject:button];
        [button.pieceAssociated addObject:piece];
        
        button = self.verticalButtons[i+1 + ligne];
        [piece.barButtonsAssociated addObject:button];
        [button.pieceAssociated addObject:piece];
    }
}

- (void)buttonTapped:(BarButton *)button
{
    // Retrieve player
    Player *player = self.players[self.currentPlayer];
    
    // Change Background BarButton
    if (!button.hasAlreadyBeenSelected) {
        
        [button selectWithPlayer:player];
        
        self.currentPlayer ++;
        self.currentPlayer = (self.currentPlayer) % [self.players count];
        
        // Check if piece is complete
        for (Piece *piece in button.pieceAssociated)
        {
            if ([self didCompletePiece:piece])
            {
                [piece selectWithPlayer:player];
                self.pieceSelected ++;
            }
        }
        
        if ([self isMapComplete])
        {
            NSLog(@"GG");
        }
    }
}

- (BOOL)didCompletePiece:(Piece *)piece
{
    for (BarButton *button in piece.barButtonsAssociated)
    {
        if (!button.hasAlreadyBeenSelected)
        {
            return false;
        }
    }
    return true;
}

- (BOOL)isMapComplete
{
    return (self.pieceSelected == (self.rows * self.columns));
}

#pragma mark - Utils


@end
