import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 100.0, bottom: 20.0),
      child: SizedBox(
        height: 200,
        width: 200,
        child: Image.asset('assets/images/icon.png', fit: BoxFit.contain),
      ),
    );
  }
}
