import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyAlertDialog{

  static void showMyDialog({
    required BuildContext context,
    required String title,
    required String content,
    required Function() tabNo,
    required Function() tabYes,
  }){
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        // Add a title to the dialog with the 'Logout?' text, using the textTheme to apply styles
        title: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        // Add content to the dialog with the 'Are you sure want to logout?' text, using the textTheme to apply styles
        content: Text(
          content,
          style: TextStyle(
              color: Colors.black
          ),
        ),
        // Add two actions to the dialog: Cancel and Logout
        actions: [
          CupertinoDialogAction(
            child: Text(
              'Cancel',
              style: TextStyle(
                  color: Colors.red
              ),
            ),
            onPressed: tabNo,
          ),
          CupertinoDialogAction(
            child: Text(
              'Yes',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            isDestructiveAction: true,
            onPressed: tabYes,
          ),
        ],
      ),
    );
  }

}