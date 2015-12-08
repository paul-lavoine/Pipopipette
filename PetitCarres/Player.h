//
//  Player.h
//  PetitCarres
//
//  Created by Paul Lavoine on 09/09/2015.
//  Copyright (c) 2015 Paul Lavoine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define DEFAULT_NAME @"Player"

@interface Player : NSObject

- (instancetype)initWithColor:(UIColor *)color name:(NSString *)name icone:(NSString *)icone position:(NSInteger)position;

@property (nonatomic, strong) UIColor *colorPlayer;
@property (nonatomic, assign) NSInteger score;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) UIImage *icone;
@property (nonatomic, assign) NSInteger position;

@end
