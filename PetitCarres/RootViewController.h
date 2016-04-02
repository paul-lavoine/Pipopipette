//
//  RootViewController.h
//  PetitCarres
//
//  Created by Paul Lavoine on 09/02/2016.
//  Copyright © 2016 Paul Lavoine. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChildViewController;

@interface RootViewController : UIViewController

- (instancetype)initWithTitle:(NSString *)title image:(UIImage *)image subView:(ChildViewController *)subView;
- (void)pushViewController:(UIViewController *)viewController;

@end
