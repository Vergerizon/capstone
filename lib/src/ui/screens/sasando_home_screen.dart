import 'package:material_ui/material_ui.dart';

import '../../audio/audio_engine_backend.dart';
import '../../core/constants/sasando_constants.dart';
import '../../core/models/sasando_string.dart';
import '../widgets/engine_status_badge.dart';
import '../widgets/note_display_card.dart';
import '../widgets/sasando_string_tile.dart';

class SasandoHomeScreen extends StatefulWidget {
  final AudioEngineBackend audioEngine;

  const SasandoHomeScreen({super.key, required this.audioEngine});

  @override
  State<SasandoHomeScreen> createState() => _SasandoHomeScreenState();
}

class _SasandoHomeScreenState extends State<SasandoHomeScreen> {
  bool _isEngineRunning = false;
  String? _activeNote;

  final List<SasandoString> _strings = SasandoConstants.defaultStrings;

  @override
  void initState() {
    super.initState();
    _initEngine();
  }

  Future<void> _initEngine() async {
    final success = await widget.audioEngine.startEngine();
    if (mounted) {
      setState(() {
        _isEngineRunning = success;
      });
    }
  }

  @override
  void dispose() {
    widget.audioEngine.stopEngine();
    super.dispose();
  }

  void _onStringPressed(SasandoString string) {
    setState(() {
      _activeNote = string.note;
    });
    // Play authentic recorded Sasando sample
    widget.audioEngine.playSample(string.soundAsset);
  }

  void _onStringReleased() {
    setState(() {
      _activeNote = null;
    });
    widget.audioEngine.stopNote();
  }

  Future<void> _toggleEngine() async {
    if (_isEngineRunning) {
      await widget.audioEngine.stopEngine();
      if (mounted) {
        setState(() => _isEngineRunning = false);
      }
    } else {
      final success = await widget.audioEngine.startEngine();
      if (mounted) {
        setState(() => _isEngineRunning = success);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('E-Sasando Audio Synthesizer'),
        actions: [EngineStatusBadge(isRunning: _isEngineRunning)],
      ),
      body: SafeArea(
        child: Column(
          children: [
            NoteDisplayCard(
              activeNote: _activeNote,
              isEngineRunning: _isEngineRunning,
              onToggleEngine: _toggleEngine,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Pluck or hold a string:',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                itemCount: _strings.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final stringItem = _strings[index];
                  final isPlaying = _activeNote == stringItem.note;

                  return SasandoStringTile(
                    stringItem: stringItem,
                    isPlaying: isPlaying,
                    onPress: () => _onStringPressed(stringItem),
                    onRelease: _onStringReleased,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
