//
//  HCDrawerSwipeSegue.h
//  HCDrawerSwipeSegue
//
//  Created by Aaron Hull on 3/20/14.
//  Copyright (c) 2014 Hull Computing. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HCDrawerSwipeChildPosition) {
    HCDrawerSwipeChildPositionLeft = 1,
    HCDrawerSwipeChildPositionRight
};

@protocol HCDrawerSwipeMasterViewControllerProtocol <NSObject>

@required
@property (nonatomic, readonly) NSArray *childDrawerViewControllers;

@end

@protocol HCDrawerSwipeChildViewControllerProtocol <NSObject>

@required
@property (nonatomic, readonly) UIViewController<HCDrawerSwipeMasterViewControllerProtocol> *masterViewController;
@property (nonatomic) HCDrawerSwipeChildPosition position;

@end

@interface HCDrawerSwipeSegue : UIStoryboardSegue



@end
