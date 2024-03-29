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

import 'package:flutter/foundation.dart';

/// Wrapper for Platform io.
class PlatformWrapper {
  bool get isCupertino => _cupertino.contains(defaultTargetPlatform);

  bool get isMaterial => _material.contains(defaultTargetPlatform);

  const PlatformWrapper();
}

const _cupertino = <TargetPlatform>[
  TargetPlatform.iOS,
  TargetPlatform.macOS,
];

const _material = <TargetPlatform>[
  TargetPlatform.android,
  TargetPlatform.fuchsia,
  TargetPlatform.linux,
  TargetPlatform.windows,
];
