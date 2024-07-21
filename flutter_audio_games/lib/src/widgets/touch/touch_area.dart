import 'package:flutter/material.dart';

/// The type of an event generated by [TouchArea].
enum TouchAreaEvent {
  /// A touch has started.
  touch,

  /// The touch has ended.
  release,
}

/// An area which can be touched.
class TouchArea extends StatelessWidget {
  /// Create an instance.
  const TouchArea({
    required this.description,
    required this.onTouch,
    this.textStyle = const TextStyle(fontSize: 20),
    super.key,
  });

  /// The description of the area.
  final String description;

  /// The function to call when touch starts.
  final void Function(TouchAreaEvent event) onTouch;

  /// The text style to use.
  final TextStyle? textStyle;

  /// Build the widget.
  @override
  Widget build(final BuildContext context) => Expanded(
        child: Semantics(
          excludeSemantics: true,
          inMutuallyExclusiveGroup: true,
          label: description,
          child: Stack(
            children: [
              GestureDetector(
                onPanDown: (final details) =>
                    onTouch.call(TouchAreaEvent.touch),
                onPanEnd: (final details) =>
                    onTouch.call(TouchAreaEvent.release),
              ),
              IgnorePointer(
                child: Text(
                  description,
                  style: textStyle,
                ),
              ),
            ],
          ),
        ),
      );
}
