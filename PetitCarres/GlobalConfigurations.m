//
//  GlobalConfigurations.m
//  PetitCarres
//
//  Created by Paul Lavoine on 07/02/2016.
//  Copyright © 2016 Paul Lavoine. All rights reserved.
//

#import "GlobalConfigurations.h"


@interface GlobalConfigurations ()

@end

@implementation GlobalConfigurations

#pragma mark - Shared instance

+ (instancetype)sharedInstance
{
    static GlobalConfigurations *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[GlobalConfigurations alloc] init];
        [sharedInstance defaultConfigurations];
    });
    
    return sharedInstance;
}

- (void)defaultConfigurations
{
    self.nbPlayer = NB_DEFAULT_PLAYER;
    self.nbBot = NB_DEFAULT_BOT;
}

@end
