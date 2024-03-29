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
  late StreamController<SwipeRefreshState> controller;
  late Stream<SwipeRefreshState> stream;
  late MockPlatformWrapper platformWrapper;
  final children = _listColors
      .map((e) => Container(
            color: e,
            height: 100,
          ))
      .toList();

  setUp(() {
    controller = StreamController<SwipeRefreshState>.broadcast();
    stream = controller.stream;

    platformWrapper = MockPlatformWrapper();
  });

  tearDown(() async {
    await controller.close();
  });

  Future<void> onRefresh() async {
    await Future<void>.delayed(const Duration(seconds: 3));

    controller.sink.add(SwipeRefreshState.hidden);
  }

  testWidgets(
    'When call SwipeRefresh.adaptive on Android platform should build MaterialSwipeRefresh',
    (tester) async {
      when(() => platformWrapper.isMaterial).thenReturn(true);
      when(() => platformWrapper.isCupertino).thenReturn(false);

      final adaptiveSwipeRefresh = makeTestableWidget(
        SwipeRefresh.adaptive(
          stateStream: stream,
          onRefresh: () {
            onRefresh().ignore();
          },
          children: children,
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
      when(() => platformWrapper.isMaterial).thenReturn(false);
      when(() => platformWrapper.isCupertino).thenReturn(true);

      final adaptiveSwipeRefresh = makeTestableWidget(
        SwipeRefresh.adaptive(
          stateStream: stream,
          onRefresh: () {
            onRefresh().ignore();
          },
          children: children,
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

const _listColors = [
  Colors.blue,
  Colors.green,
  Colors.red,
  Colors.amber,
];
