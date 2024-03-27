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

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:swipe_refresh/src/swipe_refresh_state.dart';
import 'package:swipe_refresh/src/widgets/scroll_behavior_in_web.dart';

/// Base refresh indicator widget.
abstract class SwipeRefreshBase extends StatefulWidget {
  const SwipeRefreshBase({
    required this.stateStream,
    required this.onRefresh,
    Key? key,
    this.initState,
    this.scrollController,
    this.childrenDelegate,
    this.children,
    this.padding,
    this.shrinkWrap = false,
    this.keyboardDismissBehavior,
    this.physics,
  })  : assert((children == null || childrenDelegate == null) &&
            (children != null || childrenDelegate != null)),
        super(key: key);

  final List<Widget>? children;
  final VoidCallback onRefresh;
  final SwipeRefreshState? initState;
  final Stream<SwipeRefreshState> stateStream;
  final ScrollController? scrollController;
  final SliverChildDelegate? childrenDelegate;
  final EdgeInsets? padding;
  final bool shrinkWrap;
  final ScrollViewKeyboardDismissBehavior? keyboardDismissBehavior;
  final ScrollPhysics? physics;

  @override
  @protected
  // ignore: no_logic_in_create_state
  SwipeRefreshBaseState createState();
}

abstract class SwipeRefreshBaseState<T extends SwipeRefreshBase>
    extends State<T> {
  @protected
  final GlobalKey refreshKey = GlobalKey();

  @protected
  late final MaterialScrollBehavior? scrollBehavior;

  @protected
  Completer<void>? completer;

  @visibleForTesting
  @protected
  SwipeRefreshState currentState = SwipeRefreshState.hidden;

  StreamSubscription<SwipeRefreshState>? _stateSubscription;

  @override
  void initState() {
    super.initState();

    if (widget.initState != null) {
      currentState = widget.initState!;
    }

    _stateSubscription = widget.stateStream.listen(_updateState);
    scrollBehavior = _getScrollBehavior();
  }

  void _updateState(SwipeRefreshState newState) {
    if (currentState != newState) {
      setState(
        () {
          currentState = newState;

          onUpdateState(currentState);
        },
      );
    }
  }

  @protected
  Future<void> _onRefresh() {
    _updateState(SwipeRefreshState.loading);
    widget.onRefresh();
    completer = Completer<void>();
    return completer!.future;
  }

  MaterialScrollBehavior? _getScrollBehavior() {
    final behaviorInWeb = ScrollBehaviorInWeb();

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
      case TargetPlatform.iOS:
        return null;
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
        return behaviorInWeb;
    }
  }

  @override
  void dispose() {
    _stateSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: avoid-returning-widgets
    return buildRefresher(refreshKey, widget.children ?? [], _onRefresh);
  }

  @protected
  Widget buildRefresher(
    Key key,
    List<Widget> children,
    Future<void> Function() onRefresh,
  );

  @protected
  void onUpdateState(SwipeRefreshState state);
}
