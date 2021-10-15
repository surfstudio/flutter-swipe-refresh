import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:swipe_refresh/swipe_refresh.dart';
import 'package:swipe_refresh/utills/platform_wrapper.dart';

import 'test_utils.dart';

void main() {
  late StreamController<SwipeRefreshState> _controller;
  late Stream<SwipeRefreshState> stream;

  late MockPlatformWrapper platformWrapper;

  setUp(() {
    _controller = StreamController<SwipeRefreshState>.broadcast();
    stream = _controller.stream;

    platformWrapper = MockPlatformWrapper();
  });

  tearDown(() async {
    await _controller.close();
  });

  Future<void> _onRefresh() async {
    await Future<void>.delayed(const Duration(seconds: 3));

    _controller.sink.add(SwipeRefreshState.hidden);
  }

  final listColors = [
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.amber,
  ];

  testWidgets(
    'SwipeRefresh.builder with itemBuilder as argument builds normally(iOS platform as example)',
    (tester) async {
      when(() => platformWrapper.getPlatform()).thenReturn(TargetPlatform.iOS);

      final testWidget = makeTestableWidget(
        SwipeRefresh.builder(
          stateStream: stream,
          onRefresh: _onRefresh,
          itemCount: listColors.length,
          itemBuilder: (_, index) => Container(
            color: listColors[index],
            height: 100,
          ),
          platform: platformWrapper,
        ),
      );

      await tester.pumpWidget(testWidget);

      expect(() => testWidget, returnsNormally);

      expect(find.byType(Container), findsNWidgets(4));
    },
  );
}

class MockPlatformWrapper extends Mock implements PlatformWrapper {}
