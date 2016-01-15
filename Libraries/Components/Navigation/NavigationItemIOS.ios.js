/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 *
 * @providesModule NavigationItemIOS
 * @noflow
 */
import AppRegistry from 'AppRegistry';
import React from 'React';
import StaticContainer from 'StaticContainer.react';
import StyleSheet from 'StyleSheet';
import Text from 'Text';
import View from 'View';

import requireNativeComponent from 'requireNativeComponent';

const RCTNavigationItem = requireNativeComponent('RCTNavItem');
const RCTNavigationBarTitleViewWrapper = requireNativeComponent('RCTNavigationBarTitleViewWrapper');

const styles = StyleSheet.create({
  stackItem: {
    backgroundColor: 'white',
    overflow: 'hidden',
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
  },
});

class NavigationItemIOS extends React.Component {
  render() {
    var {itemWrapperStyle, navigator, route, index, ...props} = this.props;
    var {component, wrapperStyle, passProps, ...route} = route;
    var Component = component;
    return (
      <RCTNavigationItem
        {...route}
        {...props}
        titleView={NavigationBarTitleView.hook(route.titleView, route)}
        style={[
          styles.stackItem,
          itemWrapperStyle,
          wrapperStyle
        ]}>
        <StaticContainer key={'nav_content_' + index} shouldUpdate={!route.skipUpdate}>
          <Component navigator={navigator} route={route} {...passProps} />
        </StaticContainer>
      </RCTNavigationItem>
    );
  }
}

module.exports = NavigationItemIOS;

const components = [];
const navigationBarTitleViews = {};
class NavigationBarTitleView extends React.Component {
  static hook(renderer, holder) {
    if (renderer == null) {
      return -1;
    }
    var index = components.findIndex(c => c == holder);
    if (index < 0) {
      index = components.length;
      components[index] = holder;
      holder.renderer = renderer;
    }
    else {
      if (holder.renderer != renderer) {
        delete components[index];
        index = components.length;
        components[index] = holder;
        holder.renderer = renderer;
      }
    }
    return index;
  }
  static unhook(holder) {
    delete components[components.findIndex(c => c == holder)];
  }
  static take(index) {
    const holder = components[index];
    return holder && holder.renderer;
  }
  render() {
    let index = this.state && this.state.component;
    if (index == null) {
      index = this.props.component;
    }
    navigationBarTitleViews[this.props.id] = this;
    const Component = NavigationBarTitleView.take(index);
    return (
      <RCTNavigationBarTitleViewWrapper style={{height:44,alignSelf:'center'}}>
        {Component ? Component() : <View />}
      </RCTNavigationBarTitleViewWrapper>
    );
  }
}
AppRegistry.registerComponent('NavigationBarTitleView', () => NavigationBarTitleView);