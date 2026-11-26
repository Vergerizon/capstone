import 'package:material_ui/material_ui.dart';

class EngineStatusBadge extends StatelessWidget {
  final bool isRunning;

  const EngineStatusBadge({super.key, required this.isRunning});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Icon(
            Icons.circle,
            size: 14,
            color: isRunning ? Colors.greenAccent : Colors.redAccent,
          ),
          const SizedBox(width: 8),
          Text(
            isRunning ? 'Oboe Active' : 'Offline',
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
