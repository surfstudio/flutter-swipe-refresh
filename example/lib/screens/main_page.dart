import 'dart:async';

import 'package:flutter/material.dart';
import 'package:swipe_refresh/swipe_refresh.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _controller = StreamController<SwipeRefreshState>.broadcast();

  Stream<SwipeRefreshState> get _stream => _controller.stream;

  Future<void> _refresh() async {
    await Future<void>.delayed(const Duration(seconds: 3));

    /// When all needed is done change state.
    _controller.sink.add(SwipeRefreshState.hidden);
  }

  @override
  void dispose() {
    _controller.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(top: 25),
          child: Column(
            children: [
              const TabBar(
                tabs: [
                  _TabWidget(style: SwipeRefreshStyle.material),
                  _TabWidget(style: SwipeRefreshStyle.cupertino),
                  _TabWidget(style: SwipeRefreshStyle.builder),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    SwipeRefresh.material(
                      stateStream: _stream,
                      onRefresh: () {
                        _refresh().ignore();
                      },
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      children: const [
                        _ExampleBodyWidget(style: SwipeRefreshStyle.material),
                      ],
                    ),
                    SwipeRefresh.cupertino(
                      stateStream: _stream,
                      onRefresh: () {
                        _refresh().ignore();
                      },
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      children: const [
                        _ExampleBodyWidget(style: SwipeRefreshStyle.cupertino),
                      ],
                    ),
                    SwipeRefresh.builder(
                      stateStream: _stream,
                      onRefresh: () {
                        _refresh().ignore();
                      },
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      itemCount: Colors.primaries.length,
                      itemBuilder: (context, index) {
                        return Container(
                          color: Colors.primaries[index],
                          height: 100,
                          child: const Center(
                            child: Text(
                              'Builder example',
                              style: TextStyle(color: white),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabWidget extends StatelessWidget {
  const _TabWidget({
    required this.style,
    Key? key,
  }) : super(key: key);

  final SwipeRefreshStyle style;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: SizedBox(
        height: 100,
        child: Center(
          child: Text(
            _getText(style),
            style: TextStyle(color: _getColor(style).withOpacity(0.5)),
          ),
        ),
      ),
    );
  }
}

class _ExampleBodyWidget extends StatelessWidget {
  const _ExampleBodyWidget({
    required this.style,
    Key? key,
  }) : super(key: key);

  final SwipeRefreshStyle style;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _getColor(style),
      height: 100,
      child: Center(
        child: Text(
          style == SwipeRefreshStyle.material
              ? 'Material example'
              : 'Cupertino example',
          style: const TextStyle(color: white),
        ),
      ),
    );
  }
}

Color _getColor(SwipeRefreshStyle style) {
  switch (style) {
    case SwipeRefreshStyle.material:
      return red;
    case SwipeRefreshStyle.cupertino:
      return blue;
    case SwipeRefreshStyle.builder:
      return green;
    default:
      return black;
  }
}

String _getText(SwipeRefreshStyle style) {
  switch (style) {
    case SwipeRefreshStyle.material:
      return 'Material';
    case SwipeRefreshStyle.cupertino:
      return 'Cupertino';
    case SwipeRefreshStyle.builder:
      return 'Builder';
    default:
      return 'SwipeRefresh';
  }
}

const white = Color(0xFFFFFFFF);
const black = Color(0xFF000000);
const red = Color(0xFFFF0000);
const green = Color(0xFF00FF00);
const blue = Color(0xFF0000FF);
