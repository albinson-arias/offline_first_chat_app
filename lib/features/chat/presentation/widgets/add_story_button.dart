import 'package:flutter/material.dart';

class AddStoryButton extends StatelessWidget {
  const AddStoryButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.blue.withOpacity(0.3),
            ),
          ),
          child: const Icon(Icons.add),
        ),
        const SizedBox(height: 6),
        const Text(
          'Add Story',
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
