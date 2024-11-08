import 'package:flutter/material.dart';

class CustomFieldWithBorder extends StatelessWidget {
  const CustomFieldWithBorder({super.key, required this.controller, required this.hint, required this.iconData,this.type});
  final TextEditingController controller;
  final String hint;
  final IconData iconData;
  final TextInputType? type;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: type ?? TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
            color: Colors.grey.withOpacity(.7), fontWeight: FontWeight.bold
        ),
        contentPadding: EdgeInsets.fromLTRB(0, 20, 0, 20),
        fillColor: Colors.white,
        prefixIcon: Icon(
          iconData,
          color: Colors.grey,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: BorderSide(
            color: Colors.blue,
            width: 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4.0),
          borderSide: BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
        errorBorder: OutlineInputBorder( //<-- SEE HERE
          borderSide: BorderSide(
              width: 1, color: Colors.redAccent),
        ),
        // icon: Container(
        //     margin: const EdgeInsets.only(top: 10),
        //     child: Icon(
        //       iconData,
        //       color: Colors.grey,
        //     )
        // ),
      ),
    );
  }
}
