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
  late StreamController<SwipeRefreshState> controller;
  late Stream<SwipeRefreshState> stream;
  late MockOnRefreshFunction onRefreshFunction;
  late TestSliverChildListDelegate sliverChildDelegate;
  final children = _listColors
      .map((e) => Container(
            color: e,
            height: 100,
          ))
      .toList();

  setUp(() {
    controller = StreamController<SwipeRefreshState>.broadcast();
    stream = controller.stream;
    sliverChildDelegate = TestSliverChildListDelegate([const Text('Test')]);

    onRefreshFunction = MockOnRefreshFunction();
    when(() => onRefreshFunction.call()).thenAnswer(
      (invocation) {
        return controller.sink.add(SwipeRefreshState.hidden);
      },
    );
  });

  tearDown(() async {
    await controller.close();
  });

  testWidgets(
    'When trying create MaterialSwipeRefresh without children or '
    'childrenDelegate should be assertion error',
    (tester) async {
      expect(
        () {
          return makeTestableWidget(
            MaterialSwipeRefresh(
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
    'SwipeRefresh.material widget with children as argument does not break',
    (tester) async {
      final materialSwipeRefresh = makeTestableWidget(
        SwipeRefresh.material(
          stateStream: stream,
          onRefresh: onRefreshFunction,
          children: children,
        ),
      );

      await tester.pumpWidget(materialSwipeRefresh);

      expect(() => materialSwipeRefresh, returnsNormally);

      expect(find.byType(Container), findsNWidgets(4));

      expect(find.byType(MaterialSwipeRefresh), findsOneWidget);
    },
  );

  testWidgets(
    'When drag down enough, the refresh should start and should called '
    'onRefreshFunction',
    (tester) async {
      final materialSwipeRefresh = makeTestableWidget(
        SwipeRefresh.material(
          stateStream: stream,
          onRefresh: onRefreshFunction,
          children: children,
        ),
      );

      await tester.pumpWidget(materialSwipeRefresh);
      await tester.drag(
        find.byType(SwipeRefresh),
        const Offset(0, 300),
        touchSlopY: 0,
      );
      await tester.pump();
      await tester.pump(const Duration(seconds: 3));

      verify(() => onRefreshFunction()).called(1);
    },
  );

  testWidgets(
    'When drag down enough, the refresh should start and end after 3 seconds',
    (tester) async {
      final materialSwipeRefresh = makeTestableWidget(
        SwipeRefresh.material(
          stateStream: stream,
          onRefresh: onRefreshFunction,
          children: children,
        ),
      );

      final findSwipeRefresh = find.byType(SwipeRefresh);
      final findRefreshProgressIndicator = find.byType(RefreshProgressIndicator);

      await tester.pumpWidget(materialSwipeRefresh);
      await tester.drag(
        findSwipeRefresh,
        const Offset(0, 300),
        touchSlopY: 0,
      );
      await tester.pump();

      expect(findRefreshProgressIndicator, findsOneWidget);

      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 2));

      expect(findRefreshProgressIndicator, findsNothing);
    },
  );

  testWidgets(
    'When drag down is not enough to trigger an update the update should not be',
    (tester) async {
      final materialSwipeRefresh = makeTestableWidget(
        SwipeRefresh.material(
          stateStream: stream,
          onRefresh: onRefreshFunction,
          children: children,
        ),
      );
      await tester.pumpWidget(materialSwipeRefresh);
      await tester.drag(
        find.byType(SwipeRefresh),
        const Offset(0, 50),
        touchSlopY: 0,
      );
      await tester.pump();

      verifyNever(() => onRefreshFunction());
    },
  );

  testWidgets(
    'If initState: SwipeRefreshState.loading passed to the SwipeRefresh.material, '
    'currentState should be SwipeRefreshState.loading',
    (tester) async {
      final materialWidget = SwipeRefresh.material(
        stateStream: stream,
        onRefresh: onRefreshFunction,
        children: children,
        initState: SwipeRefreshState.loading,
      );
      final materialSwipeRefresh = makeTestableWidget(materialWidget);
      await tester.pumpWidget(materialSwipeRefresh);
      final SwipeRefreshBaseState state = tester.state(
        find.byType(MaterialSwipeRefresh),
      ) as SwipeRefreshBaseState<MaterialSwipeRefresh>;

      expect(state.currentState, materialWidget.initState);
    },
  );

  testWidgets(
    'SwipeRefresh.material widget with childrenDelegate as argument does not break',
    (tester) async {
      final scrollController = ScrollController();

      final materialWidget = MaterialSwipeRefresh(
        stateStream: stream,
        onRefresh: onRefreshFunction,
        childrenDelegate: sliverChildDelegate,
        scrollController: scrollController,
      );

      final materialSwipeRefresh = makeTestableWidget(materialWidget);
      await tester.pumpWidget(materialSwipeRefresh);

      expect(
        find.text('Test'),
        findsOneWidget,
      );
    },
  );
}

class MockOnRefreshFunction extends Mock {
  void call();
}

class TestSliverChildListDelegate extends SliverChildListDelegate {
  TestSliverChildListDelegate(List<Widget> children) : super(children);
}

const _listColors = [
  Colors.blue,
  Colors.green,
  Colors.red,
  Colors.amber,
];
