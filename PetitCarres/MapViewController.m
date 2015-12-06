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
    
    self.rows = 3;
    self.columns = 3;
    self.currentPlayer = 0;
    
    self.players = [NSMutableArray array];
    [self.players addObject:[[Player alloc] initWithColor:[UIColor blueColor] name:@"Paul"]];
    [self.players addObject:[[Player alloc] initWithColor:[UIColor redColor] name:@"Cyril"]];
    
    [self buildMapWithRows:self.rows columns:self.columns];
}

- (void)buildMapWithRows:(NSInteger)rows columns:(NSInteger)columns
{
    CGFloat statusBarFrameHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    NSArray *colors = @[[UIColor blueColor], [UIColor redColor], [UIColor purpleColor], [UIColor brownColor], [UIColor blackColor], [UIColor greenColor]];
    int smallSideBarButton = BAR_BUTTON_SPACE;
    int highSideBarButton = SIZE_PIECE;
    int pieceSize = SIZE_PIECE;
    int space = BAR_BUTTON_SPACE;
    int minSpaceBorder = (MIN_LARGER_TOUCH - smallSideBarButton) / 2;
    
    // Limite le nombre de case à l'espace possile dans la vue
    self.columns = [self limitNumberOfSquarre:columns highSideBarButton:highSideBarButton space:space minSpaceBorder:minSpaceBorder widthMax:self.view.frame.size.width];
    
    self.rows = [self limitNumberOfSquarre:rows highSideBarButton:highSideBarButton space:space minSpaceBorder:minSpaceBorder widthMax:(self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - statusBarFrameHeight)];

    // Offset est l'espace à gauche du plateau et à droite du plateau pour aiérer.
    int offsetWidth = (self.view.frame.size.width - (self.columns*highSideBarButton) - (space*(self.columns+1)))/2;
    int offsetHeight = ((self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - statusBarFrameHeight) - (self.rows*highSideBarButton) - (space*(self.rows+1)))/2;
    
    // Vertical bar
    self.pieces = [NSMutableArray array];
    self.horizontalButtons = [NSMutableArray array];
    self.verticalButtons = [NSMutableArray array];
    
    // Insert UI components
    for (int j = 1; j <= self.rows + 1; j++)
    {
        for (int i = 1; i <= self.columns + 1 ; i++)
        {
            // Vertical button
            BarButton *verticalButton;
            if (j <= self.rows)
            {
                verticalButton = [[BarButton alloc] initWithFrame:CGRectMake(i*pieceSize + (i*smallSideBarButton) - highSideBarButton - space + offsetWidth,
                                                                             j*pieceSize + (j*space) - highSideBarButton + offsetHeight,
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
            if (i <= self.columns)
            {
                horizontalButton = [[BarButton alloc] initWithFrame:CGRectMake(i*pieceSize + (i*smallSideBarButton) - highSideBarButton + offsetWidth,
                                                                               j*pieceSize + (j*space) - space - highSideBarButton + offsetHeight,
                                                                               highSideBarButton,
                                                                               smallSideBarButton)
                                                           position:CGPointMake(i - 1, j - 1)];
                horizontalButton.backgroundColor = colors[4];
                [horizontalButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
                [self.mapView addSubview:horizontalButton];
                [self.horizontalButtons addObject:horizontalButton];
            }
            
            if (i <= self.columns && j <= self.rows)
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
    [self linkComponents:self.columns];
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

- (void)linkComponents:(NSInteger)nbColumnsAvailable
{
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

- (NSInteger)limitNumberOfSquarre:(NSInteger)cases highSideBarButton:(NSInteger)highSideBarButton space:(NSInteger)space minSpaceBorder:(NSInteger)minSpaceBorder widthMax:(NSInteger)widthMax
{
    NSInteger nbCaseAvailable = cases;
    while (widthMax < ((nbCaseAvailable*highSideBarButton) + (space*(nbCaseAvailable+1) + 2*minSpaceBorder)))
    {
        nbCaseAvailable --;
    }
    
    return nbCaseAvailable;
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
