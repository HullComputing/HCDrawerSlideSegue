//
//  DSSEViewController.h
//  HCDrawerSwipeSegueExample
//
//  Created by Aaron Hull on 3/19/14.
//  Copyright (c) 2014 Hull Computing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HCDrawerSwipeSegueBundle/HCDrawerSwipeSegue.h>

@interface DSSEViewController : HCDrawerSwipeMasterViewController

@property (nonatomic) BOOL isShowingRightPanel;
@property (nonatomic) BOOL isShowingLeftPanel;
@property (nonatomic) CGRect originalViewFrame;

@end
