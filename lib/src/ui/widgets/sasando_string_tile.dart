import 'package:material_ui/material_ui.dart';

import '../../core/models/sasando_string.dart';

class SasandoStringTile extends StatelessWidget {
  final SasandoString stringItem;
  final bool isPlaying;
  final VoidCallback onPress;
  final VoidCallback onRelease;

  const SasandoStringTile({
    super.key,
    required this.stringItem,
    required this.isPlaying,
    required this.onPress,
    required this.onRelease,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => onPress(),
      onTapUp: (_) => onRelease(),
      onTapCancel: () => onRelease(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: isPlaying
              ? Colors.amber.withValues(alpha: 0.3)
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isPlaying ? Colors.amberAccent : Colors.white24,
            width: isPlaying ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isPlaying ? Colors.amber : Colors.white12,
              ),
              child: Text(
                stringItem.note,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isPlaying ? Colors.black : Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'String ${stringItem.index}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${stringItem.frequency.toStringAsFixed(2)} Hz',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),
            Icon(
              isPlaying ? Icons.volume_up : Icons.music_note,
              color: isPlaying ? Colors.amberAccent : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
