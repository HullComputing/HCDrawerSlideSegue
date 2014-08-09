//
//  HCDrawerSwipeSegue.m
//  HCDrawerSwipeSegue
//
//  Created by Aaron Hull on 3/20/14.
//  Copyright (c) 2014 Hull Computing. All rights reserved.
//

#import "HCDrawerSwipeSegue.h"
#import "HCDrawerSwipeChildViewController.h"
#import "HCDrawerSwipeMasterViewController.h"



@interface HCDrawerSwipeMasterViewController ()
@property (nonatomic, readwrite) HCDrawerSwipeChildViewController *sideChildViewController;
- (HCDrawerSwipeChildPosition)showingPanelInPosition;
- (void)showPanelOnSide:(HCDrawerSwipeChildPosition)side;
- (void)resetPositions;
@end

@interface HCDrawerSwipeChildViewController ()
@property (nonatomic, readwrite, assign) HCDrawerSwipeMasterViewController *masterViewController;
@end



@interface HCDrawerSwipeSegue ()
@property (nonatomic, strong) HCDrawerSwipeMasterViewController *masterViewController;
@property (nonatomic, strong) HCDrawerSwipeChildViewController *sideChildViewController;
@property (nonatomic, strong) HCDrawerSwipeChildCenterViewController *centerChildViewController;
@property (nonatomic, getter=isInitialTest) BOOL initialTest;

@end

@implementation HCDrawerSwipeSegue
@synthesize masterViewController, sideChildViewController, centerChildViewController;

- (id)initWithIdentifier:(NSString *)identifier source:(UIViewController *)source destination:(UIViewController *)destination
{
    self = [super initWithIdentifier:identifier source:source destination:destination];
    if (self) {
        if ([source isKindOfClass:[HCDrawerSwipeMasterViewController class]]) {
            masterViewController = (HCDrawerSwipeMasterViewController *)source;
        } else {
            masterViewController = [HCDrawerSwipeMasterViewController masterViewControllerFromViewController:source];
        }
        if (masterViewController) {
            if (![self.masterViewController showingPanelInPosition]) {
                masterViewController.originalViewFrame = masterViewController.view.frame;
            }
            if ([self.masterViewController showingPanelInPosition]) {
                for (UIViewController *childVC in masterViewController.childViewControllers) {
                    if ([childVC isKindOfClass:[HCDrawerSwipeChildViewController class]]) {
                        sideChildViewController = (HCDrawerSwipeChildViewController *)childVC;
                    }
                }
                
            } else {
                if ([destination isKindOfClass:[HCDrawerSwipeChildViewController class]] && [(HCDrawerSwipeChildViewController *)destination respondsToSelector:@selector(position)]) {
                    sideChildViewController = (HCDrawerSwipeChildViewController *)destination;
                }
            }
            if ([destination isKindOfClass:[HCDrawerSwipeChildCenterViewController class]]) {
                centerChildViewController = (HCDrawerSwipeChildCenterViewController *)destination;
            }
        }
    }
    return self;
}

- (void)perform
{
    if (!self.isInitialTest) {
        if (self.masterViewController && !self.centerChildViewController && self.sideChildViewController && [self.sideChildViewController respondsToSelector:@selector(position)]) {
            if (!self.masterViewController.sideChildViewController) {
                self.masterViewController.sideChildViewController = self.sideChildViewController;
            }
            if (sideChildViewController.position == [self.masterViewController showingPanelInPosition]) {
                [masterViewController resetPositions];
            } else {
                [masterViewController showPanelOnSide:sideChildViewController.position];
            }
        } else if (self.masterViewController && centerChildViewController && [centerChildViewController respondsToSelector:@selector(position)]) {
            [masterViewController presentCenterViewController:centerChildViewController withUserInfo:nil];
        }
    }
}

@end



