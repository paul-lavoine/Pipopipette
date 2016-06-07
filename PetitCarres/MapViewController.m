//
//  MapViewController.m
//  PetitCarres
//
//  Created by Paul Lavoine on 09/09/2015.
//  Copyright (c) 2015 Paul Lavoine. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "MapViewController.h"
#import "WinnerViewController.h"

#import "PlayerManager.h"
#import "Minimax.h"
#import "Component.h"

#define SPIN_ANIMATION          @"SpinAnimation"
#define ROTATION_DURATION       1.0f
#define EXPAND_DURATION         2.0f
#define EXPAND_DELAY            0.5f
#define RIGHT_BAR_BUTTON_SIZE   25

@interface MapViewController () <CustomButtonDelegate>

// Outlets
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIView *mapView;
@property (weak, nonatomic) IBOutlet UIView *boardGame;
@property (weak, nonatomic) IBOutlet UIView *winnerView;
@property (weak, nonatomic) IBOutlet UILabel *winnerLabel;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *replayButton;

@property (weak, nonatomic) IBOutlet UILabel *scorePlayerFirst;
@property (weak, nonatomic) IBOutlet UILabel *scorePlayerFourth;
@property (weak, nonatomic) IBOutlet UILabel *scorePlayerSecond;
@property (weak, nonatomic) IBOutlet UILabel *scorePlayerThree;

// Constraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mapViewVerticalTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mapViewVerticalBottomConstraint;

// Data
@property (nonatomic, strong) WinnerViewController *winnerViewController;
@property (nonatomic, strong) UILabel *navigationBarTitle;
@property (nonatomic, strong) NSMutableArray *horizontalButtons;
@property (nonatomic, strong) NSMutableArray *verticalButtons;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) NSMutableArray *pieces;
@property (nonatomic, strong) NSArray *scores;
@property (nonatomic, strong) BarButton *lastBarButtonPlayed;

@property (nonatomic, strong) NSArray *colorUsers;
@property (nonatomic, assign) NSInteger rows;
@property (nonatomic, assign) NSInteger columns;
@property (nonatomic, assign) NSInteger pieceSelected;
@property (nonatomic, assign) BOOL alreadyAppear;
@property (nonatomic, assign) BOOL animating;

@end

@implementation MapViewController

#pragma mark - Initializers

- (void)viewDidLoad
{
    [super viewDidLoad];
    //    [self setNavigationBarTitle];
    [self configureUI];
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

- (void)configureUI
{
    // Right Bar Button Item
    [self.replayButton.imageView setContentMode:UIViewContentModeScaleAspectFit];
    self.replayButton.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    self.replayButton.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    self.replayButton.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
    [self.replayButton.titleLabel setFont:ROBOTO_REGULAR(15.0f)];
    
    // left Bar Button Item
    [self.backButton.titleLabel setFont:ROBOTO_REGULAR(15.0f)];
    
    // Constraint
    [self configureConstraintWithHeightView];
}

- (void)configureConstraintWithHeightView
{
    if (IS_IPHONE_4)
    {
        self.mapViewVerticalTopConstraint.constant = 17;
        self.mapViewVerticalBottomConstraint.constant = 17;
    }
    else if (IS_IPHONE_5)
    {
        self.mapViewVerticalTopConstraint.constant = 20;
        self.mapViewVerticalBottomConstraint.constant = 20;
    }
    else if (IS_IPHONE_6)
    {
        self.mapViewVerticalTopConstraint.constant = 24;
        self.mapViewVerticalBottomConstraint.constant = 23;
    }
    else if (IS_IPHONE_6_PLUS)
    {
        self.mapViewVerticalTopConstraint.constant = 26;
        self.mapViewVerticalBottomConstraint.constant = 26;
    }
    else
    {
        NSLog(@"dont know this iphone size");
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
    [[Component class] linkComponentsWithPieces:self.pieces horizontalButtons:self.horizontalButtons verticalButtons:self.verticalButtons nbColumnsAvailable:self.columns];
    
    //Hidde winner view
    [self displayWinnerView:NO player:nil];
    
    // Init Algorithm
    Player *botPlayer;
    for (Player *player in [[PlayerManager sharedInstance] playersArray])
    {
        if (player.isABot)
        {
            botPlayer = player;
        }
    }
    [Minimax sharedInstance].columns = self.columns;
    [Minimax sharedInstance].rows = self.rows;
    [self.winnerViewController.view removeFromSuperview];
    self.winnerViewController = nil;
}

- (void)initScorePlayer
{
    for (Player *player in [PlayerManager sharedInstance].playersArray)
    {
        ((UILabel *)self.scores[player.position]).textColor = player.colorPlayer;
        ((UILabel *)self.scores[player.position]).text = @"0";
    }
}

- (void)incrementScore:(Player *)player
{
    player.score ++;
    ((UILabel *)self.scores[player.position]).text = [NSString stringWithFormat:@"%ld", (long)player.score];
}

- (void)buildMapWithRows:(NSInteger)rows columns:(NSInteger)columns
{
    int smallSideBarButton = BAR_BUTTON_SPACE;
    int highSideBarButton = SIZE_PIECE;
    int pieceSize = SIZE_PIECE;
    int space = BAR_BUTTON_SPACE;
    
    // Offset est l'espace à gauche du plateau et à droite du plateau pour aiérer.
    int offsetWidth = (self.contentView.frame.size.width - (self.columns*highSideBarButton) - (space*(self.columns+1)))/2;
    int offsetHeight = (self.mapView.frame.size.height - (self.rows*highSideBarButton) - (space*(self.rows+1)))/2 - 35;
    
    // Vertical bar
    self.pieces = [NSMutableArray array];
    self.horizontalButtons = [NSMutableArray array];
    self.verticalButtons = [NSMutableArray array];
    NSInteger cptIdBarButton = 0;
    NSInteger cptIdPiece = 0;
    
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
                                                             type:VERTICAL_BAR_BUTTON_XIB
                                                       idPosition:cptIdBarButton];
                verticalButton.position = CGPointMake(i*100, j*100);
                verticalButton.delegate = self;
                [self.verticalButtons addObject:verticalButton];
                cptIdBarButton++;
            }
            
            // Horizontal button
            BarButton *horizontalButton;
            if (i <= self.columns)
            {
                horizontalButton = [[BarButton alloc] initWithFrame:CGRectMake(i*pieceSize + (i*smallSideBarButton) - highSideBarButton + offsetWidth,
                                                                               j*pieceSize + (j*space) - space - highSideBarButton + offsetHeight - (MIN_LARGER_TOUCH - BAR_BUTTON_SPACE)/2,
                                                                               highSideBarButton,
                                                                               MIN_LARGER_TOUCH)
                                                               type:HORIZONTAL_BAR_BUTTON_XIB
                                                         idPosition:cptIdBarButton];
                horizontalButton.delegate = self;
                horizontalButton.position = CGPointMake(i, j);
                [self.horizontalButtons addObject:horizontalButton];
                cptIdBarButton++;
            }
            
            if (i <= self.columns && j <= self.rows)
            {
                // Piece
                Piece *piece = [[Piece alloc] initWithFrame:CGRectMake(verticalButton.frame.origin.x + space + (highSideBarButton/2) - (highSideBarButton/2) + (MIN_LARGER_TOUCH - BAR_BUTTON_SPACE)/2,
                                                                       verticalButton.frame.origin.y + (highSideBarButton/2) - (highSideBarButton/2),
                                                                       highSideBarButton,
                                                                       highSideBarButton)
                                                   position:CGPointMake(i - 1, j - 1)
                                                        uid:cptIdPiece];
                cptIdPiece++;
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
    
    // Build map with all buttons
    [self buildButtonsArray];
}

- (void)buildButtonsArray
{
    self.buttons = [NSMutableArray array];
    
    NSInteger globalHorizontalCpt = 0;
    NSInteger globalVerticalCpt = 0;
    NSInteger horizontalCpt = 0;
    NSInteger verticalCpt = 0;
    BOOL countHorizontalButton = true;
    
    while (globalHorizontalCpt < [self.horizontalButtons count] || globalVerticalCpt < [self.verticalButtons count])
    {
        
        if (countHorizontalButton)
        {
            [self.buttons addObject:[self.horizontalButtons objectAtIndex:globalHorizontalCpt]];
            horizontalCpt++;
            globalHorizontalCpt ++;
            
            if (horizontalCpt == self.columns)
            {
                countHorizontalButton = false;
                horizontalCpt = 0;
            }
        }
        else
        {
            [self.buttons addObject:[self.verticalButtons objectAtIndex:globalVerticalCpt]];
            verticalCpt ++;
            globalVerticalCpt ++;
            
            if (verticalCpt == self.columns + 1)
            {
                countHorizontalButton = true;
                verticalCpt = 0;
            }
        }
    }
}

- (void)barButtonSelected:(BarButton *)button
{
    if (button.hasAlreadyBeenSelected)
        return;
    
    [self.lastBarButtonPlayed setColorBackground];
    self.lastBarButtonPlayed = button;
    
    // Retrieve player
    Player *player = [[PlayerManager sharedInstance] currentPlayer];
    
    // Change Background BarButton
    [button selectedByPlayer:player animate:YES];
    
    BOOL pieceHasBeenWin = false;
    
    // Check if piece is complete
    for (Piece *piece in button.pieceAssociated)
    {
        if ([piece isCompletePiece])
        {
            pieceHasBeenWin = true;
            self.pieceSelected ++;
            [piece selectedByPlayer:player];
            [self incrementScore:player];
        }
    }
    
    if ([self isMapComplete])
    {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        Player *player = [[PlayerManager sharedInstance] winner];
        [self configureWinnerTitleWithPlayer:player];
        [self displayWinnerView:YES player:player];
    }
    else
    {
        if (!pieceHasBeenWin)
        {
            [self nextTurn];
        }
        else if (player.isABot)
        {
            [self botShouldPlay:player];
        }
        else
        {
            // Piece has been win and player is real
            // Waiting for next real player
        }
    }
}

- (void)nextTurn
{
    [[PlayerManager sharedInstance] nextPlayer];
    Player *currentPlayer = [[PlayerManager sharedInstance] currentPlayer];
    [self setNavigationBarTitle];
    
    if (currentPlayer.isABot)
    {
        [self botShouldPlay:currentPlayer];
    }
    else
    {
        [self enableUsersInteractions:YES];
    }
}

- (void)botShouldPlay:(Player *)player
{
    [self enableUsersInteractions:NO];
    
    NSDate * dateBeforeComputeBar = [NSDate date];
    BarButton *barbuttonSelected = [player selectBarWithButtons:self.buttons pieces:self.pieces];
    
    NSTimeInterval  interval = -[dateBeforeComputeBar timeIntervalSinceNow];
    
    if (interval < MIN_TIME_BEFORE_PLAYING)
    {
        [NSTimer scheduledTimerWithTimeInterval:MIN_TIME_BEFORE_PLAYING - interval target:self selector:@selector(handleTimer:) userInfo:barbuttonSelected repeats:NO];
    }
    else
    {
        [self barButtonSelected:barbuttonSelected];
    }
}

#pragma mark - CustomButtonDelegate

- (void)setButton:(BarButton *)button
{
    [self barButtonSelected:button];
}


#pragma mark - Utils

- (void)setNavigationBarTitle
{
    //    self.navigationBarTitle.attributedText = [self configureAttributedStringWithPlayer:[[PlayerManager sharedInstance] currentPlayer] string:@"Tour du joueur " sizeFont:18.0f];
    //    [self.navigationBarTitle sizeToFit];
    //    self.navigationItem.titleView = self.navigationBarTitle;
}

- (void)handleTimer:(NSTimer*)theTimer
{
    BarButton *barButton = [theTimer userInfo];
    [self barButtonSelected:barButton];
}

- (BOOL)isMapComplete
{
    return (self.pieceSelected == (self.rows * self.columns));
}

- (void)configureWinnerTitleWithPlayer:(Player *)player
{
    NSAttributedString *winnerStringWithColor;
    if (player)
    {
        winnerStringWithColor = [self configureAttributedStringWithPlayer:player string:@"Winner is " sizeFont:60.0f];
    }
    else
    {
        winnerStringWithColor = [[NSAttributedString alloc] initWithString:@"Match Null"];
    }
    
    self.winnerLabel.attributedText = winnerStringWithColor;
}

- (NSMutableAttributedString *)configureAttributedStringWithPlayer:(Player *)player string:(NSString *)string sizeFont:(CGFloat)sizeFont
{
    NSMutableAttributedString *winnerStringWithColor = [[NSMutableAttributedString alloc] initWithString:string];
    NSDictionary *attrs = @{ NSForegroundColorAttributeName : player.colorPlayer,
                             NSFontAttributeName : [UIFont fontWithName:self.winnerLabel.font.fontName size:sizeFont]
                             };
    
    NSAttributedString *playerName = [[NSAttributedString alloc] initWithString:player.name attributes:attrs];
    [winnerStringWithColor appendAttributedString:playerName];
    
    return winnerStringWithColor;
}

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

#pragma mark - Action

- (IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)replay:(id)sender
{
    for (UIView *view in self.mapView.subviews)
    {
        [view removeFromSuperview];
    }
    
    [[PlayerManager sharedInstance] resetCurrentPlayer];
    [self initGame];
}

#pragma mark - Winner View Management

- (void)displayWinnerView:(BOOL)show player:(Player *)player
{
    if (show)
    {
        [self rotateSpinningView:self.boardGame];
        
        [UIView animateWithDuration:EXPAND_DURATION
                              delay:0.0f
                            options:UIViewAnimationOptionTransitionNone
                         animations: ^{
                             self.boardGame.transform = CGAffineTransformMakeScale(0.1, 0.1);
                         } completion:^(BOOL finished){
                             [self addWinnerViewWithPlayer:player];
                             [UIView animateWithDuration:EXPAND_DURATION
                                                   delay:EXPAND_DELAY
                                                 options:UIViewAnimationOptionTransitionNone
                                              animations: ^{
                                                  self.boardGame.transform = CGAffineTransformMakeScale(1, 1);
                                              } completion:^(BOOL finished){
                                                  [self stopSpin];
                                              }];
                         }];
    }
}

- (void)rotateSpinningView:(UIView *)viewToSpin
{
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = [NSNumber numberWithFloat:0.0f];
    animation.toValue = [NSNumber numberWithFloat: 2*M_PI*4];
    animation.duration = ROTATION_DURATION;
    animation.repeatCount = INFINITY;
    [viewToSpin.layer addAnimation:animation forKey:SPIN_ANIMATION];
}

- (void)stopSpin
{
    [self.boardGame.layer removeAnimationForKey:SPIN_ANIMATION];
}

- (void)addWinnerViewWithPlayer:(Player *)player
{
    self.winnerViewController = [[WinnerViewController alloc] initWithWinner:player];
    self.winnerViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.winnerViewController.view setFrame:self.boardGame.frame];
    [self.boardGame addSubview:self.winnerViewController.view];
    [self addConstraintToView:self.winnerViewController.view];
}

- (void)addConstraintToView:(UIView *)view
{
    self.boardGame.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    [self.boardGame addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                     attribute:NSLayoutAttributeTrailing
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.boardGame
                                                     attribute:NSLayoutAttributeTrailing
                                                    multiplier:1.0
                                                      constant:0.0]];
    
    [self.boardGame addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.boardGame
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1.0
                                                      constant:0.0]];
    
    [self.boardGame addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.boardGame
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0
                                                      constant:0.0]];
    
    [self.boardGame addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                     attribute:NSLayoutAttributeLeading
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.boardGame
                                                     attribute:NSLayoutAttributeLeading
                                                    multiplier:1.0
                                                      constant:0.0]];
}

@end
