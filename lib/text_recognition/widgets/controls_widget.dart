import 'package:flutter/material.dart';

class ControlsWidget extends StatelessWidget {
  final VoidCallback onClickedPickImage;
  final VoidCallback onClickedScanText;
  final VoidCallback onClickedClear;

  const ControlsWidget({
    super.key,
    required this.onClickedPickImage,
    required this.onClickedScanText,
    required this.onClickedClear,
  });

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF3A96E2)),
            onPressed: onClickedPickImage,
            child: const Text('Pick Image'),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0B3B8D)),
            onPressed: onClickedScanText,
            child: const Text('Scan For Text'),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF31147E)),
            onPressed: onClickedClear,
            child: const Text('Clear'),
          )
        ],
      );
}
