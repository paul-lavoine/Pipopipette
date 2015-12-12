//
//  NSMutableArray+Additions.m
//  PetitCarres
//
//  Created by Paul Lavoine on 12/12/2015.
//  Copyright © 2015 Paul Lavoine. All rights reserved.
//

#import "NSMutableArray+Additions.h"

@implementation NSMutableArray (Additions)

- (void)shuffle
{
    NSUInteger count = [self count];
    for (NSUInteger i = 0; i < count - 1; ++i) {
        NSInteger remainingCount = count - i;
        NSInteger exchangeIndex = i + arc4random_uniform((u_int32_t )remainingCount);
        [self exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
    }
}

@end
