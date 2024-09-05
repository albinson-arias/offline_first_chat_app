import 'package:flutter/material.dart';

class StoryButton extends StatelessWidget {
  const StoryButton({
    required this.onTap,
    required this.name,
    required this.imageUrl,
    super.key,
  });
  final VoidCallback onTap;
  final String name;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 12,
      ),
      child: Column(
        children: [
          Container(
            height: 50,
            width: 50,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.blue,
              ),
            ),
            child: ClipOval(
              child: Image.asset(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 6),
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 80,
              maxHeight: 35,
            ),
            child: Text(
              name,
              textAlign: TextAlign.center,
              overflow: TextOverflow.clip,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
