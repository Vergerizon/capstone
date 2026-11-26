import 'package:material_ui/material_ui.dart';

class NoteDisplayCard extends StatelessWidget {
  final String? activeNote;
  final bool isEngineRunning;
  final VoidCallback onToggleEngine;

  const NoteDisplayCard({
    super.key,
    required this.activeNote,
    required this.isEngineRunning,
    required this.onToggleEngine,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Active Note',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    activeNote ?? 'None',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.amberAccent,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: onToggleEngine,
                icon: Icon(isEngineRunning ? Icons.pause : Icons.play_arrow),
                label: Text(isEngineRunning ? 'Stop Engine' : 'Start Engine'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
