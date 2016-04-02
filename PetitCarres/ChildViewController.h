//
//  ChildViewController.h
//  Pipopipette
//
//  Created by Paul Lavoine on 02/04/2016.
//  Copyright © 2016 Paul Lavoine. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RootViewController.h"

@interface ChildViewController : UIViewController

@property (nonatomic, strong) RootViewController *rootParentViewController;

@end
