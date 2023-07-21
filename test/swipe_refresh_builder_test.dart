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

  final listColors = [
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.amber,
  ];

  testWidgets(
    'SwipeRefresh.builder with itemBuilder as argument builds normally(iOS platform as example)',
    (tester) async {
      when(() => platformWrapper.isAndroid).thenReturn(false);
      when(() => platformWrapper.isIOS).thenReturn(true);

      final testWidget = makeTestableWidget(
        SwipeRefresh.builder(
          stateStream: stream,
          onRefresh: onRefresh,
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
