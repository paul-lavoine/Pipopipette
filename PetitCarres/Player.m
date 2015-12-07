//
//  Player.m
//  PetitCarres
//
//  Created by Paul Lavoine on 09/09/2015.
//  Copyright (c) 2015 Paul Lavoine. All rights reserved.
//

#import "Player.h"

@interface Player ()


@end


@implementation Player

- (instancetype)initWithColor:(UIColor *)color name:(NSString *)name icone:(NSString *)icone
{
    if (self = [super init])
    {
        _colorPlayer = color;
        _name = name;
        _icone = [UIImage imageNamed:icone];
    }
    
    return self;
}


@end
