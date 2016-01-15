/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 *
 * @providesModule TabBarItemIOS
 * @noflow
 */
'use strict';

var Image = require('Image');
var React = require('React');
var StaticContainer = require('StaticContainer.react');
var StyleSheet = require('StyleSheet');
var View = require('View');

var requireNativeComponent = require('requireNativeComponent');

class TabBarItemIOS extends React.Component {
  static propTypes = {
    ...View.propTypes,
    /**
     * Little red bubble that sits at the top right of the icon.
     */
    badge: React.PropTypes.oneOfType([
      React.PropTypes.string,
      React.PropTypes.number,
    ]),
    /**
     * Items comes with a few predefined system icons. Note that if you are
     * using them, the title and selectedIcon will be overriden with the
     * system ones.
     */
    systemIcon: React.PropTypes.oneOf([
      'bookmarks',
      'contacts',
      'downloads',
      'favorites',
      'featured',
      'history',
      'more',
      'most-recent',
      'most-viewed',
      'recents',
      'search',
      'top-rated',
    ]),
    /**
     * 
     */
    viewControllerKey: React.PropTypes.string,
    /**
     * 
     */
    viewControllerType: React.PropTypes.string,
    /**
     * A custom icon for the tab. It is ignored when a system icon is defined.
     */
    icon: Image.propTypes.source,
    /**
     * A custom icon when the tab is selected. It is ignored when a system
     * icon is defined. If left empty, the icon will be tinted in blue.
     */
    selectedIcon: Image.propTypes.source,
    /**
     * A function that returns a component as the content of the tab.
     */
    content: React.PropTypes.func,
    /**
     * Callback when this tab is being selected, you should change the state of your
     * component to set selected={true}.
     */
    onPress: React.PropTypes.func,
    /**
     * Callback when this tab will appear
     */
    onWillAppear: React.PropTypes.func,
    /**
     * Callback when this tab did appear
     */
    onDidAppear: React.PropTypes.func,
    /**
     * Callback when this tab will disappear
     */
    onWillDisappear: React.PropTypes.func,
    /**
     * Callback when this tab did disappear
     */
    onDidDisappear: React.PropTypes.func,
    /**
     * It specifies whether the children are visible or not. If you see a
     * blank content, you probably forgot to add a selected one.
     */
    selected: React.PropTypes.bool,
    /**
     * React style object.
     */
    style: View.propTypes.style,
    /**
     * Text that appears under the icon. It is ignored when a system icon
     * is defined.
     */
    title: React.PropTypes.string,
  };

  constructor() {
    super(...arguments);
    this.forwards = {};
    this.state = {
      hasBeenSelected: false,
    };
  }

  componentWillMount() {
    if (this.props.selected) {
      this.setState({hasBeenSelected: true});
    }
  }

  componentWillReceiveProps(nextProps: { selected?: boolean }) {
    if (this.state.hasBeenSelected || nextProps.selected) {
      this.setState({hasBeenSelected: true});
    }
  }
  
  forward(targetKey, methodName) {
    const forwardKey = `${targetKey}:${methodName}`;
    return this.forwards[forwardKey] || (
      this.forwards[forwardKey] = () => {
        var target = this.refs[targetKey];
        if (target && target[methodName]) {
          target[methodName]();
        }
      }
    );
  }

  render() {
    var {style, content, children, ...props} = this.props;
    this.viewControllerKey || (this.viewControllerKey = Math.random() + '');
    
    var tabContents, viewControllerType;
    var tabContent = content && content({
      ref: 'content', viewControllerKey: this.viewControllerKey
    });
    if (tabContent && tabContent.type.displayName == 'NavigatorIOS') {
      viewControllerType = 'RCTNavigationController';
    }
    // if the tab has already been shown once, always continue to show it so we
    // preserve state between tab transitions
    if (this.state.hasBeenSelected) {
      tabContents = (
        <StaticContainer shouldUpdate={props.selected}>
          {tabContent || children}
        </StaticContainer>
      );
    } else {
      tabContents = <View />;
    }
    
    return (
      <RCTTabBarItem {...props}
        style={[styles.tab, style]}
        viewControllerKey={this.viewControllerKey}
        viewControllerType={viewControllerType}
        onWillAppear={this.forward('content', 'componentWillAppear')}
        onDidAppear={this.forward('content', 'componentDidAppear')}
        onWillDisappear={this.forward('content', 'componentWillDisappear')}
        onDidDisappear={this.forward('content', 'componentDidDisappear')}>
        {tabContents}
      </RCTTabBarItem>
    );
  }
}

var styles = StyleSheet.create({
  tab: {
    position: 'absolute',
    top: 0,
    right: 0,
    bottom: 0,
    left: 0,
  }
});

var RCTTabBarItem = requireNativeComponent('RCTTabBarItem', TabBarItemIOS);

module.exports = TabBarItemIOS;
