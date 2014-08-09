//
//  HCDrawerSwipeChildViewController.m
//  HCDrawerSwipeSegue
//
//  Created by Aaron Hull on 6/23/14.
//  Copyright (c) 2014 Hull Computing. All rights reserved.
//

#import "HCDrawerSwipeChildViewController.h"
#import <objc/runtime.h>

@interface HCDrawerSwipeChildViewController ()

@property (nonatomic, readwrite, assign) HCDrawerSwipeMasterViewController *masterViewController;
@end

@implementation HCDrawerSwipeChildViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end

@implementation HCDrawerSwipeChildSideViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        assert((self.position == HCDrawerSwipeChildPositionLeft || self.position == HCDrawerSwipeChildPositionRight));// "Position for Child View Controller must be left or right");
    }
    return self;
}

@end

@implementation HCDrawerSwipeChildCenterViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        assert((self.position == HCDrawerSwipeChildPositionCenterInContent || self.position == HCDrawerSwipeChildPositionCenterModally)); //"Position for Child View Controller must be left or right");
    }
    return self;
}

@end