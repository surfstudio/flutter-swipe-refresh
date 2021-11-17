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
/// [children] -
class CupertinoSwipeRefresh extends SwipeRefreshBase {
  static const double defaultRefreshTriggerPullDistance = 100.0;
  static const double defaultRefreshIndicatorExtent = 60.0;

  final double refreshTriggerPullDistance;
  final double refreshIndicatorExtent;
  final RefreshControlIndicatorBuilder indicatorBuilder;

  const CupertinoSwipeRefresh({
    required Stream<SwipeRefreshState> stateStream,
    required VoidCallback onRefresh,
    Key? key,
    SliverChildDelegate? childrenDelegate,
    List<Widget>? children,
    SwipeRefreshState? initState,
    EdgeInsets? padding,
    ScrollController? scrollController,
    bool shrinkWrap = false,
    this.refreshTriggerPullDistance = defaultRefreshTriggerPullDistance,
    this.refreshIndicatorExtent = defaultRefreshIndicatorExtent,
    this.indicatorBuilder = CupertinoSliverRefreshControl.buildRefreshIndicator,
    ScrollViewKeyboardDismissBehavior? keyboardDismissBehavior,
    ScrollPhysics? physics,
  }) : super(
          key: key,
          children: children,
          childrenDelegate: childrenDelegate,
          stateStream: stateStream,
          initState: initState,
          onRefresh: onRefresh,
          padding: padding,
          scrollController: scrollController,
          shrinkWrap: shrinkWrap,
          keyboardDismissBehavior: keyboardDismissBehavior,
          physics: physics,
        );

  @override
  // ignore: no_logic_in_create_state
  SwipeRefreshBaseState createState() => _CupertinoSwipeRefreshState(
        scrollController,
      );
}

class _CupertinoSwipeRefreshState
    extends SwipeRefreshBaseState<CupertinoSwipeRefresh> {
  final ScrollController _scrollController;

  _CupertinoSwipeRefreshState(
    ScrollController? scrollController,
  ) : _scrollController = scrollController ?? ScrollController();

  @override
  Widget buildRefresher(
    Key key,
    List<Widget> children,
    Future<void> Function() onRefresh,
  ) {
    return CustomScrollView(
      shrinkWrap: widget.shrinkWrap,
      controller: _scrollController,
      keyboardDismissBehavior: widget.keyboardDismissBehavior ??
          ScrollViewKeyboardDismissBehavior.onDrag,
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
    if (state == SwipeRefreshState.loading) {
      _scrollController.jumpTo(-(widget.refreshIndicatorExtent + 5));
    }

    if (state == SwipeRefreshState.hidden) {
      if (completer != null) {
        completer!.complete();
        completer = null;
      }
    }
  }
}

class _ListChildrenWidget extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsets? padding;
  final SliverChildDelegate? childrenDelegate;

  const _ListChildrenWidget({
    required this.children,
    Key? key,
    this.padding,
    this.childrenDelegate,
  }) : super(key: key);

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
