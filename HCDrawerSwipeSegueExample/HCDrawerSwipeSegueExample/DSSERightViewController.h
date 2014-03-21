//
//  DSSERightViewController.h
//  HCDrawerSwipeSegueExample
//
//  Created by Aaron Hull on 3/20/14.
//  Copyright (c) 2014 Hull Computing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HCDrawerSwipeSegueBundle/HCDrawerSwipeSegue.h>

@interface DSSERightViewController : UIViewController <HCDrawerSwipeChildViewControllerProtocol>
@property (nonatomic) HCDrawerSwipeChildPosition position;
@property (nonatomic, readonly) UIViewController<HCDrawerSwipeMasterViewControllerProtocol> *masterViewController;
@end
