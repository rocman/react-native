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

- (instancetype)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame])) {
    [self setAlpha:0];
  }
  return self;
}

- (void)layoutSubviews
{
  [super layoutSubviews];
  
  UIView *view = self.superview;
  while (view) {
    if ([view isKindOfClass:[RCTNavigationBarTitleViewContainer class]]) {
      RCTNavigationBarTitleViewContainer *container = (RCTNavigationBarTitleViewContainer *)view;
      CGRect temp = container.frame;
//      temp.origin = CGPointZero;
      temp.size = self.frame.size;
      container.frame = temp;
      [container didGetReady];
      [self setAlpha:1];
      return;
    }
    view = view.superview;
  }
//  [self setAlpha:1];
}

@end
