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

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:swipe_refresh/src/swipe_refresh_base.dart';
import 'package:swipe_refresh/src/swipe_refresh_state.dart';

/// Refresh indicator widget with Cupertino style.
/// [stateStream] - indicator state([SwipeRefreshState.loading] or
/// [SwipeRefreshState.hidden]).
/// [onRefresh] - callback invoked when pulled by [refreshTriggerPullDistance].
/// [children] - list of any widgets.
/// [childrenDelegate] - pass the inheritor to SliverChildDelegate to avoid
/// creating more children than are visible through the [Viewport].
/// [initState] - initialization state([SwipeRefreshState.loading] or
/// [SwipeRefreshState.hidden]).
/// [padding] - passed to add [SliverPadding].
/// [scrollController] - ScrollController for [CustomScrollView].
/// [shrinkWrap] - Whether the extent of the scroll view should be determined
/// by the contents being viewed(default - false).
/// [refreshTriggerPullDistance] - The amount of overscroll the scrollable
/// must be dragged to trigger a reload(default - [defaultRefreshTriggerPullDistance]).
/// [refreshIndicatorExtent] - amount of space the refresh indicator
/// sliver will keep holding while [onRefresh] is still running.
/// [indicatorBuilder] - builder that's called as this sliver's size changes,
/// and as the state changes(default - [CupertinoSliverRefreshControl.buildRefreshIndicator]).
/// [keyboardDismissBehavior] - [ScrollViewKeyboardDismissBehavior]
/// the defines how this [ScrollView] will dismiss the keyboard automatically.
/// (if == null it will be [ScrollViewKeyboardDismissBehavior.onDrag]).
/// [physics] - defines the physics of the scroll(if == null it will be
/// [AlwaysScrollableScrollPhysics]).
class CupertinoSwipeRefresh extends SwipeRefreshBase {
  const CupertinoSwipeRefresh({
    required Stream<SwipeRefreshState> stateStream,
    required VoidCallback onRefresh,
    this.refreshTriggerPullDistance = defaultRefreshTriggerPullDistance,
    this.refreshIndicatorExtent = defaultRefreshIndicatorExtent,
    this.indicatorBuilder = CupertinoSliverRefreshControl.buildRefreshIndicator,
    List<Widget>? children,
    SliverChildDelegate? childrenDelegate,
    SwipeRefreshState? initState,
    EdgeInsets? padding,
    ScrollController? scrollController,
    bool shrinkWrap = false,
    ScrollViewKeyboardDismissBehavior? keyboardDismissBehavior,
    ScrollPhysics? physics,
    Key? key,
    this.cacheExtent,
  }) : super(
          key: key,
          children: children,
          childrenDelegate: childrenDelegate,
          stateStream: stateStream,
          initState: initState,
          onRefresh: onRefresh,
          scrollController: scrollController,
          padding: padding,
          shrinkWrap: shrinkWrap,
          keyboardDismissBehavior: keyboardDismissBehavior,
          physics: physics,
        );

  static const double defaultRefreshTriggerPullDistance = 100.0;
  static const double defaultRefreshIndicatorExtent = 60.0;

  final double refreshTriggerPullDistance;
  final double refreshIndicatorExtent;
  final RefreshControlIndicatorBuilder indicatorBuilder;
  final double? cacheExtent;

  @override
  SwipeRefreshBaseState createState() => _CupertinoSwipeRefreshState();
}

class _CupertinoSwipeRefreshState
    extends SwipeRefreshBaseState<CupertinoSwipeRefresh> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();
  }

  @override
  Widget buildRefresher(
    Key key,
    List<Widget> children,
    Future<void> Function() onRefresh,
  ) {
    return CustomScrollView(
      shrinkWrap: widget.shrinkWrap,
      controller: _scrollController,
      scrollBehavior: scrollBehavior,
      keyboardDismissBehavior: widget.keyboardDismissBehavior ??
          ScrollViewKeyboardDismissBehavior.onDrag,
      cacheExtent: widget.cacheExtent,
      physics: widget.physics == null
          ? const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            )
          : AlwaysScrollableScrollPhysics(parent: widget.physics),
      slivers: <Widget>[
        CupertinoSliverRefreshControl(
          key: key,
          onRefresh: onRefresh,
          refreshTriggerPullDistance: widget.refreshTriggerPullDistance,
          refreshIndicatorExtent: widget.refreshIndicatorExtent,
          builder: widget.indicatorBuilder,
        ),
        SliverSafeArea(
          bottom: widget.padding == null,
          left: widget.padding == null,
          right: widget.padding == null,
          top: widget.padding == null,
          sliver: _ListChildrenWidget(
            children: children,
            padding: widget.padding,
            childrenDelegate: widget.childrenDelegate,
          ),
        ),
      ],
    );
  }

  @override
  void onUpdateState(SwipeRefreshState state) {
    if (state == SwipeRefreshState.hidden) {
      if (completer != null) {
        completer!.complete();
        completer = null;
      }
    }
  }
}

class _ListChildrenWidget extends StatelessWidget {
  const _ListChildrenWidget({
    required this.children,
    Key? key,
    this.padding,
    this.childrenDelegate,
  }) : super(key: key);

  final List<Widget> children;
  final EdgeInsets? padding;
  final SliverChildDelegate? childrenDelegate;

  @override
  Widget build(BuildContext context) {
    if (padding != null) {
      return SliverPadding(
        padding: padding!,
        sliver: SliverList(
          delegate: childrenDelegate ??
              SliverChildListDelegate(
                children,
              ),
        ),
      );
    }
    return SliverList(
      delegate: childrenDelegate ??
          SliverChildListDelegate(
            children,
          ),
    );
  }
}
