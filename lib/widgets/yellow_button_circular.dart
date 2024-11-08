import 'package:flutter/material.dart';

class YellowButtonWithCircular extends StatelessWidget {

  final String label;
  final Function() onPressed;
  final double width;

  const YellowButtonWithCircular({
    super.key, required this.label, required this.onPressed, required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: MediaQuery.of(context).size.width * width,
      decoration: BoxDecoration(
          color: Colors.yellow,
          borderRadius: BorderRadius.circular(25)
      ),
      child: MaterialButton(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 15,width: 15,child: CircularProgressIndicator(color: Colors.white,),),
            SizedBox(
              width: 20,
            ),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16
              ),
            ),
          ],
        )
      ),
    );
  }
}