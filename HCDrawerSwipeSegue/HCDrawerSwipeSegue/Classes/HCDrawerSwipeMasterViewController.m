//
//  HCDrawerSwipeMasterViewController.m
//  HCDrawerSwipeSegue
//
//  Created by Aaron Hull on 6/23/14.
//  Copyright (c) 2014 Hull Computing. All rights reserved.
//

#import "HCDrawerSwipeMasterViewController.h"
#import "HCDrawerSwipeSegue.h"
#import "HCDrawerSwipeChildViewController.h"

static NSInteger kHCDrawerSwipeContentViewTag = 45677890;

@interface HCDrawerSwipeSegue (Private)
@property (nonatomic, getter=isInitialTest) BOOL initialTest;
@end

@interface HCDrawerSwipeChildViewController (Private)
@property (nonatomic, strong) HCDrawerSwipeMasterViewController *masterViewController;
@end



@interface HCDrawerSwipeMasterViewController () {
    NSString *segueIdentifierForRotation;
    BOOL isInitialLeftSegueTest;
    BOOL isInitialRightSegueTest;
}
- (HCDrawerSwipeChildPosition)showingPanelInPosition;
- (void)showPanelOnSide:(HCDrawerSwipeChildPosition)side;
- (void)resetPositions;
//@property (nonatomic, strong) NSMutableArray *modalViewControllers;
@property (nonatomic, strong) UIButton *resetViewsButton;
@property (nonatomic, readwrite) HCDrawerSwipeChildViewController *sideChildViewController;
@property (nonatomic, strong) NSDictionary *userInfo;
@end

@implementation HCDrawerSwipeMasterViewController
//@synthesize modalViewControllers = _modalViewControllers;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
//        _modalViewControllers = [NSMutableArray array];
        self.leftSwipeGestureRecognizer =  [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
        self.rightSwipeGestureRecognizer =  [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    }
    return self;
}

+ (HCDrawerSwipeMasterViewController *)masterViewControllerFromViewController:(UIViewController *)viewController
{
    HCDrawerSwipeMasterViewController *masterViewController = nil;
    if (viewController) {
        if ([viewController.parentViewController isKindOfClass:[HCDrawerSwipeMasterViewController class]]) {
            masterViewController = (HCDrawerSwipeMasterViewController *)viewController.parentViewController;
        } else if ([viewController.presentingViewController isKindOfClass:[HCDrawerSwipeMasterViewController class]]) {
            masterViewController = (HCDrawerSwipeMasterViewController *)viewController.presentingViewController;
        } else if (viewController.parentViewController) {
            masterViewController = [self masterViewControllerFromViewController:viewController.parentViewController];
        } else if (viewController.presentingViewController) {
            masterViewController = [self masterViewControllerFromViewController:viewController.presentingViewController];
        }
    }
    return masterViewController;
}

- (void)viewDidAppear:(BOOL)animated
//- (void)viewDidLoad
{
    [super viewDidAppear:animated];
//    [super viewDidLoad];
    isInitialLeftSegueTest = YES;
    isInitialRightSegueTest = YES;
    
    @try {
        [self performSegueWithIdentifier:kHCDSSegueIdentifierLeftSwipe sender:nil];
    }
    @catch (NSException *exception) {
        NSLog(@"No left swipe");
    }
    @finally {
        @try {
            [self performSegueWithIdentifier:kHCDSSegueIdentifierRightSwipe sender:nil];
        }
        @catch (NSException *exception) {
            
            NSLog(@"No right swipe");
        }
        @finally {
        }
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if (isInitialLeftSegueTest && [identifier isEqualToString:kHCDSSegueIdentifierLeftSwipe]) {
        return NO;
    }
    if (isInitialRightSegueTest && [identifier isEqualToString:kHCDSSegueIdentifierRightSwipe]) {
        return NO;
    }
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    if ([self showingPanelInPosition] == HCDrawerSwipeChildPositionLeft) {
        segueIdentifierForRotation = kHCDSSegueIdentifierLeftSwipe;
    } else if ([self showingPanelInPosition] == HCDrawerSwipeChildPositionRight) {
        segueIdentifierForRotation = kHCDSSegueIdentifierRightSwipe;
    }
    
    if (segueIdentifierForRotation) {
        [self performSegueWithIdentifier:segueIdentifierForRotation sender:nil];
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    if (segueIdentifierForRotation) {
        [self performSegueWithIdentifier:segueIdentifierForRotation sender:nil];
        segueIdentifierForRotation = nil;
    }
}

- (void)prepareForSegue:(HCDrawerSwipeSegue *)segue sender:(id)sender
{
    if (self.userInfo && [segue.destinationViewController respondsToSelector:@selector(setUserInfo:)]) {
        [(HCDrawerSwipeChildCenterViewController *)segue.destinationViewController setUserInfo:[self.userInfo copy]];
        self.userInfo = nil;
        
    }
    if (isInitialLeftSegueTest) {
        if ([segue.identifier isEqualToString:kHCDSSegueIdentifierLeftSwipe]) {
            isInitialLeftSegueTest = NO;
            segue.initialTest = YES;
            [self addGestureRecognizerForSwipe:HCDrawerSwipeChildPositionLeft];
        }
    } else if (isInitialRightSegueTest) {
        if ([segue.identifier isEqualToString:kHCDSSegueIdentifierRightSwipe]) {
            isInitialRightSegueTest = NO;
            segue.initialTest = YES;
            [self addGestureRecognizerForSwipe:HCDrawerSwipeChildPositionRight];
        }
    }
    if (![segue isKindOfClass:[HCDrawerSwipeSegue class]]) {
        [self resetPositions];
    }
}

- (void)performSegueWithIdentifier:(NSString *)identifier userInfo:(NSDictionary *)userInfo
{
    self.userInfo = userInfo;
    [self performSegueWithIdentifier:identifier sender:nil];
}

- (void)addGestureRecognizerForSwipe:(HCDrawerSwipeChildPosition)side
{
    UISwipeGestureRecognizer *swipeGesture = (side == HCDrawerSwipeChildPositionLeft ? self.rightSwipeGestureRecognizer : self.leftSwipeGestureRecognizer);
//    swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    [swipeGesture setDirection:(side == HCDrawerSwipeChildPositionLeft ? UISwipeGestureRecognizerDirectionRight : UISwipeGestureRecognizerDirectionLeft)];
    [self.view addGestureRecognizer:swipeGesture];
}


- (void)didSwipe:(UISwipeGestureRecognizer *)sender
{
    [self performSegueWithIdentifier:(sender.direction == UISwipeGestureRecognizerDirectionLeft ? kHCDSSegueIdentifierRightSwipe : kHCDSSegueIdentifierLeftSwipe) sender:nil];
}

- (CGFloat)bufferForLeftSwipe
{
    // Method should be overridden by subclasses
    return 0;
}

- (CGFloat)bufferForRightSwipe
{
    // Method should be overridden by subclasses
    return 0;
}

- (void)resetPositions
{
    if (self.resetViewsButton) {
        [self.resetViewsButton removeFromSuperview];
        self.resetViewsButton = nil;
    }
    __block UIView *contentView = [self.view viewWithTag:kHCDrawerSwipeContentViewTag];
    if (contentView) {
        [UIView animateWithDuration:0.25 animations:^{
            contentView.frame = self.originalViewFrame;
        } completion:^(BOOL finished) {
            [self.sideChildViewController willMoveToParentViewController:nil];
            [self.sideChildViewController.view removeFromSuperview];
            [self.sideChildViewController removeFromParentViewController];
            [self.sideChildViewController didMoveToParentViewController:nil];
            self.sideChildViewController = nil;
            
            for (UIView *subview in contentView.subviews) {
                [self.view addSubview:subview];
            }
            [contentView removeFromSuperview];
            contentView = nil;
            
        }];
    }
}

- (void)showPanelOnSide:(HCDrawerSwipeChildPosition)side
{
    UIView *contentView = [[UIView alloc] initWithFrame:self.view.bounds];
    contentView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:contentView];
    [contentView setTag:kHCDrawerSwipeContentViewTag];
    for (UIView *subview in self.view.subviews) {
        if (![subview isEqual:contentView]) {
            [contentView addSubview:subview];
        }
    }
    [contentView.layer setShadowColor:[[UIColor grayColor] CGColor]];
    [contentView.layer setShadowRadius:5.0];
    [contentView.layer setShadowOpacity:1.0];
    [self.sideChildViewController willMoveToParentViewController:self];
    
    
    CGRect frame = self.view.bounds;
    
    frame.origin.x = (side == HCDrawerSwipeChildPositionRight ? [self bufferForRightSwipe] : 0);
    frame.size.width -= (side == HCDrawerSwipeChildPositionRight ? [self bufferForRightSwipe] : [self bufferForLeftSwipe]);
    self.sideChildViewController.view.frame = frame;
    [self.sideChildViewController.view layoutIfNeeded];
    [self.view insertSubview:self.sideChildViewController.view atIndex:0];
    [self addChildViewController:self.sideChildViewController];
    [self.sideChildViewController setMasterViewController:self];
    [self.sideChildViewController didMoveToParentViewController:self];
    if (!self.resetViewsButton) {
        self.resetViewsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.resetViewsButton.backgroundColor = [UIColor clearColor];
        self.resetViewsButton.frame = contentView.bounds;
        [contentView addSubview:self.resetViewsButton];
        [self.resetViewsButton addTarget:self action:@selector(resetViewsFromButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    [contentView layoutIfNeeded];
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.25 animations:^{
        CGRect finalFrame = self.view.bounds;
        
        finalFrame.origin.x = (side == HCDrawerSwipeChildPositionRight ? [self bufferForRightSwipe] - finalFrame.size.width : finalFrame.size.width - [self bufferForLeftSwipe]);
        contentView.frame = finalFrame;
    } completion:^(BOOL finished) {
        [contentView updateConstraintsIfNeeded];
        [self.view updateConstraintsIfNeeded];
        [self.view layoutIfNeeded];
    }];
    
}

- (void)resetViewsFromButton:(UIButton *)sender
{
    if (self.showingPanelInPosition == HCDrawerSwipeChildPositionRight) {
        [self performSegueWithIdentifier:kHCDSSegueIdentifierLeftSwipe sender:nil];
    } else if (self.showingPanelInPosition == HCDrawerSwipeChildPositionLeft) {
        [self performSegueWithIdentifier:kHCDSSegueIdentifierRightSwipe sender:nil];
    }
}

- (HCDrawerSwipeChildPosition)showingPanelInPosition
{
    HCDrawerSwipeChildPosition position = 0;
    if (self) {
        if (self.view) {
            UIView *contentView = [self.view viewWithTag:kHCDrawerSwipeContentViewTag];
            if (contentView) {
                if (contentView.frame.origin.x != 0) {
                    position = (contentView.frame.origin.x < 0 ? HCDrawerSwipeChildPositionRight : HCDrawerSwipeChildPositionLeft);
                }
            }
        }
    }
    return position;
}

- (CGFloat)hcds_bufferForLeftSwipe
{
    CGFloat buffer = 40.0;
    if ([self respondsToSelector:@selector(bufferForLeftSwipe)]) {
        buffer = [self bufferForLeftSwipe];
    }
    return buffer;
}

- (CGFloat)hcds_bufferForRightSwipe
{
    
    CGFloat buffer = 40.0;
    if ([self respondsToSelector:@selector(bufferForRightSwipe)]) {
        buffer = [self bufferForRightSwipe];
    }
    return buffer;
}

- (void)presentCenterViewController:(HCDrawerSwipeChildCenterViewController *)centerViewController withUserInfo:(NSDictionary *)userInfo
{
    if ([centerViewController isKindOfClass:[HCDrawerSwipeChildCenterViewController class]]) {
        if ([userInfo isKindOfClass:[NSDictionary class]]) {
            centerViewController.userInfo = userInfo;
        }
        centerViewController.masterViewController = self;
        if ([self showingPanelInPosition]) {
            [self resetPositions];
        }

        
        
        if (centerViewController.position == HCDrawerSwipeChildPositionCenterInContent) {
            if (self.presentedViewController) {
//                [_modalViewControllers removeObject:self.presentedViewController];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            for (HCDrawerSwipeChildCenterViewController *childViewController in self.childViewControllers) {
                if ([childViewController isKindOfClass:[HCDrawerSwipeChildCenterViewController class]]) {
                    if (childViewController.position == HCDrawerSwipeChildPositionCenterInContent) {
                        [childViewController willMoveToParentViewController:nil];
                        [childViewController.view removeFromSuperview];
                        [childViewController removeFromParentViewController];
                        [childViewController didMoveToParentViewController:nil];
                        [self.hcds_contentView layoutIfNeeded];
                    } else if (childViewController.position == HCDrawerSwipeChildPositionCenterModally) {
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }
                }
            }
            [centerViewController willMoveToParentViewController:self];
            
            centerViewController.view.frame = self.hcds_contentView.bounds;
            [centerViewController.view layoutIfNeeded];
            [self.hcds_contentView addSubview:centerViewController.view];
            [self.hcds_contentView.superview bringSubviewToFront:self.hcds_contentView];
            [self addChildViewController:centerViewController];
            [centerViewController setMasterViewController:self];
            [centerViewController didMoveToParentViewController:self];
        } else if (centerViewController.position == HCDrawerSwipeChildPositionCenterModally) {
            [self presentViewController:centerViewController animated:YES completion:^{
//                [_modalViewControllers addObject:centerViewController];
            }];
        }
        
    }
}

- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion
{
//    if ([_modalViewControllers containsObject:self.presentedViewController]) {
//        [_modalViewControllers removeObject:self.presentedViewController];
//    }
    [super dismissViewControllerAnimated:flag completion:completion];
}

@end
