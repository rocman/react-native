/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "RCTNavigationBarTitleViewContainer.h"
#import "RCTNavigationBarTitleViewWrapper.h"

@implementation RCTNavigationBarTitleViewWrapper

- (void)layoutSubviews
{
  [super layoutSubviews];
  
  UIView *view = self;
  while (view) {
    UIView *superview = view.superview;
    CGRect temp = superview.frame;
    temp.origin = CGPointZero;
    temp.size = view.frame.size;
    view.frame = temp;
    superview.frame = temp;
    if ([superview isKindOfClass:[RCTNavigationBarTitleViewContainer class]]) {
      RCTNavigationBarTitleViewContainer *container = (RCTNavigationBarTitleViewContainer *)superview;
      [container didGetReady];
      return;
    }
    view = superview;
  }
}

@end
