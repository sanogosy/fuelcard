import 'package:flutter/material.dart';


class AppBarBackButton extends StatelessWidget {
  const AppBarBackButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: (){
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.arrow_back_ios_new,
          color: Colors.black,
        )
    );
  }
}

class YellowBackButton extends StatelessWidget {
  const YellowBackButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: (){
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.arrow_back_ios_new,
          color: Colors.yellow,
        )
    );
  }
}

class AppBarTitle extends StatelessWidget {

  final String title;

  const AppBarTitle({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
          color: Colors.black,
          fontFamily: 'Acme',
          fontSize: 28,
          letterSpacing: 1.5
      ),
    );
  }
}