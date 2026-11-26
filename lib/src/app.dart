import 'package:material_ui/material_ui.dart';

import 'audio/audio_engine_backend.dart';
import 'ui/screens/sasando_home_screen.dart';

class SasandoApp extends StatelessWidget {
  final AudioEngineBackend? audioEngine;

  const SasandoApp({super.key, this.audioEngine});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Sasando',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6B4226),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: SasandoHomeScreen(
        audioEngine: audioEngine ?? OboeAudioEngineBackend(),
      ),
    );
  }
}
