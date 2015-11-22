/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 */

#import "RCTNavItemManager.h"

#import "RCTConvert.h"
#import "RCTNavItem.h"

@interface RCTNavItemManager ()
{
  NSUInteger _nextCallbackKey;
}

@property NSMutableDictionary<NSNumber *, void (^)()> *callbacks;

@end

@implementation RCTNavItemManager

RCT_EXPORT_MODULE()

- (instancetype)init
{
  if ((self = [super init])) {
    _nextCallbackKey = 1;
    _callbacks = [NSMutableDictionary<NSNumber *, void (^)()> new];
  }
  return self;
}

- (UIView *)view
{
  return [[RCTNavItem alloc] initWithManager:self];
}

- (NSNumber *)markCallback:(void (^)())callback
{
  NSNumber *key = [NSNumber numberWithUnsignedInteger:_nextCallbackKey++];
  [_callbacks setObject:callback forKey:key];
  return key;
}

RCT_EXPORT_METHOD(invokeCallback:(nonnull NSNumber *)key)
{
  void (^callback)() = [_callbacks objectForKey:key];
  [_callbacks removeObjectForKey:key];
  if (callback) {
    dispatch_async(dispatch_get_main_queue(), callback);
  }
}

RCT_EXPORT_VIEW_PROPERTY(hidesBottomBarWhenPushed, BOOL)
RCT_EXPORT_VIEW_PROPERTY(navigationBarHidden, BOOL)
RCT_EXPORT_VIEW_PROPERTY(shadowHidden, BOOL)
RCT_EXPORT_VIEW_PROPERTY(tintColor, UIColor)
RCT_EXPORT_VIEW_PROPERTY(barTintColor, UIColor)
RCT_EXPORT_VIEW_PROPERTY(translucent, BOOL)

RCT_EXPORT_VIEW_PROPERTY(title, NSString)
RCT_EXPORT_VIEW_PROPERTY(titleTextColor, UIColor)
RCT_EXPORT_VIEW_PROPERTY(titleView, NSNumber)

RCT_EXPORT_VIEW_PROPERTY(backButtonIcon, UIImage)
RCT_EXPORT_VIEW_PROPERTY(backButtonTitle, NSString)

RCT_EXPORT_VIEW_PROPERTY(leftButtonTitle, NSString)
RCT_EXPORT_VIEW_PROPERTY(leftButtonIcon, UIImage)

RCT_EXPORT_VIEW_PROPERTY(rightButtonIcon, UIImage)
RCT_EXPORT_VIEW_PROPERTY(rightButtonTitle, NSString)

RCT_EXPORT_VIEW_PROPERTY(onNavLeftButtonTap, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onNavRightButtonTap, RCTBubblingEventBlock)

@end
