//
//  HCDrawerSwipeSegue.m
//  HCDrawerSwipeSegue
//
//  Created by Aaron Hull on 3/20/14.
//  Copyright (c) 2014 Hull Computing. All rights reserved.
//

#import "HCDrawerSwipeSegue.h"

static NSInteger kHCDrawerSwipeContentViewTag = 45677890;

@interface HCDrawerSwipeSegue ()
@property (nonatomic, strong) UIViewController<HCDrawerSwipeMasterViewControllerProtocol> *masterViewController;
@property (nonatomic, strong) UIViewController<HCDrawerSwipeChildViewControllerProtocol> *childViewController;
@end

@implementation HCDrawerSwipeSegue
@synthesize masterViewController, childViewController;

- (id)initWithIdentifier:(NSString *)identifier source:(UIViewController *)source destination:(UIViewController *)destination
{
    self = [super initWithIdentifier:identifier source:source destination:destination];
    if (self) {
        if ([source conformsToProtocol:@protocol(HCDrawerSwipeMasterViewControllerProtocol)]) {
            masterViewController = (UIViewController <HCDrawerSwipeMasterViewControllerProtocol> *)source;
            if (!masterViewController.isShowingRightPanel && !masterViewController.isShowingRightPanel) {
                masterViewController.originalViewFrame = masterViewController.view.frame;
            }
        }
        if (masterViewController.isShowingRightPanel || masterViewController.isShowingLeftPanel) {
            for (UIViewController *childVC in masterViewController.childViewControllers) {
                if ([childVC conformsToProtocol:@protocol(HCDrawerSwipeChildViewControllerProtocol)]) {
                    childViewController = (UIViewController <HCDrawerSwipeChildViewControllerProtocol> *)childVC;
                }
            }
        } else {
            if ([destination conformsToProtocol:@protocol(HCDrawerSwipeChildViewControllerProtocol)]) {
                childViewController = (UIViewController <HCDrawerSwipeChildViewControllerProtocol> *)destination;
            }
        }
    }
    return self;
}

- (void)perform
{
    if (self.masterViewController && self.childViewController && [self.childViewController respondsToSelector:@selector(position)]) {
        if (childViewController.position == HCDrawerSwipeChildPositionLeft) {
            if (masterViewController.isShowingLeftPanel) {
                [self resetPositions];
            } else {
                [self showLeftPanel];
            }
        } else if (childViewController.position == HCDrawerSwipeChildPositionRight) {
            if (masterViewController.isShowingRightPanel) {
                [self resetPositions];
            } else {
                [self showRightPanel];
            }
        }
    
        
        
    } else {
        NSLog(@"Don't Perform");
    }
    
}

- (void)resetPositions
{
    __block UIView *contentView = [masterViewController.view viewWithTag:kHCDrawerSwipeContentViewTag];
    if (contentView) {
        [UIView animateWithDuration:0.25 animations:^{
            contentView.frame = masterViewController.originalViewFrame;
        } completion:^(BOOL finished) {
            [childViewController willMoveToParentViewController:nil];
            [childViewController.view removeFromSuperview];
            [childViewController removeFromParentViewController];
            [childViewController didMoveToParentViewController:nil];
            childViewController = nil;
 
            for (UIView *subview in contentView.subviews) {
                [masterViewController.view addSubview:subview];
            }
            [contentView removeFromSuperview];
            contentView = nil;
            masterViewController.isShowingLeftPanel = NO;
            masterViewController.isShowingRightPanel = NO;
           
        }];
    }
}

- (void)showLeftPanel
{
    [self showPanelOnSide:HCDrawerSwipeChildPositionLeft];
    
}

- (void)showRightPanel
{
    [self showPanelOnSide:HCDrawerSwipeChildPositionRight];
}

- (void)showPanelOnSide:(HCDrawerSwipeChildPosition)side
{
    UIView *contentView = [[UIView alloc] initWithFrame:masterViewController.view.bounds];
    contentView.backgroundColor = masterViewController.view.backgroundColor;
    [masterViewController.view addSubview:contentView];
    [contentView setTag:kHCDrawerSwipeContentViewTag];
    for (UIView *subview in masterViewController.view.subviews) {
        if (![subview isEqual:contentView]) {
            [contentView addSubview:subview];
        }
    }
    [childViewController willMoveToParentViewController:masterViewController];
    CGRect frame = masterViewController.view.bounds;
    
    frame.origin.x = (side == HCDrawerSwipeChildPositionRight ? 40 : 0);
    frame.size.width -= 40;
    childViewController.view.frame = frame;
    
    [masterViewController.view insertSubview:childViewController.view atIndex:0];
    [masterViewController addChildViewController:childViewController];
    [childViewController didMoveToParentViewController:masterViewController];
    [UIView animateWithDuration:0.25 animations:^{
        CGRect finalFrame = masterViewController.view.frame;
        NSLog(@"%d", side);
        finalFrame.origin.x = (side == HCDrawerSwipeChildPositionRight ? 40 - finalFrame.size.width : finalFrame.size.width - 40);
        contentView.frame = finalFrame;
    } completion:^(BOOL finished) {
        if (side == HCDrawerSwipeChildPositionRight) {
            masterViewController.isShowingRightPanel = YES;
        } else {
            masterViewController.isShowingLeftPanel = YES;
        }
    }];

}

@end
