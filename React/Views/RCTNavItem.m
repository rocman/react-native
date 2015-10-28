/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "RCTNavItem.h"
#import "RCTBridge.h"
#import "RCTRootView.h"

@implementation RCTNavItem
{
  NSNumber *_rootId;
  __weak RCTBridge *_bridge;
}

- (instancetype)initWithBridge:(RCTBridge *)bridge
{
  RCTAssertParam(bridge);
  
  if ((self = [super init])) {
    _bridge = bridge;
  }
  
  return self;
}

- (NSNumber *)rootId
{
  static NSInteger rootId_max = 0;
  if (_rootId) {
    return _rootId;
  }
  return _rootId = [[NSNumber alloc] initWithInteger:rootId_max++];
}

- (void)setOnNavLeftButtonTap:(RCTBubblingEventBlock)onNavLeftButtonTap
{
  _onNavLeftButtonTap = onNavLeftButtonTap;
}

- (void)setNavigationBar:(UINavigationBar *)navigationBar
{
  _navigationBar = navigationBar;
  _navigationBar.barTintColor = self.barTintColor;
  _navigationBar.tintColor = self.tintColor;
  _navigationBar.translucent = self.translucent;
  _navigationBar.titleTextAttributes = self.titleTextColor ? @{
                                                               NSForegroundColorAttributeName: self.titleTextColor
                                                               } : nil;
  
  RCTFindNavBarShadowViewInView(_navigationBar).hidden = self.shadowHidden;
}

- (void)setNavigationItem:(UINavigationItem *)navigationItem
{
  if (_navigationItem == navigationItem) {
    return;
  }
  _navigationItem = navigationItem;
  _navigationItem.backBarButtonItem = self.backButtonItem;
  _navigationItem.leftBarButtonItem = self.leftButtonItem;
  _navigationItem.rightBarButtonItem = self.rightButtonItem;
  _navigationItem.title = self.title;
  if (self.titleView) {
    RCTRootView *root = (RCTRootView *)_navigationItem.titleView;
    if (root) {
      [root.bridge.eventDispatcher sendAppEventWithName:@"NavigationBarTitleView#update"
                                                   body:@{@"component": self.titleView, @"id": self.rootId}];
    }
    else {
      root = [[RCTRootView alloc] initWithBridge:[((RCTBatchedBridge *)_bridge) parentBridge]
                                      moduleName:@"NavigationBarTitleView"
                               initialProperties:@{@"component": self.titleView, @"id": self.rootId}];
      root.frame = CGRectMake(0, 0, 800, 44);
      root.backgroundColor = [[UIColor alloc] initWithWhite:0 alpha:0];
      _navigationItem.titleView = root;
    }
  }
  else {
    _navigationItem.titleView = nil;
  }
}

- (void)setTitle:(NSString *)title
{
  _title = title;
  _navigationItem.title = title;
}

- (void)setTitleView:(NSNumber *)titleView
{
  _titleView = titleView;
  if (_navigationItem) {
    if (self.titleView) {
      RCTRootView *root = (RCTRootView *)_navigationItem.titleView;
      if (root) {
        [root.bridge.eventDispatcher sendAppEventWithName:@"NavigationBarTitleView#update"
                                                     body:@{@"component": self.titleView, @"id": self.rootId}];
      }
      else {
        root = [[RCTRootView alloc] initWithBridge:[((RCTBatchedBridge *)_bridge) parentBridge]
                                        moduleName:@"NavigationBarTitleView"
                                 initialProperties:@{@"component": self.titleView, @"id": self.rootId}];
        root.frame = CGRectMake(0, 0, 800, 44);
        root.backgroundColor = [[UIColor alloc] initWithWhite:0 alpha:0];
        _navigationItem.titleView = root;
      }
    }
    else {
      _navigationItem.titleView = nil;
    }
  }
}

- (void)setBackButtonTitle:(NSString *)backButtonTitle
{
  _backButtonTitle = backButtonTitle;
  if (_navigationItem.backBarButtonItem) {
    if (_navigationItem.backBarButtonItem.title) {
      if (_backButtonTitle && _backButtonTitle.length) {
        _navigationItem.backBarButtonItem.title = _backButtonTitle;
        return;
      }
      _navigationItem.backBarButtonItem = nil;
    }
  }
  [self backButtonItem];
}

- (void)setBackButtonIcon:(UIImage *)backButtonIcon
{
  _backButtonIcon = backButtonIcon;
  if (_navigationItem.backBarButtonItem) {
    if (_navigationItem.backBarButtonItem.image) {
      if (_backButtonIcon) {
        _navigationItem.backBarButtonItem.image = _backButtonIcon;
        return;
      }
      _navigationItem.backBarButtonItem = nil;
    }
  }
  [self backButtonItem];
}

- (UIBarButtonItem *)backButtonItem
{
  if (!_navigationItem.backBarButtonItem) {
    if (_navigationItem.backBarButtonItem) {
      _navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:self.backButtonIcon
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:nil
                                                                          action:nil];
    } else if (self.backButtonTitle.length) {
      _navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:self.backButtonTitle
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:nil
                                                                          action:nil];
    } else {
      _navigationItem.backBarButtonItem = nil;
    }
  }
  return _navigationItem.backBarButtonItem;
}

- (void)setLeftButtonTitle:(NSString *)leftButtonTitle
{
  _leftButtonTitle = leftButtonTitle;
  if (_navigationItem.leftBarButtonItem) {
    if (_navigationItem.leftBarButtonItem.title) {
      if (_leftButtonTitle && _leftButtonTitle.length) {
        _navigationItem.leftBarButtonItem.title = _leftButtonTitle;
        return;
      }
      _navigationItem.leftBarButtonItem = nil;
    }
  }
  [self leftButtonItem];
}

- (void)setLeftButtonIcon:(UIImage *)leftButtonIcon
{
  _leftButtonIcon = leftButtonIcon;
  if (_navigationItem.leftBarButtonItem) {
    if (_navigationItem.leftBarButtonItem.image) {
      if (_leftButtonIcon) {
        _navigationItem.leftBarButtonItem.image = _leftButtonIcon;
        return;
      }
      _navigationItem.leftBarButtonItem = nil;
    }
  }
  [self leftButtonItem];
}

- (UIBarButtonItem *)leftButtonItem
{
  if (!_navigationItem.rightBarButtonItem) {
    if (self.leftButtonIcon) {
      _navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:self.leftButtonIcon
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(handleNavLeftButtonTapped)];
    }
    else if (self.leftButtonTitle && self.leftButtonTitle.length) {
      _navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:self.leftButtonTitle
                                                                           style:UIBarButtonItemStylePlain
                                                                          target:self
                                                                          action:@selector(handleNavLeftButtonTapped)];
    }
    else {
      _navigationItem.leftBarButtonItem = nil;
    }
  }
  return _navigationItem.leftBarButtonItem;
}

- (void)handleNavLeftButtonTapped
{
  if (_onNavLeftButtonTap) {
    _onNavLeftButtonTap(nil);
  }
}

- (void)setRightButtonTitle:(NSString *)rightButtonTitle
{
  _rightButtonTitle = rightButtonTitle;
  if (_navigationItem.rightBarButtonItem) {
    if (_navigationItem.rightBarButtonItem.title) {
      if (_rightButtonTitle && _rightButtonTitle.length) {
        _navigationItem.rightBarButtonItem.title = _rightButtonTitle;
        return;
      }
      _navigationItem.rightBarButtonItem = nil;
    }
  }
  [self rightButtonItem];
}

- (void)setRightButtonIcon:(UIImage *)rightButtonIcon
{
  _rightButtonIcon = rightButtonIcon;
  if (_navigationItem.rightBarButtonItem) {
    if (_navigationItem.rightBarButtonItem.image) {
      if (_rightButtonIcon) {
        _navigationItem.rightBarButtonItem.image = _rightButtonIcon;
        return;
      }
      _navigationItem.rightBarButtonItem = nil;
    }
  }
  [self rightButtonItem];
}

- (UIBarButtonItem *)rightButtonItem
{
  if (!_navigationItem.rightBarButtonItem) {
    if (self.rightButtonIcon) {
      _navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:self.rightButtonIcon
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(handleNavRightButtonTapped)];
    }
    else if (self.rightButtonTitle && self.rightButtonTitle.length) {
      _navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:self.rightButtonTitle
                                                                            style:UIBarButtonItemStylePlain
                                                                           target:self
                                                                           action:@selector(handleNavRightButtonTapped)];
    }
    else {
      _navigationItem.rightBarButtonItem = nil;
    }
  }
  return _navigationItem.rightBarButtonItem;
}

- (void)handleNavRightButtonTapped
{
  if (_onNavRightButtonTap) {
    _onNavRightButtonTap(nil);
  }
}

static UIView *RCTFindNavBarShadowViewInView(UIView *view)
{
  if ([view isKindOfClass:[UIImageView class]] && view.bounds.size.height <= 1) {
    return view;
  }
  for (UIView *subview in view.subviews) {
    UIView *shadowView = RCTFindNavBarShadowViewInView(subview);
    if (shadowView) {
      return shadowView;
    }
  }
  return nil;
}

@end
