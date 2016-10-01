//
//  TutorielViewController.m
//  PetitCarres
//
//  Created by Paul Lavoine on 08/02/2016.
//  Copyright © 2016 Paul Lavoine. All rights reserved.
//

#import "TutorielViewController.h"

#define OFFSET_IPAD_FONT_SIZE   (IS_IPAD ? 8.0f : 0.0f)

@interface TutorielViewController ()

@property (weak, nonatomic) IBOutlet UILabel *introLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstRule;
@property (weak, nonatomic) IBOutlet UILabel *secondRule;
@property (weak, nonatomic) IBOutlet UILabel *thirdRule;
@property (weak, nonatomic) IBOutlet UILabel *titleNoteLabel;
@property (weak, nonatomic) IBOutlet UILabel *noteLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstQuoteLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondQuoteLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdQuoteLabel;
@property (weak, nonatomic) IBOutlet UIView *contentView;

// Constraint
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthFirstQuoteConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthSecondQuoteConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthThirdQuoteConstraint;

@end

@implementation TutorielViewController

#pragma mark - Constructor

- (instancetype)init
{
    if (self = [super initWithNibName:@"TutorielViewController" bundle:nil])
    {
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureUI];
}

- (void)configureUI
{
    self.introLabel.text = LOCALIZED_STRING(@"tutorial.introduction.label");
    self.firstQuoteLabel.text = @"1.";
    self.secondQuoteLabel.text = @"2.";
    self.thirdQuoteLabel.text = @"3.";
    self.firstRule.text = LOCALIZED_STRING(@"tutorial.first_rule.label");
    self.secondRule.text = LOCALIZED_STRING(@"tutorial.second_rule.label");
    self.thirdRule.text = LOCALIZED_STRING(@"tutorial.third_rule.label");
    self.titleNoteLabel.text = LOCALIZED_STRING(@"tutorial.note_title.label");
    self.noteLabel.text = LOCALIZED_STRING(@"tutorial.note_content.label");
    
    if (IS_IPAD)
    {
        self.widthFirstQuoteConstraint.constant += OFFSET_IPAD_FONT_SIZE;
        self.widthSecondQuoteConstraint.constant += OFFSET_IPAD_FONT_SIZE;
        self.widthThirdQuoteConstraint.constant += OFFSET_IPAD_FONT_SIZE;
    }
    
    
    NSArray *regularLabels = @[self.introLabel, self.firstRule, self.secondRule, self.thirdRule, self.noteLabel];
    NSArray *boldLabels = @[self.titleNoteLabel, self.firstQuoteLabel, self.secondQuoteLabel, self.thirdQuoteLabel];
    
    for (UILabel *label in regularLabels)
    {
        [label setFont:ROBOTO_REGULAR(13.0f + OFFSET_IPAD_FONT_SIZE)];
    }
    
    for (UILabel *label in boldLabels)
    {
        [label setFont:ROBOTO_BOLD(13.0f + OFFSET_IPAD_FONT_SIZE)];
    }
}

@end
