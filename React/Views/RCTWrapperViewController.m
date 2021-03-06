/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "RCTWrapperViewController.h"

#import <UIKit/UIScrollView.h>

#import "RCTEventDispatcher.h"
#import "RCTNavItem.h"
#import "RCTTabBarItem.h"
#import "RCTUtils.h"
#import "RCTViewControllerProtocol.h"
#import "UIView+React.h"
#import "RCTAutoInsetsProtocol.h"

@implementation RCTWrapperViewController
{
  UIView *_wrapperView;
  UIView *_contentView;
  RCTEventDispatcher *_eventDispatcher;
  CGFloat _previousTopLayoutLength;
  CGFloat _previousBottomLayoutLength;
}

@synthesize currentTopLayoutGuide = _currentTopLayoutGuide;
@synthesize currentBottomLayoutGuide = _currentBottomLayoutGuide;

- (instancetype)initWithContentView:(UIView *)contentView
{
  RCTAssertParam(contentView);

  if ((self = [super initWithNibName:nil bundle:nil])) {
    _contentView = contentView;
    self.automaticallyAdjustsScrollViewInsets = NO;
  }
  return self;
}

- (instancetype)initWithNavItem:(RCTNavItem *)navItem
{
  if ((self = [self initWithContentView:navItem])) {
    _navItem = navItem;
    self.hidesBottomBarWhenPushed = _navItem.hidesBottomBarWhenPushed;
  }
  return self;
}

- (instancetype)initWithTabItem:(RCTTabBarItem *)tabItem
{
  if ((self = [self initWithContentView:tabItem])) {
    _tabItem = tabItem;
  }
  return self;
}

RCT_NOT_IMPLEMENTED(- (instancetype)initWithNibName:(NSString *)nn bundle:(NSBundle *)nb)
RCT_NOT_IMPLEMENTED(- (instancetype)initWithCoder:(NSCoder *)aDecoder)

- (void)viewWillLayoutSubviews
{
  [super viewWillLayoutSubviews];

  _currentTopLayoutGuide = self.topLayoutGuide;
  _currentBottomLayoutGuide = self.bottomLayoutGuide;
}

static BOOL RCTFindScrollViewAndRefreshContentInsetInView(UIView *view)
{
  if ([view conformsToProtocol:@protocol(RCTAutoInsetsProtocol)]) {
    [(id <RCTAutoInsetsProtocol>) view refreshContentInset];
    return YES;
  }
  for (UIView *subview in view.subviews) {
    if (RCTFindScrollViewAndRefreshContentInsetInView(subview)) {
      return YES;
    }
  }
  return NO;
}

- (void)viewDidLayoutSubviews
{
  [super viewDidLayoutSubviews];

  if (_previousTopLayoutLength != _currentTopLayoutGuide.length ||
      _previousBottomLayoutLength != _currentBottomLayoutGuide.length) {
    RCTFindScrollViewAndRefreshContentInsetInView(_contentView);
    _previousTopLayoutLength = _currentTopLayoutGuide.length;
    _previousBottomLayoutLength = _currentBottomLayoutGuide.length;
  }
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];

  // TODO: find a way to make this less-tightly coupled to navigation controller
  if ([self.parentViewController isKindOfClass:[UINavigationController class]])
  {
    [self.navigationController
     setNavigationBarHidden:_navItem.navigationBarHidden
     animated:animated];
    
    _navItem.navigationBar = self.navigationController.navigationBar;
    _navItem.navigationItem = self.navigationItem;
  }
  
  // TODO: find a way to make this less-tightly coupled to tab bar controller
  if ([self.parentViewController isKindOfClass:[UITabBarController class]])
  {
    if (_tabItem.onWillAppear) {
      _tabItem.onWillAppear(nil);
    }
  }
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  // TODO: find a way to make this less-tightly coupled to tab bar controller
  if ([self.parentViewController isKindOfClass:[UITabBarController class]])
  {
    if (_tabItem.onDidAppear) {
      _tabItem.onDidAppear(nil);
    }
  }
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  
  // TODO: find a way to make this less-tightly coupled to tab bar controller
  if ([self.parentViewController isKindOfClass:[UITabBarController class]])
  {
    if (_tabItem.onWillDisappear) {
      _tabItem.onWillDisappear(nil);
    }
  }
}

- (void)viewDidDisappear:(BOOL)animated
{
  [super viewDidDisappear:animated];
  
  // TODO: find a way to make this less-tightly coupled to tab bar controller
  if ([self.parentViewController isKindOfClass:[UITabBarController class]])
  {
    if (_tabItem.onDidDisappear) {
      _tabItem.onDidDisappear(nil);
    }
  }
}

- (void)loadView
{
  // Add a wrapper so that the wrapper view managed by the
  // UINavigationController doesn't end up resetting the frames for
  //`contentView` which is a react-managed view.
  _wrapperView = [[UIView alloc] initWithFrame:_contentView.bounds];
  [_wrapperView addSubview:_contentView];
  self.view = _wrapperView;
}

- (void)didMoveToParentViewController:(UIViewController *)parent
{
  // There's no clear setter for navigation controllers, but did move to parent
  // view controller provides the desired effect. This is called after a pop
  // finishes, be it a swipe to go back or a standard tap on the back button
  [super didMoveToParentViewController:parent];
  if (parent == nil || [parent isKindOfClass:[UINavigationController class]]) {
    [self.navigationListener wrapperViewController:self
                     didMoveToNavigationController:(UINavigationController *)parent];
  }
}

@end
