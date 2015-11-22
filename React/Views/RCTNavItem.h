/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import <UIKit/UIKit.h>

#import "RCTComponent.h"
#import "RCTNavItemManager.h"
#import "UIView+React.h"

@interface RCTNavItem : UIView

- (instancetype)initWithManager:(RCTNavItemManager *)manager NS_DESIGNATED_INITIALIZER;
- (void)getReady:(void(^)())callback;

@property (nonatomic, weak)     UINavigationBar *navigationBar;
@property (nonatomic, weak)     UINavigationItem *navigationItem;

@property (nonatomic, copy)     NSString *title;
@property (nonatomic, copy)     NSNumber *titleView;

@property (nonatomic, strong)   UIImage  *leftButtonIcon;
@property (nonatomic, copy)     NSString *leftButtonTitle;

@property (nonatomic, strong)   UIImage  *rightButtonIcon;
@property (nonatomic, copy)     NSString *rightButtonTitle;

@property (nonatomic, strong)   UIImage  *backButtonIcon;
@property (nonatomic, copy)     NSString *backButtonTitle;

@property (nonatomic, assign)   BOOL hidesBottomBarWhenPushed;
@property (nonatomic, assign)   BOOL navigationBarHidden;
@property (nonatomic, assign)   BOOL shadowHidden;

@property (nonatomic, copy)     UIColor *tintColor;
@property (nonatomic, copy)     UIColor *barTintColor;
@property (nonatomic, copy)     UIColor *titleTextColor;

@property (nonatomic, assign)   BOOL translucent;

@property (nonatomic, readonly) UIBarButtonItem *backButtonItem;
@property (nonatomic, readonly) UIBarButtonItem *leftButtonItem;
@property (nonatomic, readonly) UIBarButtonItem *rightButtonItem;

@property (nonatomic, copy)     RCTBubblingEventBlock onNavLeftButtonTap;
@property (nonatomic, copy)     RCTBubblingEventBlock onNavRightButtonTap;

@end
