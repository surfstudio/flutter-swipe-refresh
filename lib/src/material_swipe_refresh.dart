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

// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:swipe_refresh/src/swipe_refresh_base.dart';
import 'package:swipe_refresh/src/swipe_refresh_state.dart';

/// Refresh indicator widget with Material Design style.
/// [stateStream] - indicator state([SwipeRefreshState.loading] or
/// [SwipeRefreshState.hidden]).
/// [onRefresh] - function that's called when the user has dragged the
/// refresh indicator far enough to demonstrate that they want the app to refresh.
/// [indicatorColor] - progress indicator's foreground color
/// (default - [ColorScheme.primary]).
/// [children] - list of any widgets.
/// [childrenDelegate] - pass the inheritor to SliverChildDelegate
/// to avoid creating more children than are visible through the [Viewport].
/// [initState] - initialization state([SwipeRefreshState.loading] or
/// [SwipeRefreshState.hidden]).
/// [backgroundColor] - progress indicator's background color
/// (default - Color(0xFFFFFFFF)).
/// [scrollController] - [ScrollController] for [ListView].
/// [padding] -  corresponds to having a [SliverPadding] in the
/// [CustomScrollView.slivers] property instead of the list itself,
/// and having the [SliverList] instead be a child of the [SliverPadding].
/// [shrinkWrap] - Whether the extent of the scroll view should be determined
/// by the contents being viewed(default - false).
/// [keyboardDismissBehavior] - [ScrollViewKeyboardDismissBehavior]
/// the defines how this [ScrollView] will dismiss the keyboard automatically.
/// (if == null it will be [ScrollViewKeyboardDismissBehavior.manual]).
/// [physics] - defines the physics of the scroll(if == null it will be
/// [AlwaysScrollableScrollPhysics]).
class MaterialSwipeRefresh extends SwipeRefreshBase {
  final Color? indicatorColor;
  final Color backgroundColor;

  const MaterialSwipeRefresh({
    required Stream<SwipeRefreshState> stateStream,
    required VoidCallback onRefresh,
    Key? key,
    this.indicatorColor,
    List<Widget>? children,
    SliverChildDelegate? childrenDelegate,
    SwipeRefreshState? initState,
    Color? backgroundColor,
    ScrollController? scrollController,
    EdgeInsets? padding,
    bool shrinkWrap = false,
    ScrollViewKeyboardDismissBehavior? keyboardDismissBehavior,
    ScrollPhysics? physics,
  })  : backgroundColor = backgroundColor ?? const Color(0xFFFFFFFF),
        super(
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

  @override
  _MaterialSwipeRefreshState createState() => _MaterialSwipeRefreshState();
}

class _MaterialSwipeRefreshState
    extends SwipeRefreshBaseState<MaterialSwipeRefresh> {
  @override
  Widget buildRefresher(
    Key key,
    List<Widget> children,
    Future<void> Function() onRefresh,
  ) {
    return RefreshIndicator(
      key: key,
      onRefresh: onRefresh,
      color: widget.indicatorColor,
      backgroundColor: widget.backgroundColor,
      child: widget.childrenDelegate == null
          ? ListView(
              shrinkWrap: widget.shrinkWrap,
              padding: widget.padding,
              controller: widget.scrollController ?? ScrollController(),
              physics: AlwaysScrollableScrollPhysics(parent: widget.physics),
              keyboardDismissBehavior: widget.keyboardDismissBehavior ??
                  ScrollViewKeyboardDismissBehavior.manual,
              children: children,
            )
          : ListView.custom(
              shrinkWrap: widget.shrinkWrap,
              padding: widget.padding,
              childrenDelegate: widget.childrenDelegate!,
              controller: widget.scrollController ?? ScrollController(),
              keyboardDismissBehavior: widget.keyboardDismissBehavior ??
                  ScrollViewKeyboardDismissBehavior.manual,
              physics: AlwaysScrollableScrollPhysics(parent: widget.physics),
            ),
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
