//
//  HCDrawerSwipeChildViewController.h
//  HCDrawerSwipeSegue
//
//  Created by Aaron Hull on 6/23/14.
//  Copyright (c) 2014 Hull Computing. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HCDrawerSwipeMasterViewController.h"


@interface HCDrawerSwipeChildViewController : UIViewController

@property (nonatomic, readonly, assign) HCDrawerSwipeMasterViewController *masterViewController;
@property (nonatomic) HCDrawerSwipeChildPosition position;

@end

@interface HCDrawerSwipeChildSideViewController : HCDrawerSwipeChildViewController

@end

@interface HCDrawerSwipeChildCenterViewController : HCDrawerSwipeChildViewController
@property (nonatomic, strong) NSDictionary *userInfo;
@end