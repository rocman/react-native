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
#import "RCTNavigationBarTitleViewContainer.h"

@implementation RCTNavItem
{
  NSNumber *_rootId;
  RCTNavigationBarTitleViewContainer *_rootView;
  __weak RCTBridge *_bridge;
}

- (instancetype)initWithBridge:(RCTBridge *)bridge
{
  RCTAssertParam(bridge);
  
  if ((self = [super initWithFrame:CGRectZero])) {
    _bridge = bridge;
  }
  
  return self;
}

RCT_NOT_IMPLEMENTED(- (instancetype)initWithFrame:(CGRect)frame)
RCT_NOT_IMPLEMENTED(- (instancetype)initWithCoder:(NSCoder *)coder)

- (NSNumber *)rootId
{
  static NSInteger rootId_max = 0;
  if (_rootId) {
    return _rootId;
  }
  return _rootId = [[NSNumber alloc] initWithInteger:rootId_max++];
}

@synthesize backButtonItem = _backButtonItem;
@synthesize leftButtonItem = _leftButtonItem;
@synthesize rightButtonItem = _rightButtonItem;

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
  _navigationItem.titleView = _rootView;
}

- (void)setTitle:(NSString *)title
{
  _title = title;
  _navigationItem.title = title;
}

- (void)setTitleView:(NSNumber *)titleView
{
  if ((_titleView = titleView)) {
    NSDictionary *properties = @{@"component": self.titleView, @"id": self.rootId};
    if (_rootView) {
      RCTEventDispatcher *eventDispatcher = _rootView.bridge.eventDispatcher;
      [eventDispatcher sendAppEventWithName:@"NavigationBarTitleView#update"
                                       body:properties];
    }
    else {
      RCTBridge *bridgeForRoot = [((RCTBatchedBridge *)_bridge) parentBridge];
      _rootView = [[RCTNavigationBarTitleViewContainer alloc] initWithBridge:bridgeForRoot
                                           moduleName:@"NavigationBarTitleView"
                                    initialProperties:properties];
      _rootView.backgroundColor = [[UIColor alloc] initWithWhite:0 alpha:0];
    }
  }
  _navigationItem.titleView = _rootView;
}

- (void)setBackButtonTitle:(NSString *)backButtonTitle
{
  _backButtonTitle = backButtonTitle;
  _backButtonItem = nil;
  _navigationItem.backBarButtonItem = self.backButtonItem;
}

- (void)setBackButtonIcon:(UIImage *)backButtonIcon
{
  _backButtonIcon = backButtonIcon;
  _backButtonItem = nil;
  _navigationItem.backBarButtonItem = self.backButtonItem;
}

- (UIBarButtonItem *)backButtonItem
{
  if (!_backButtonItem) {
    if (_backButtonIcon) {
      _backButtonItem = [[UIBarButtonItem alloc] initWithImage:_backButtonIcon
                                                         style:UIBarButtonItemStylePlain
                                                        target:nil
                                                        action:nil];
    } else if (_backButtonTitle.length) {
      _backButtonItem = [[UIBarButtonItem alloc] initWithTitle:_backButtonTitle
                                                         style:UIBarButtonItemStylePlain
                                                        target:nil
                                                        action:nil];
    } else {
      _backButtonItem = nil;
    }
  }
  return _backButtonItem;
}

- (void)setLeftButtonTitle:(NSString *)leftButtonTitle
{
  _leftButtonTitle = leftButtonTitle;
  _leftButtonItem = nil;
  _navigationItem.leftBarButtonItem = self.leftButtonItem;
}

- (void)setLeftButtonIcon:(UIImage *)leftButtonIcon
{
  _leftButtonIcon = leftButtonIcon;
  _leftButtonItem = nil;
  _navigationItem.leftBarButtonItem = self.leftButtonItem;
}

- (UIBarButtonItem *)leftButtonItem
{
  if (!_leftButtonItem) {
    if (_leftButtonIcon) {
      _leftButtonItem =
      [[UIBarButtonItem alloc] initWithImage:_leftButtonIcon
                                       style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(handleNavLeftButtonTapped)];
    } else if (_leftButtonTitle.length) {
      _leftButtonItem =
      [[UIBarButtonItem alloc] initWithTitle:_leftButtonTitle
                                       style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(handleNavLeftButtonTapped)];
    } else {
      _leftButtonItem = nil;
    }
  }
  return _leftButtonItem;
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
  _rightButtonItem = nil;
  _navigationItem.rightBarButtonItem = self.rightButtonItem;
}

- (void)setRightButtonIcon:(UIImage *)rightButtonIcon
{
  _rightButtonIcon = rightButtonIcon;
  _rightButtonItem = nil;
  _navigationItem.rightBarButtonItem = self.rightButtonItem;
}

- (UIBarButtonItem *)rightButtonItem
{
  if (!_rightButtonItem) {
    if (_rightButtonIcon) {
      _rightButtonItem =
      [[UIBarButtonItem alloc] initWithImage:_rightButtonIcon
                                       style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(handleNavRightButtonTapped)];
    } else if (_rightButtonTitle.length) {
      _rightButtonItem =
      [[UIBarButtonItem alloc] initWithTitle:_rightButtonTitle
                                       style:UIBarButtonItemStylePlain
                                      target:self
                                      action:@selector(handleNavRightButtonTapped)];
    } else {
      _rightButtonItem = nil;
    }
  }
  return _rightButtonItem;
}

- (void)handleNavRightButtonTapped
{
  if (_onNavRightButtonTap) {
    _onNavRightButtonTap(nil);
  }
}

- (void)getReady:(void (^)())callback
{
  if (_rootView) {
    _rootView.onDidGetReady = callback;
    UIWindow *window = [UIApplication sharedApplication].windows[0];
    [window addSubview:_rootView];
    return;
  }
  callback();
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
