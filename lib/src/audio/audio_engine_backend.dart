import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

abstract class AudioEngineBackend {
  Future<bool> startEngine();
  Future<void> stopEngine();
  Future<void> playSample(String assetPath);
  Future<void> playNote(double frequency);
  Future<void> stopNote();
}

class OboeAudioEngineBackend implements AudioEngineBackend {
  static const MethodChannel _channel = MethodChannel(
    'com.example.capstone/audio_engine',
  );

  bool get isSupportedPlatform => !kIsWeb && Platform.isAndroid;

  @override
  Future<bool> startEngine() async {
    if (!isSupportedPlatform) {
      debugPrint(
        'AudioEngine is only natively implemented on Android currently.',
      );
      return false;
    }
    try {
      final bool? result = await _channel.invokeMethod<bool>(
        'startAudioEngine',
      );
      return result ?? false;
    } on PlatformException catch (e) {
      debugPrint('Error starting audio engine: ${e.message}');
      return false;
    }
  }

  @override
  Future<void> stopEngine() async {
    if (!isSupportedPlatform) return;
    try {
      await _channel.invokeMethod<void>('stopAudioEngine');
    } on PlatformException catch (e) {
      debugPrint('Error stopping audio engine: ${e.message}');
    }
  }

  @override
  Future<void> playSample(String assetPath) async {
    if (!isSupportedPlatform) return;
    try {
      await _channel.invokeMethod<void>('playSample', {'assetPath': assetPath});
    } on PlatformException catch (e) {
      debugPrint('Error playing sample: ${e.message}');
    }
  }

  @override
  Future<void> playNote(double frequency) async {
    if (!isSupportedPlatform) return;
    try {
      await _channel.invokeMethod<void>('playNote', {'frequency': frequency});
    } on PlatformException catch (e) {
      debugPrint('Error playing note: ${e.message}');
    }
  }

  @override
  Future<void> stopNote() async {
    if (!isSupportedPlatform) return;
    try {
      await _channel.invokeMethod<void>('stopNote');
    } on PlatformException catch (e) {
      debugPrint('Error stopping note: ${e.message}');
    }
  }
}
