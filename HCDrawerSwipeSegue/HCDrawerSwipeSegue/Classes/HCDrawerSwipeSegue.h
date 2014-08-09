//
//  HCDrawerSwipeSegue.h
//  HCDrawerSwipeSegue
//
//  Created by Aaron Hull on 3/20/14.
//  Copyright (c) 2014 Hull Computing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCDrawerSwipeChildViewController.h"
#import "HCDrawerSwipeMasterViewController.h"

static NSString *const kHCDSSegueIdentifierLeftSwipe = @"kHCDSSegueIdentifierLeftSwipe";
static NSString *const kHCDSSegueIdentifierRightSwipe = @"kHCDSSegueIdentifierRightSwipe";

@interface HCDrawerSwipeSegue : UIStoryboardSegue

@end