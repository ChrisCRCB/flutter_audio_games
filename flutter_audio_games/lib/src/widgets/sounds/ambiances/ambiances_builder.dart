import 'package:backstreets_widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_soloud/flutter_soloud.dart';

import '../../../extensions.dart';
import '../../../sounds/sound.dart';

/// A widget which plays [ambiances].
class AmbiancesBuilder extends StatefulWidget {
  /// Create an instance.
  const AmbiancesBuilder({
    required this.ambiances,
    required this.builder,
    this.fadeInTime,
    this.fadeOutTime,
    super.key,
  });

  /// The ambiances to play.
  final List<Sound> ambiances;

  /// The widget below this widget in the tree.
  final Widget Function(BuildContext context, List<SoundHandle> handles)
      builder;

  /// The fade in time.
  final Duration? fadeInTime;

  /// The fade out time.
  final Duration? fadeOutTime;

  /// Create state for this widget.
  @override
  AmbiancesBuilderState createState() => AmbiancesBuilderState();
}

/// State for [AmbiancesBuilder].
class AmbiancesBuilderState extends State<AmbiancesBuilder>
    with WidgetsBindingObserver {
  /// The ambiance handles.
  late final List<SoundHandle> handles;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    handles = [];
    WidgetsBinding.instance.addObserver(this);
  }

  /// Load the ambiances.
  Future<void> loadAmbiances() async {
    for (final handle in handles) {
      await handle.stop();
    }
    handles.clear();
    final fadeInTime = widget.fadeInTime;
    for (final ambiance in widget.ambiances) {
      if (mounted) {
        final handle = await context.playSound(
          ambiance.copyWith(volume: fadeInTime == null ? null : 0.0),
        );
        if (mounted) {
          handle.maybeFade(fadeTime: fadeInTime, to: ambiance.volume);
          handles.add(handle);
        } else {
          await handle?.stop();
        }
      }
    }
  }

  /// Dispose of the widget.
  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    for (final handle in handles) {
      handle.stop(fadeOutTime: widget.fadeOutTime);
    }
  }

  /// Respond to the app changing state.
  @override
  void didChangeAppLifecycleState(final AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    final bool pause;
    if (state == AppLifecycleState.paused) {
      pause = true;
    } else if (state == AppLifecycleState.resumed) {
      pause = false;
    } else {
      return; // Don't do anything.
    }
    for (final handle in handles) {
      context.soLoud.setPause(handle, pause);
    }
  }

  /// Build a widget.
  @override
  Widget build(final BuildContext context) {
    final future = loadAmbiances();
    return SimpleFutureBuilder(
      future: future,
      done: (final context, final value) => widget.builder(context, handles),
      loading: () => widget.builder(context, []),
      error: ErrorListView.withPositional,
    );
  }
}
