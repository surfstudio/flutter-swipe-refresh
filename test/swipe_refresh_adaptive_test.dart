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
    'When call SwipeRefresh.adaptive not on Android or iOS platform should build normally with one Container',
    (tester) async {
      when(() => platformWrapper.isAndroid).thenReturn(false);
      when(() => platformWrapper.isIOS).thenReturn(false);

      final adaptiveSwipeRefresh = makeTestableWidget(
        SwipeRefresh.adaptive(
          stateStream: stream,
          onRefresh: _onRefresh,
          children: listColors
              .map(
                (e) => Container(
                  color: e,
                  height: 100,
                ),
              )
              .toList(),
          platform: platformWrapper,
        ),
      );

      await tester.pumpWidget(adaptiveSwipeRefresh);

      expect(() => adaptiveSwipeRefresh, returnsNormally);

      expect(find.byType(Container), findsOneWidget);
    },
  );

  testWidgets(
    'When call SwipeRefresh.adaptive on Android platform should build MaterialSwipeRefresh',
    (tester) async {
      when(() => platformWrapper.isAndroid).thenReturn(true);

      final adaptiveSwipeRefresh = makeTestableWidget(
        SwipeRefresh.adaptive(
          stateStream: stream,
          onRefresh: _onRefresh,
          children: listColors
              .map(
                (e) => Container(
                  color: e,
                  height: 100,
                ),
              )
              .toList(),
          platform: platformWrapper,
        ),
      );

      await tester.pumpWidget(adaptiveSwipeRefresh);

      expect(() => adaptiveSwipeRefresh, returnsNormally);

      expect(find.byType(MaterialSwipeRefresh), findsOneWidget);
    },
  );

  testWidgets(
    'When call SwipeRefresh.adaptive on iOS platform should build CupertinoSwipeRefresh',
    (tester) async {
      when(() => platformWrapper.isAndroid).thenReturn(false);
      when(() => platformWrapper.isIOS).thenReturn(true);

      final adaptiveSwipeRefresh = makeTestableWidget(
        SwipeRefresh.adaptive(
          stateStream: stream,
          onRefresh: _onRefresh,
          children: listColors
              .map(
                (e) => Container(
                  color: e,
                  height: 100,
                ),
              )
              .toList(),
          platform: platformWrapper,
        ),
      );

      await tester.pumpWidget(adaptiveSwipeRefresh);

      expect(() => adaptiveSwipeRefresh, returnsNormally);

      expect(find.byType(CupertinoSwipeRefresh), findsOneWidget);
    },
  );
}

class MockPlatformWrapper extends Mock implements PlatformWrapper {}
