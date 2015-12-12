//
//  MapViewController.m
//  PetitCarres
//
//  Created by Paul Lavoine on 09/09/2015.
//  Copyright (c) 2015 Paul Lavoine. All rights reserved.
//

#import "MapViewController.h"

#import "Board.h"
#import "BarButton.h"
#import "PlayerManager.h"


@interface MapViewController () <CustomButtonDelegate>

// Outlets
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIView *mapView;
@property (weak, nonatomic) IBOutlet UIView *winnerView;
@property (weak, nonatomic) IBOutlet UILabel *winnerLabel;

@property (weak, nonatomic) IBOutlet UILabel *scorePlayerFirst;
@property (weak, nonatomic) IBOutlet UILabel *scorePlayerFourth;
@property (weak, nonatomic) IBOutlet UILabel *scorePlayerSecond;
@property (weak, nonatomic) IBOutlet UILabel *scorePlayerThree;

// Data
@property (nonatomic, strong) Board *board;
@property (nonatomic, strong) NSMutableArray *horizontalButtons;
@property (nonatomic, strong) NSMutableArray *verticalButtons;
@property (nonatomic, strong) NSMutableArray *pieces;
@property (nonatomic, strong) NSArray *scores;

@property (nonatomic, strong) NSArray *colorUsers;
@property (nonatomic, assign) NSInteger rows;
@property (nonatomic, assign) NSInteger columns;
@property (nonatomic, assign) NSInteger pieceSelected;
@property (nonatomic, assign) BOOL alreadyAppear;

@end

@implementation MapViewController

#pragma mark - Initializers

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (!self.alreadyAppear)
    {
        self.alreadyAppear = true;
        [self initGame];
    }
}

- (void)configureMapWithRows:(NSInteger)rows columns:(NSInteger)columns
{
    self.rows = rows;
    self.columns = columns;
}

- (void)initGame
{
    self.scores = @[self.scorePlayerFirst, self.scorePlayerSecond, self.scorePlayerThree, self.scorePlayerFourth];
    [self initScorePlayer];
    
    self.pieceSelected = 0;
    
    // Build Map and Associate Piece
    [self buildMapWithRows:self.rows columns:self.columns];
    
    // Associate buttons to correct piece and vice versa
    [self linkComponents:self.columns];
    
    //Hidde winner view
    [self displayWinnerView:NO];
}

- (void)initScorePlayer
{
    for (Player *player in [PlayerManager sharedInstance].playersArray)
    {
        ((UILabel *)self.scores[player.position]).textColor = player.colorPlayer;
        ((UILabel *)self.scores[player.position]).text = @"0";
    }
}

- (void)updateScore:(Player *)player
{
    ((UILabel *)self.scores[player.position]).text = [NSString stringWithFormat:@"%ld", (long)player.score];
}

- (void)buildMapWithRows:(NSInteger)rows columns:(NSInteger)columns
{
    int smallSideBarButton = BAR_BUTTON_SPACE;
    int highSideBarButton = SIZE_PIECE;
    int pieceSize = SIZE_PIECE;
    int space = BAR_BUTTON_SPACE;
    
    // Offset est l'espace à gauche du plateau et à droite du plateau pour aiérer.
    int offsetWidth = (self.view.frame.size.width - (self.columns*highSideBarButton) - (space*(self.columns+1)))/2;
    int offsetHeight = (self.view.frame.size.height - (self.rows*highSideBarButton) - (space*(self.rows+1)))/2;
    
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
                verticalButton = [[BarButton alloc] initWithFrame:CGRectMake(i*pieceSize + (i*smallSideBarButton) - highSideBarButton + offsetWidth - space - (MIN_LARGER_TOUCH - BAR_BUTTON_SPACE)/2,
                                                                             j*pieceSize + (j*space) - highSideBarButton + offsetHeight,
                                                                             MIN_LARGER_TOUCH,
                                                                             highSideBarButton)
                                                             type:VERTICAL_BAR_BUTTON_XIB];
                verticalButton.delegate = self;
                [self.verticalButtons addObject:verticalButton];
            }
            
            // Horizontal button
            BarButton *horizontalButton;
            if (i <= self.columns)
            {
                horizontalButton = [[BarButton alloc] initWithFrame:CGRectMake(i*pieceSize + (i*smallSideBarButton) - highSideBarButton + offsetWidth,
                                                                               j*pieceSize + (j*space) - space - highSideBarButton + offsetHeight - (MIN_LARGER_TOUCH - BAR_BUTTON_SPACE)/2,
                                                                               highSideBarButton,
                                                                               MIN_LARGER_TOUCH)
                                                               type:HORIZONTAL_BAR_BUTTON_XIB];
                horizontalButton.delegate = self;
                [self.horizontalButtons addObject:horizontalButton];
            }
            
            if (i <= self.columns && j <= self.rows)
            {
                // Piece
                Piece *piece = [[Piece alloc] initWithFrame:CGRectMake(verticalButton.frame.origin.x + space + (highSideBarButton/2) - (highSideBarButton/2) + (MIN_LARGER_TOUCH - BAR_BUTTON_SPACE)/2,
                                                                       verticalButton.frame.origin.y + (highSideBarButton/2) - (highSideBarButton/2),
                                                                       highSideBarButton,
                                                                       highSideBarButton)
                                                   position:CGPointMake(i - 1, j - 1)];
                [self.mapView addSubview:piece];
                [self.pieces addObject:piece];
            }
            
            if (j <= self.rows)
            {
                [self.mapView addSubview:verticalButton];
                
            }
            if (i <= self.columns)
            {
                [self.mapView addSubview:horizontalButton];
            }
        }
    }
}


#pragma mark - CustomButtonDelegate

- (void)setButton:(BarButton *)button
{
    [self buttonSelected:button];
}

- (void)buttonSelected:(BarButton *)button
{
    // Retrieve player
    Player *player = [[PlayerManager sharedInstance] currentPlayer];
    
    // Change Background BarButton
    if (!button.hasAlreadyBeenSelected) {
        
        [button selectWithPlayer:player];
        
        BOOL pieceHasBeenWin = false;
        
        // Check if piece is complete
        for (Piece *piece in button.pieceAssociated)
        {
            if ([self didCompletePiece:piece])
            {
                [piece selectWithPlayer:player];
                player.score ++;
                self.pieceSelected ++;
                [self updateScore:player];
                pieceHasBeenWin = true;
            }
        }
        
        if ([self isMapComplete])
        {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
            Player *player = [[PlayerManager sharedInstance] winner];
            NSString *winner = player ? [NSString stringWithFormat:@"Winner is %@", player.name] : @"Match Null";
            self.winnerLabel.text = winner;
            [self displayWinnerView:YES];
        }
        else
        {
            [[PlayerManager sharedInstance] nextPlayer];
            Player *currentPlayer = [[PlayerManager sharedInstance] currentPlayer];
            if (currentPlayer.isABot)
            {
                [self enableUsersInteractions:NO];
                [self buttonSelected:[currentPlayer selectBarButton:[self.horizontalButtons arrayByAddingObjectsFromArray:self.verticalButtons]]];
            }
            else
            {
                [self enableUsersInteractions:YES];
            }
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

#pragma mark - Action

- (IBAction)restartGame:(id)sender {
    for (UIView *view in self.mapView.subviews)
    {
        [view removeFromSuperview];
    }
    
    [[PlayerManager sharedInstance] resetCurrentPlayer];
    [self initGame];
}

#pragma mark - Utils

- (void)enableUsersInteractions:(BOOL)enable
{
    if (enable)
    {
        if ([UIApplication sharedApplication].isIgnoringInteractionEvents)
        {
            [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        }
    }
    else
    {
        if (![UIApplication sharedApplication].isIgnoringInteractionEvents)
        {
            [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
        }
    }
}


- (void)displayWinnerView:(BOOL)show
{
    self.winnerView.hidden = !show;
    self.winnerLabel.hidden = !show;
}

@end
