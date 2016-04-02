//
//  MapViewController.h
//  PetitCarres
//
//  Created by Paul Lavoine on 09/09/2015.
//  Copyright (c) 2015 Paul Lavoine. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MapViewControllerID @"MapViewControllerID"

@interface MapViewController : ChildViewController

- (void)configureMapWithRows:(NSInteger)rows columns:(NSInteger)columns;

@end

