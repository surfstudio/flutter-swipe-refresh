import 'package:flutter/material.dart';

/// Wrap the child with a wrapper if the condition is true.
class ConditionalWrapper extends StatelessWidget {
  /// Create an instance [ConditionalWrapper].
  const ConditionalWrapper({
    required this.condition,
    required this.wrapper,
    required this.child,
    super.key,
  });

  /// Condition to wrap the child.
  final bool condition;

  /// Wrapper for the child.
  final Widget Function(Widget child) wrapper;

  /// Child to be wrapped.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return condition ? wrapper(child) : child;
  }
}
