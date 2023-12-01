import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final Function()? onTap;
  const SecondaryButton({super.key, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        onTap?.call();
      },
      style: OutlinedButton.styleFrom(
          backgroundColor: const Color(0xff14284F),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          side: const BorderSide(color: Color(0xff25A8CB))),
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Text(
          "TOPICS",
          style: TextStyle(
            color: Color(0xff25A8CB),
          ),
        ),
      ),
    );
  }
}
