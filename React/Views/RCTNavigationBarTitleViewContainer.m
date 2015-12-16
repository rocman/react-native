/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "RCTNavigationBarTitleViewContainer.h"

@implementation RCTNavigationBarTitleViewContainer

- (void)setNavigationItem:(UINavigationItem *)navigationItem
{
  _navigationItem = navigationItem;
  _navigationItem.titleView = self;
}

- (void)didGetReady
{
  if (_onDidGetReady) {
    _onDidGetReady();
    _onDidGetReady = nil;
  }
  _navigationItem.titleView = self;
}

@end
