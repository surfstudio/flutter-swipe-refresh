// Copyright (c) 2019-present,  SurfStudio LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:flutter/cupertino.dart';
import 'package:swipe_refresh/src/cupertino_swipe_refresh.dart';
import 'package:swipe_refresh/src/material_swipe_refresh.dart';
import 'package:swipe_refresh/src/swipe_refresh_state.dart';
import 'package:swipe_refresh/src/swipe_refresh_style.dart';
import 'package:swipe_refresh/utills/platform_wrapper.dart';

/// Refresh indicator widget.
///
/// Params for Material Design style:
/// [indicatorColor], [backgroundColor](more details [MaterialSwipeRefresh]).
///
/// Params for Cupertino style:
/// [refreshTriggerPullDistance], [refreshIndicatorExtent], [indicatorBuilder]
/// (more details [CupertinoSwipeRefresh]).
class SwipeRefresh extends StatelessWidget {
  const SwipeRefresh(
    this.style, {
    required this.stateStream,
    required this.onRefresh,
    Key? key,
    this.children,
    this.initState,
    this.scrollController,
    this.childrenDelegate,
    this.padding,
    this.indicatorColor,
    this.shrinkWrap = false,
    this.keyboardDismissBehavior,
    this.physics,
    Color? backgroundColor,
    double? refreshTriggerPullDistance,
    double? refreshIndicatorExtent,
    RefreshControlIndicatorBuilder? indicatorBuilder,
    PlatformWrapper? platform,
  })  : backgroundColor = backgroundColor ?? const Color(0xFFFFFFFF),
        refreshTriggerPullDistance = refreshTriggerPullDistance ??
            CupertinoSwipeRefresh.defaultRefreshTriggerPullDistance,
        refreshIndicatorExtent = refreshIndicatorExtent ??
            CupertinoSwipeRefresh.defaultRefreshIndicatorExtent,
        indicatorBuilder = indicatorBuilder ??
            CupertinoSliverRefreshControl.buildRefreshIndicator,
        _platform = platform ?? const PlatformWrapper(),
        super(key: key);

  /// Create refresh indicator adaptive to platform.
  const SwipeRefresh.adaptive({
    required Stream<SwipeRefreshState> stateStream,
    required VoidCallback onRefresh,
    List<Widget>? children,
    SliverChildDelegate? childrenDelegate,
    Key? key,
    SwipeRefreshState? initState,
    Color? indicatorColor,
    Color? backgroundColor,
    double? refreshTriggerPullDistance,
    double? refreshIndicatorExtent,
    RefreshControlIndicatorBuilder? indicatorBuilder,
    ScrollController? scrollController,
    EdgeInsets? padding,
    bool shrinkWrap = false,
    ScrollViewKeyboardDismissBehavior? keyboardDismissBehavior,
    ScrollPhysics? physics,
    PlatformWrapper? platform,
  }) : this(
          SwipeRefreshStyle.adaptive,
          key: key,
          children: children,
          childrenDelegate: childrenDelegate,
          stateStream: stateStream,
          initState: initState,
          onRefresh: onRefresh,
          indicatorColor: indicatorColor,
          backgroundColor: backgroundColor,
          refreshTriggerPullDistance: refreshTriggerPullDistance,
          refreshIndicatorExtent: refreshIndicatorExtent,
          indicatorBuilder: indicatorBuilder,
          scrollController: scrollController,
          padding: padding,
          shrinkWrap: shrinkWrap,
          keyboardDismissBehavior: keyboardDismissBehavior,
          physics: physics,
          platform: platform,
        );

  /// Create refresh indicator with Material Design style.
  const SwipeRefresh.material({
    required Stream<SwipeRefreshState> stateStream,
    required VoidCallback onRefresh,
    List<Widget>? children,
    SliverChildDelegate? childrenDelegate,
    Key? key,
    SwipeRefreshState? initState,
    Color? indicatorColor,
    Color? backgroundColor,
    ScrollController? scrollController,
    EdgeInsets? padding,
    bool shrinkWrap = false,
    ScrollViewKeyboardDismissBehavior? keyboardDismissBehavior,
    ScrollPhysics? physics,
  }) : this(
          SwipeRefreshStyle.material,
          key: key,
          children: children,
          childrenDelegate: childrenDelegate,
          stateStream: stateStream,
          initState: initState,
          onRefresh: onRefresh,
          indicatorColor: indicatorColor,
          backgroundColor: backgroundColor,
          scrollController: scrollController,
          padding: padding,
          shrinkWrap: shrinkWrap,
          keyboardDismissBehavior: keyboardDismissBehavior,
          physics: physics,
        );

  /// Create refresh indicator with Cupertino style.
  const SwipeRefresh.cupertino({
    required Stream<SwipeRefreshState> stateStream,
    required VoidCallback onRefresh,
    List<Widget>? children,
    SliverChildDelegate? childrenDelegate,
    Key? key,
    SwipeRefreshState? initState,
    double? refreshTriggerPullDistance,
    double? refreshIndicatorExtent,
    RefreshControlIndicatorBuilder? indicatorBuilder,
    ScrollController? scrollController,
    EdgeInsets? padding,
    bool shrinkWrap = false,
    ScrollViewKeyboardDismissBehavior? keyboardDismissBehavior,
    ScrollPhysics? physics,
  }) : this(
          SwipeRefreshStyle.cupertino,
          key: key,
          children: children,
          childrenDelegate: childrenDelegate,
          stateStream: stateStream,
          initState: initState,
          onRefresh: onRefresh,
          refreshTriggerPullDistance: refreshTriggerPullDistance,
          refreshIndicatorExtent: refreshIndicatorExtent,
          indicatorBuilder: indicatorBuilder,
          scrollController: scrollController,
          padding: padding,
          shrinkWrap: shrinkWrap,
          keyboardDismissBehavior: keyboardDismissBehavior,
          physics: physics,
        );

  /// Create refresh indicator with adaptive to platform style.
  /// Uses SliverChildBuilderDelegate in childrenDelegate to avoid
  /// creating more children than are visible through the [Viewport].
  factory SwipeRefresh.builder({
    required IndexedWidgetBuilder itemBuilder,
    required int itemCount,
    required Stream<SwipeRefreshState> stateStream,
    required VoidCallback onRefresh,
    Key? key,
    SwipeRefreshState? initState,
    Color? indicatorColor,
    Color? backgroundColor,
    double? refreshTriggerPullDistance,
    double? refreshIndicatorExtent,
    RefreshControlIndicatorBuilder? indicatorBuilder,
    ScrollController? scrollController,
    EdgeInsets? padding,
    bool shrinkWrap = false,
    ScrollViewKeyboardDismissBehavior? keyboardDismissBehavior,
    ScrollPhysics? physics,
    PlatformWrapper? platform,
  }) {
    return SwipeRefresh(
      SwipeRefreshStyle.adaptive,
      key: key,
      stateStream: stateStream,
      initState: initState,
      onRefresh: onRefresh,
      indicatorColor: indicatorColor,
      backgroundColor: backgroundColor,
      refreshTriggerPullDistance: refreshTriggerPullDistance,
      refreshIndicatorExtent: refreshIndicatorExtent,
      indicatorBuilder: indicatorBuilder,
      scrollController: scrollController,
      padding: padding,
      shrinkWrap: shrinkWrap,
      keyboardDismissBehavior: keyboardDismissBehavior,
      physics: physics,
      childrenDelegate: SliverChildBuilderDelegate(
        itemBuilder,
        childCount: itemCount,
      ),
      platform: platform,
    );
  }

  final List<Widget>? children;
  final VoidCallback onRefresh;
  final SwipeRefreshState? initState;
  final Stream<SwipeRefreshState> stateStream;
  final Color? indicatorColor;
  final Color backgroundColor;
  final double refreshTriggerPullDistance;
  final double refreshIndicatorExtent;
  final RefreshControlIndicatorBuilder indicatorBuilder;
  final SwipeRefreshStyle style;
  final ScrollController? scrollController;
  final SliverChildDelegate? childrenDelegate;
  final EdgeInsets? padding;
  final bool shrinkWrap;
  final ScrollViewKeyboardDismissBehavior? keyboardDismissBehavior;
  final ScrollPhysics? physics;
  final PlatformWrapper _platform;

  @override
  Widget build(BuildContext context) {
    switch (style) {
      case SwipeRefreshStyle.material:
        return MaterialSwipeRefresh(
          key: key,
          childrenDelegate: childrenDelegate,
          stateStream: stateStream,
          initState: initState,
          onRefresh: onRefresh,
          scrollController: scrollController,
          backgroundColor: backgroundColor,
          indicatorColor: indicatorColor,
          shrinkWrap: shrinkWrap,
          padding: padding,
          keyboardDismissBehavior: keyboardDismissBehavior,
          physics: physics,
          children: children,
        );
      case SwipeRefreshStyle.cupertino:
        return CupertinoSwipeRefresh(
          key: key,
          childrenDelegate: childrenDelegate,
          stateStream: stateStream,
          initState: initState,
          onRefresh: onRefresh,
          scrollController: scrollController,
          refreshIndicatorExtent: refreshIndicatorExtent,
          refreshTriggerPullDistance: refreshTriggerPullDistance,
          indicatorBuilder: indicatorBuilder,
          shrinkWrap: shrinkWrap,
          padding: padding,
          physics: physics,
          children: children,
        );
      case SwipeRefreshStyle.builder:
      case SwipeRefreshStyle.adaptive:
        if (_platform.isCupertino) {
          return CupertinoSwipeRefresh(
            key: key,
            childrenDelegate: childrenDelegate,
            stateStream: stateStream,
            initState: initState,
            onRefresh: onRefresh,
            scrollController: scrollController,
            refreshIndicatorExtent: refreshIndicatorExtent,
            refreshTriggerPullDistance: refreshTriggerPullDistance,
            indicatorBuilder: indicatorBuilder,
            shrinkWrap: shrinkWrap,
            padding: padding,
            physics: physics,
            children: children,
          );
        } else {
          return MaterialSwipeRefresh(
            key: key,
            childrenDelegate: childrenDelegate,
            stateStream: stateStream,
            initState: initState,
            onRefresh: onRefresh,
            scrollController: scrollController,
            backgroundColor: backgroundColor,
            indicatorColor: indicatorColor,
            shrinkWrap: shrinkWrap,
            padding: padding,
            keyboardDismissBehavior: keyboardDismissBehavior,
            physics: physics,
            children: children,
          );
        }
    }
  }
}
