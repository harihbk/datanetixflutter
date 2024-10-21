import 'package:flutter/material.dart';

class BasicTextField extends StatelessWidget {
  final TextEditingController controller;
  final String name;
  final String errorString;
  final bool password;
  final bool email;
  final bool label;
  final Color labelColor;
  final IconData? icon;
  final bool expand;

  const BasicTextField({
    Key? key,
    required this.controller,
    required this.name,
    required this.errorString,
    this.password = false,
    this.email = false,
    this.label = false,
    this.labelColor = Colors.black,
    this.icon,
    this.expand = false,
  }) : super(key: key);

  final double corner = 10.0;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textCapitalization: TextCapitalization.none,
      autocorrect: false,
      keyboardType:
          (email) ? TextInputType.emailAddress : TextInputType.visiblePassword,
      obscureText: password,
      maxLines: (expand) ? null : 1,
      decoration: InputDecoration(
        errorText: (errorString.isNotEmpty) ? errorString : null,
        errorMaxLines: 3,
        hintText: name,
        labelText: (label) ? name : null,
        labelStyle: (label) ? TextStyle(color: labelColor) : null,
        prefixIcon: (icon != null) ? Icon(icon, color: labelColor) : null,
      ),
    );
  }
}
