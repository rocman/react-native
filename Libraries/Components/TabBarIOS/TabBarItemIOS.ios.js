/**
 * Copyright (c) 2015-present, Facebook, Inc.
 * All rights reserved.
 *
 * This source code is licensed under the BSD-style license found in the
 * LICENSE file in the root directory of this source tree. An additional grant
 * of patent rights can be found in the PATENTS file in the same directory.
 *
 * @providesModule TabBarItemIOS
 */
'use strict';

var Image = require('Image');
var React = require('React');
var StaticContainer = require('StaticContainer.react');
var StyleSheet = require('StyleSheet');
var View = require('View');
var resolveAssetSource = require('resolveAssetSource');

var requireNativeComponent = require('requireNativeComponent');

var TabBarItemIOS = React.createClass({
  propTypes: {
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
  },

  getInitialState: function() {
    return {
      hasBeenSelected: false,
    };
  },

  componentWillMount: function() {
    if (this.props.selected) {
      this.setState({hasBeenSelected: true});
    }
    this.forwardWillAppearToContent = (
      this.forwardToContent.bind(this, 'componentWillAppear')
    );
    this.forwardDidAppearToContent = (
      this.forwardToContent.bind(this, 'componentDidAppear')
    );
    this.forwardWillDisapearToContent = (
      this.forwardToContent.bind(this, 'componentWillDisappear')
    );
    this.forwardDidDisappearToContent = (
      this.forwardToContent.bind(this, 'componentDidDisappear')
    );
  },

  componentWillReceiveProps: function(nextProps: { selected?: boolean }) {
    if (this.state.hasBeenSelected || nextProps.selected) {
      this.setState({hasBeenSelected: true});
    }
  },
  
  forwardToContent: function(methodName) {
    var content = this.refs.content;
    if (content && content[methodName]) {
      content[methodName]();
    }
  },

  render: function() {
    var tabContents = null;
    // if the tab has already been shown once, always continue to show it so we
    // preserve state between tab transitions
    if (this.state.hasBeenSelected) {
      tabContents =
        <StaticContainer shouldUpdate={this.props.selected}>
          {this.props.content({ref: "content"})}
        </StaticContainer>;
    } else {
      tabContents = <View />;
    }

    var badge = typeof this.props.badge === 'number' ?
      '' + this.props.badge :
      this.props.badge;

    return (
      <RCTTabBarItem
        {...this.props}
        icon={this.props.systemIcon || resolveAssetSource(this.props.icon)}
        selectedIcon={resolveAssetSource(this.props.selectedIcon)}
        badge={badge}
        style={[styles.tab, this.props.style]}
        onWillAppear={this.forwardWillAppearToContent}
        onDidAppear={this.forwardDidAppearToContent}
        onWillDisappear={this.forwardWillDisappearToContent}
        onDidDisappear={this.forwardDidDisappearToContent}>
        {tabContents}
      </RCTTabBarItem>
    );
  }
});

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
