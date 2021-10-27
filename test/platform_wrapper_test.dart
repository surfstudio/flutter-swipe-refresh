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

import 'package:flutter_test/flutter_test.dart';
import 'package:swipe_refresh/utills/platform_wrapper.dart';

void main() {
  late PlatformWrapper platformWrapper;

  setUp(() {
    platformWrapper = PlatformWrapper();
  });

  test(
    'Method isAndroid should return false',
    () {
      final platform = platformWrapper.isAndroid();

      expect(platform, false);
    },
  );

  test(
    'Method isIOS should return false',
        () {
      final platform = platformWrapper.isIOS();

      expect(platform, false);
    },
  );
}
