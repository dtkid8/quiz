import 'package:flutter/material.dart';

class IconTextButton extends StatelessWidget {
  final String text;
  final Function()? onTap;
  final IconData icon;
  final Color iconColor;
  const IconTextButton({
    super.key,
    required this.text,
    this.onTap,
    required this.icon,
    this.iconColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap?.call();
      },
      child: Row(
        children: [
          Icon(
            icon,
            color: iconColor,
          ),
          Text(
            text,
            style: const TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }
}
