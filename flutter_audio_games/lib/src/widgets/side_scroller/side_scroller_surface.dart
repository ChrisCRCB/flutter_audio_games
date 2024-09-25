import 'dart:async';

import 'side_scroller.dart';

/// The type of side scroller move functions for players.
typedef SideScrollerSurfaceAction = FutureOr<void> Function(
  SideScrollerState state,
);

/// A surface in a [SideScroller] level.
class SideScrollerSurface {
  /// Create an instance.
  const SideScrollerSurface({
    required this.name,
    this.width = 10,
    this.playerMoveSpeed = const Duration(milliseconds: 500),
    this.onPlayerMove,
    this.onPlayerEnter,
    this.onPlayerLeave,
    this.onPlayerActivate,
  }) : assert(width > 0, 'Surface `width`s must be positive.');

  /// The name of this surface.
  final String name;

  /// The width of this surface.
  ///
  /// The [width] value will be used to make surfaces contiguous.
  final int width;

  /// How quickly the player can move across this surface.
  final Duration playerMoveSpeed;

  /// The function to call when the player moves on this surface.
  final SideScrollerSurfaceAction? onPlayerMove;

  /// The function to call when the player enters this surface.
  final SideScrollerSurfaceAction? onPlayerEnter;

  /// The function to call when the player leaves this surface.
  final SideScrollerSurfaceAction? onPlayerLeave;

  /// The function to call when the player activates this level.
  final SideScrollerSurfaceAction? onPlayerActivate;
}
