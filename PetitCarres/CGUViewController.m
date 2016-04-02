//
//  CGUViewController.m
//  PetitCarres
//
//  Created by Paul Lavoine on 08/02/2016.
//  Copyright © 2016 Paul Lavoine. All rights reserved.
//

#import "CGUViewController.h"

@interface CGUViewController ()

// Outlets
@property (weak, nonatomic) IBOutlet UILabel *developmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *designLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleGameLabel;
@property (weak, nonatomic) IBOutlet UILabel *copyrightLabel;

@end


@implementation CGUViewController

#pragma mark - Initializers

- (instancetype)init
{
    if (self = [super initWithNibName:@"CGUViewController" bundle:nil])
    {
        
    }
    
    return self;
}

#pragma mark - Life cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureUI];
}

- (void)configureUI
{
    UIFont *regularFont = [UIFont fontWithName:@"Roboto-Regular" size:15.0f];
    UIFont *lightFont = [UIFont fontWithName:@"Roboto-Light" size:16.5f];
    UIFont *lightBigFont = [UIFont fontWithName:@"Roboto-Light" size:23.5f];
    UIFont *thinFont = [UIFont fontWithName:@"Roboto-Thin" size:20.0f];
    
    NSMutableAttributedString *development = [[NSMutableAttributedString alloc] initWithString:@"application développé par\n" attributes:@{NSFontAttributeName : lightFont}];
    [development appendAttributedString:[[NSAttributedString alloc] initWithString:@"PAUL LAVOINE" attributes:@{NSFontAttributeName : regularFont}]];

    
    NSMutableAttributedString *designLight = [[NSMutableAttributedString alloc] initWithString:@"design par\n" attributes:@{NSFontAttributeName : lightFont}];
    [designLight appendAttributedString:[[NSAttributedString alloc] initWithString:@"MARINE DI FRANCO" attributes:@{NSFontAttributeName : regularFont}]];
    
    
    NSMutableAttributedString *titleThin = [[NSMutableAttributedString alloc] initWithString:@"LA " attributes:@{NSFontAttributeName : thinFont}];
     [titleThin appendAttributedString:[[NSAttributedString alloc] initWithString:@"PIPOPIPETTE" attributes:@{NSFontAttributeName : lightBigFont}]];
    
     NSAttributedString *copyrightLight = [[NSAttributedString alloc] initWithString:@"© copyright Paul Lavoine - 2016" attributes:@{NSFontAttributeName : lightFont}];
    
    self.developmentLabel.attributedText = development;
    self.designLabel.attributedText = designLight;
    self.titleGameLabel.attributedText = titleThin;
    self.copyrightLabel.attributedText = copyrightLight;
}

@end
