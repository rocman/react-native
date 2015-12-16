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
  UIView *superview = view.superview;
  
  while (view) {
    if ([view isKindOfClass:[RCTNavigationBarTitleViewContainer class]]) {
      RCTNavigationBarTitleViewContainer *container = (RCTNavigationBarTitleViewContainer *)view;
      [container didGetReady];
      return;
    }
    
    UIView *nextSuperview = superview.superview;
    if ([nextSuperview isKindOfClass:[UINavigationBar class]]) {
      CGSize size = superview.frame.size;
      if (size.width || size.height) {
        return;
      }
    }
    
    CGRect temp = view.frame;
    temp.origin = CGPointZero;
    view.frame = temp;
    superview.frame = temp;
    
    view = superview;
    superview = nextSuperview;
  }
}

@end
