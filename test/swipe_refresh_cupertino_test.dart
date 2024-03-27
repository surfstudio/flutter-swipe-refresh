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

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:swipe_refresh/src/swipe_refresh_base.dart';
import 'package:swipe_refresh/swipe_refresh.dart';

import 'test_utils.dart';

void main() {
  late StreamController<SwipeRefreshState> streamController;
  late Stream<SwipeRefreshState> stream;
  late MockOnRefreshFunction onRefreshFunction;
  late ScrollPhysics scrollPhysics;
  final children = _listColors
      .map((e) => Container(
            color: e,
            height: 100,
          ))
      .toList();

  setUp(() {
    streamController = StreamController<SwipeRefreshState>.broadcast();
    stream = streamController.stream;

    onRefreshFunction = MockOnRefreshFunction();
    when(() => onRefreshFunction.call()).thenAnswer(
      (invocation) {
        return streamController.sink.add(SwipeRefreshState.hidden);
      },
    );

    scrollPhysics = const ScrollPhysics();
  });

  tearDown(
    () async {
      await streamController.close();
    },
  );

  testWidgets(
    'When trying to return a CupertinoSwipeRefresh with no children or '
    'childrenDelegate passed, must be an assertion error',
    (tester) async {
      expect(
        () {
          return makeTestableWidget(
            CupertinoSwipeRefresh(
              stateStream: stream,
              onRefresh: onRefreshFunction,
            ),
          );
        },
        throwsAssertionError,
      );
    },
  );

  testWidgets(
    'SwipeRefresh.cupertino widget with children as argument does not break',
    (tester) async {
      final cupertinoSwipeRefresh = makeTestableWidget(
        SwipeRefresh.cupertino(
          stateStream: stream,
          onRefresh: onRefreshFunction,
          children: children,
        ),
      );

      await tester.pumpWidget(cupertinoSwipeRefresh);

      expect(() => cupertinoSwipeRefresh, returnsNormally);
      expect(find.byType(CupertinoSwipeRefresh), findsOneWidget);
      expect(find.byType(Container), findsNWidgets(4));
    },
  );

  testWidgets(
    'When drag down enough, the refresh should start and should called '
    'onRefreshFunction',
    (tester) async {
      final cupertinoSwipeRefresh = makeTestableWidget(
        SwipeRefresh.cupertino(
          stateStream: stream,
          onRefresh: onRefreshFunction,
          children: children,
        ),
      );

      await tester.pumpWidget(cupertinoSwipeRefresh);
      await tester.drag(
        find.byType(SwipeRefresh),
        const Offset(0, 300),
        touchSlopY: 0,
      );
      await tester.pump();

      verify(() => onRefreshFunction()).called(1);
    },
  );

  testWidgets(
    'When drag down enough, the refresh should start and end after 3 seconds',
    (tester) async {
      const key = Key('Test key');
      final findKey = find.byKey(key);

      final cupertinoSwipeRefresh = makeTestableWidget(
        SwipeRefresh.cupertino(
          stateStream: stream,
          onRefresh: onRefreshFunction,
          indicatorBuilder: (
            context,
            refreshState,
            pulledExtent,
            refreshTriggerPullDistance,
            refreshIndicatorExtent,
          ) {
            return Container(
              key: key,
            );
          },
          children: children,
        ),
      );

      await tester.pumpWidget(cupertinoSwipeRefresh);

      await tester.drag(
        find.byType(SwipeRefresh),
        const Offset(0, 300),
        touchSlopY: 0,
      );

      await tester.pump();

      expect(findKey, findsOneWidget);

      await tester.pump(const Duration(seconds: 3));
      await tester.pump();

      expect(findKey, findsNothing);
    },
  );

  testWidgets(
    'When drag down is not enough to trigger an update the update should not be',
    (tester) async {
      final events = <SwipeRefreshState>[];

      stream.listen(events.add);

      final cupertinoSwipeRefresh = makeTestableWidget(
        SwipeRefresh.cupertino(
          stateStream: stream,
          onRefresh: onRefreshFunction,
          children: children,
        ),
      );

      await tester.pumpWidget(cupertinoSwipeRefresh);
      await tester.drag(find.byType(SwipeRefresh), const Offset(0.0, 50.0));
      await tester.pump();

      verifyNever(() => onRefreshFunction());
    },
  );

  testWidgets(
    'If initState: SwipeRefreshState.loading passed to the SwipeRefresh.cupertino, '
    'the currentState of the SwipeRefreshBase should be SwipeRefreshState.loading',
    (tester) async {
      final cupertinoWidget = SwipeRefresh.cupertino(
        stateStream: stream,
        onRefresh: onRefreshFunction,
        children: children,
        initState: SwipeRefreshState.loading,
      );

      final cupertinoSwipeRefresh = makeTestableWidget(cupertinoWidget);

      await tester.pumpWidget(cupertinoSwipeRefresh);

      final SwipeRefreshBaseState state = tester.state(
        find.byType(CupertinoSwipeRefresh),
      ) as SwipeRefreshBaseState<CupertinoSwipeRefresh>;

      expect(state.currentState, cupertinoWidget.initState);
    },
  );

  testWidgets(
    'if pass the physics to the SwipeRefresh.cupertino, then SwipeRefreshBase '
    'physics should be the same',
    (tester) async {
      final events = <SwipeRefreshState>[];

      stream.listen(events.add);

      final cupertinoWidget = SwipeRefresh.cupertino(
        stateStream: stream,
        onRefresh: onRefreshFunction,
        children: children,
        initState: SwipeRefreshState.loading,
        physics: scrollPhysics,
      );

      final cupertinoSwipeRefresh = makeTestableWidget(cupertinoWidget);

      await tester.pumpWidget(cupertinoSwipeRefresh);

      final baseWidget = tester.widget(
        find.byType(SwipeRefresh),
      ) as SwipeRefresh;

      expect(baseWidget.physics, scrollPhysics);
    },
  );

  testWidgets(
    'If padding passed to the SwipeRefresh.cupertino, '
    'SliverList should be wrapped in SliverPadding',
    (tester) async {
      final events = <SwipeRefreshState>[];

      stream.listen(events.add);

      final cupertinoWidgetWithoutPadding = makeTestableWidget(
        SwipeRefresh.cupertino(
          stateStream: stream,
          onRefresh: onRefreshFunction,
          children: children,
        ),
      );

      final cupertinoWidgetWithPadding = makeTestableWidget(
        SwipeRefresh.cupertino(
          stateStream: stream,
          onRefresh: onRefreshFunction,
          children: children,
          padding: const EdgeInsets.only(top: 16.0),
        ),
      );

      final findSliverList = find.byType(SliverList);
      final findSliverPadding = find.byType(SliverPadding);

      await tester.pumpWidget(cupertinoWidgetWithoutPadding);

      expect(findSliverList, findsOneWidget);
      // Must find one widget create by SliverSafeArea.
      expect(findSliverPadding, findsOneWidget);

      await tester.pumpWidget(cupertinoWidgetWithPadding);

      expect(findSliverList, findsOneWidget);
      // Must find two widgets(create by SliverSafeArea and create by SwipeRefresh.cupertino).
      expect(findSliverPadding, findsNWidgets(2));
    },
  );
}

class MockOnRefreshFunction extends Mock {
  void call();
}

const _listColors = [
  Colors.blue,
  Colors.green,
  Colors.red,
  Colors.amber,
];
