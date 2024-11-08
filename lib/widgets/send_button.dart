import 'package:flutter/material.dart';

class SendButton extends StatelessWidget {

  final String mainButtonLabel;
  final Function() onPressed;

  const SendButton({
    super.key, required this.mainButtonLabel, required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Material(
        color: Colors.purple,
        borderRadius: BorderRadius.circular(25),
        child: MaterialButton(
          minWidth: double.infinity,
          onPressed: onPressed,
          child: Text(
            mainButtonLabel,
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white
            ),
          ),
        ),
      ),
    );
  }
}