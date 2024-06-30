import 'sound.dart';

/// The type of a [Sound].
enum SoundType {
  /// The sound should be loaded from an asset.
  asset,

  /// The sound should be loaded from a file.
  file,

  /// The sound should be loaded from a url.
  url,

  /// A sound will be created by converting the path to speech.
  tts,
}
