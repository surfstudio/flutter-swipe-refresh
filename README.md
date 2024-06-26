# Swipe Refresh

<img src="https://raw.githubusercontent.com/surfstudio/flutter-open-source/main/assets/logo_black.png#gh-light-mode-only" width="200">
<img src="https://raw.githubusercontent.com/surfstudio/flutter-open-source/main/assets/logo_white.png#gh-dark-mode-only" width="200">

[![Build Status](https://shields.io/github/actions/workflow/status/surfstudio/flutter-swipe-refresh/on_pull_request.yml?logo=github&logoColor=white)](https://github.com/surfstudio/flutter-swipe-refresh)
[![Coverage Status](https://img.shields.io/codecov/c/github/surfstudio/flutter-swipe-refresh?logo=codecov&logoColor=white)](https://app.codecov.io/gh/surfstudio/flutter-swipe-refresh)
[![Pub Version](https://img.shields.io/pub/v/swipe_refresh?logo=dart&logoColor=white)](https://pub.dev/packages/swipe_refresh)
[![Pub Likes](https://badgen.net/pub/likes/swipe_refresh)](https://pub.dev/packages/swipe_refresh)
[![Pub popularity](https://badgen.net/pub/popularity/swipe_refresh)](https://pub.dev/packages/swipe_refresh/score)
![Flutter Platform](https://badgen.net/pub/flutter-platform/swipe_refresh)

## Overview

Widget for refresh by swipe.

- :1234: Enabled on every platform - the package is fully written on Flutter side and enabled on every platform.
- :recycle: Fully covered by tests - guaranteeing the result and expectations from this package.
- :notebook_with_decorative_cover: End-to-end documentation - every aspect of implementation is documented, so there is full understanding.
- :cow2: Support from the best Flutter experts - we are open to any enhancement ideas and contributions.

![material](https://i.ibb.co/7Kmy91f/material.gif)
![cupertino](https://i.ibb.co/smPxRp7/cupertino.gif)

Main classes:

1. [Refresh state](lib/src/swipe_refresh_state.dart)
2. [Widget for indicate swipe refresh](lib/src/swipe_refresh.dart)
3. [Widget for indicate swipe refresh Material style](lib/src/material_swipe_refresh.dart)
4. [Widget for indicate swipe refresh Cupertino style](lib/src/cupertino_swipe_refresh.dart)

## Example

### Material

Refresh indicator widget with Material Design style.

```dart
SwipeRefresh.material(
  stateStream: Stream<SwipeRefreshState>(),
  onRefresh: _refresh,
  padding: const EdgeInsets.symmetric(vertical: 10),
  children: <Widget>[ ... ],
);

Future<void> _refresh() async {
  // When all needed is done change state.
  _controller.sink.add(SwipeRefreshState.hidden);
}
```

### Cupertino

Refresh indicator widget with Cupertino Design style.

```dart
SwipeRefresh.cupertino(
  stateStream: Stream<SwipeRefreshState>(),
  onRefresh: _refresh,
  padding: const EdgeInsets.symmetric(vertical: 10),
  children: <Widget>[ ... ],
);

Future<void> _refresh() async {
  // When all needed is done change state.
  _controller.sink.add(SwipeRefreshState.hidden);
}
```

### Adaptive

Refresh indicator widget with adaptive to platform style.

```dart
SwipeRefresh.adaptive(
  stateStream: Stream<SwipeRefreshState>(),
  onRefresh: _refresh,
  padding: const EdgeInsets.symmetric(vertical: 10),
  children: <Widget>[ ... ],
);

Future<void> _refresh() async {
  // When all needed is done change state.
  _controller.sink.add(SwipeRefreshState.hidden);
}
```

### Builder

Refresh indicator widget with adaptive to platform style, and with SliverChildBuilderDelegate in childDelegate(so as not to create more child elements than are visible through Viewport).

```dart
SwipeRefresh.builder(
  stateStream:  Stream<SwipeRefreshState>(),
  onRefresh: _refresh,
  padding: const EdgeInsets.symmetric(vertical: 10),
  itemCount: Colors.primaries.length,
  itemBuilder: (context, index) {
return Container(
 ...
   );
 },
),

Future<void> _refresh() async {
  // When all needed is done change state.
  _controller.sink.add(SwipeRefreshState.hidden);
}
```

## Installation

Add `swipe_refresh` to your `pubspec.yaml` file:

```yaml
dependencies:
  swipe_refresh: $currentVersion$
```

<p>At this moment, the current version of <code>swipe_refresh</code> is <a href="https://pub.dev/packages/swipe_refresh"><img style="vertical-align:middle;" src="https://img.shields.io/pub/v/swipe_refresh.svg" alt="swipe_refresh version"></a>.</p>

## Changelog

All notable changes to this project will be documented in [this file](./CHANGELOG.md).

## Issues

To report your issues, submit them directly in the [Issues](https://github.com/surfstudio/flutter-swipe-refresh/issues) section.

## Contribute

If you would like to contribute to the package (e.g. by improving the documentation, fixing a bug or adding a cool new feature), please read our [contribution guide](./CONTRIBUTING.md) first and send us your pull request.

Your PRs are always welcome.

## How to reach us

Please feel free to ask any questions about this package. Join our community chat on Telegram. We speak English and Russian.

[![Telegram](https://img.shields.io/badge/chat-on%20Telegram-blue.svg)](https://t.me/SurfGear)

## License

[Apache License, Version 2.0](https://www.apache.org/licenses/LICENSE-2.0)
