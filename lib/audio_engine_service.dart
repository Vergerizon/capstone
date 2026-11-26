import 'src/audio/audio_engine_backend.dart';

class AudioEngineService {
  static final AudioEngineBackend _backend = OboeAudioEngineBackend();

  static bool get isSupportedPlatform =>
      _backend is OboeAudioEngineBackend &&
      (_backend as OboeAudioEngineBackend).isSupportedPlatform;

  static Future<bool> startEngine() => _backend.startEngine();

  static Future<void> stopEngine() => _backend.stopEngine();

  static Future<void> playSample(String assetPath) =>
      _backend.playSample(assetPath);

  static Future<void> playNote(double frequency) =>
      _backend.playNote(frequency);

  static Future<void> stopNote() => _backend.stopNote();
}
