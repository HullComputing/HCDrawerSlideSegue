//
//  HCDrawerSwipeMasterViewController.h
//  HCDrawerSwipeSegue
//
//  Created by Aaron Hull on 6/23/14.
//  Copyright (c) 2014 Hull Computing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HCDrawerSwipeChildViewController, HCDrawerSwipeChildCenterViewController;

typedef NS_ENUM(NSInteger, HCDrawerSwipeChildPosition) {
    HCDrawerSwipeChildPositionLeft = 1,
    HCDrawerSwipeChildPositionRight,
    HCDrawerSwipeChildPositionCenterInContent,
    HCDrawerSwipeChildPositionCenterModally
};

@interface HCDrawerSwipeMasterViewController : UIViewController

+ (HCDrawerSwipeMasterViewController *)masterViewControllerFromViewController:(UIViewController *)viewController;

- (CGFloat)bufferForLeftSwipe;
- (CGFloat)bufferForRightSwipe;

@property (nonatomic) CGRect originalViewFrame;
@property (nonatomic, strong) IBOutlet UIView *hcds_contentView;
@property (nonatomic, readonly) HCDrawerSwipeChildViewController *sideChildViewController;

- (void)presentCenterViewController:(HCDrawerSwipeChildCenterViewController *)centerViewController withUserInfo:(NSDictionary *)userInfo;
- (void)performSegueWithIdentifier:(NSString *)identifier userInfo:(NSDictionary *)userInfo;

@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;
@end
