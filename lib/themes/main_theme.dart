import '/themes/main_text_theme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'main_colors.dart';

MainColors colors(context) => Theme.of(context).extension<MainColors>()!;

TextStyle buildTextStyle(Color color, {double? size}) {
  return TextStyle(
    color: color,
    fontSize: size ?? 16.0,
  );
}

OutlineInputBorder buildBorder(Color color) {
  return OutlineInputBorder(
    borderRadius: const BorderRadius.all(Radius.circular(15.0)),
    borderSide: BorderSide(
      color: color,
      width: 1.0,
    ),
  );
}

class MainTheme {
  // prevent instantiating the class by making the constructor private
  MainTheme._();

  static ThemeData get lightTheme {
    const Color _primary = Color(0xffFFD500);
    const Color _secondary = Color(0xff8AC353);
    const Color _button = Color(0xff0B1731);

    return ThemeData(
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: _primary,
        secondary: _secondary,
        brightness: Brightness.light,
      ),
      extensions: const <ThemeExtension<MainColors>>[
        MainColors(
          button: _button,
          altButton: Colors.black,
          appBarButton: Colors.white,
          altText: Colors.white,
          textLight: Colors.black54,
          textMedium: Colors.black87,
          textColor: _primary,
          textLink: Colors.blue,
          dialogErrorEmojiBackground: _secondary,
          dialogInfoEmojiBackground: Colors.blue,
          chatMe: Color.fromARGB(255, 200, 230, 201),
          chatOther: Color.fromARGB(255, 187, 222, 251),
          tabBar: Colors.white,
          tabBarActive: _primary,
          tabBarInactive: _primary,
          tabBarText: Colors.white,
          tabBarTextActive: Colors.white,
          tabBarBorder: Colors.black12,
          notificationRead: Colors.white,
          notificationUnRead: Color(0xffF6CBD1),
          filterPill: Color(0xffE0E0E0),
        ),
      ],
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xff0B1731),
        foregroundColor: Colors.white,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white, size: 25.0),
      ),
      scaffoldBackgroundColor: const Color(0xffF7F7F7),
      visualDensity: VisualDensity.compact,
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          foregroundColor: Colors.white,
          backgroundColor: _button,
          disabledForegroundColor: Colors.grey,
          minimumSize: const Size(
            100.0,
            50.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.all(16.0),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        enabledBorder: buildBorder(Colors.grey[600]!),
        errorBorder: buildBorder(_secondary),
        focusedErrorBorder: buildBorder(_secondary),
        focusedBorder: buildBorder(_primary),
        disabledBorder: buildBorder(Colors.grey[400]!),
        suffixStyle: buildTextStyle(Colors.black),
        counterStyle: buildTextStyle(Colors.grey, size: 12.0),
        floatingLabelStyle: buildTextStyle(Colors.black),
        errorStyle: buildTextStyle(_secondary, size: 12.0),
        helperStyle: buildTextStyle(Colors.black, size: 12.0),
        hintStyle: buildTextStyle(Colors.grey),
        labelStyle: buildTextStyle(Colors.black),
        prefixStyle: buildTextStyle(Colors.black),
        fillColor: Colors.white,
        filled: true,
        isDense: false,
      ),
      textTheme: GoogleFonts.latoTextTheme(MainTextTheme.lightTextTheme),
      dialogBackgroundColor: Colors.white,
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  static ThemeData get darkTheme {
    const Color _primary = Color(0xff573D82);
    const Color _secondary = Color(0xffEB3278);
    const Color _button = Color(0xff5D5CC4);

    return ThemeData(
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: _primary,
        secondary: _secondary,
        brightness: Brightness.dark,
      ),
      extensions: const <ThemeExtension<MainColors>>[
        MainColors(
          button: _button,
          altButton: Colors.black,
          appBarButton: Colors.white,
          altText: Colors.black,
          textLight: Colors.white54,
          textMedium: Colors.white70,
          textColor: _primary,
          textLink: Colors.blue,
          dialogErrorEmojiBackground: _secondary,
          dialogInfoEmojiBackground: Colors.blue,
          chatMe: Color.fromARGB(255, 200, 230, 201),
          chatOther: Color.fromARGB(255, 187, 222, 251),
          tabBar: _primary,
          tabBarActive: Colors.white,
          tabBarInactive: Colors.white,
          tabBarText: _primary,
          tabBarTextActive: _primary,
          tabBarBorder: Colors.black12,
          notificationRead: Colors.white,
          notificationUnRead: Color(0xffF6CBD1),
          filterPill: Color(0xffE0E0E0),
        ),
      ],
      appBarTheme: const AppBarTheme(
        backgroundColor: _primary,
        foregroundColor: Colors.white,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white, size: 25.0),
      ),
      // scaffoldBackgroundColor: const Color(0xffF7F7F7),
      visualDensity: VisualDensity.compact,
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          foregroundColor: Colors.white,
          backgroundColor: _button,
          disabledForegroundColor: Colors.grey,
          minimumSize: const Size(
            100.0,
            50.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          textStyle: const TextStyle(
            color: Colors.white,
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.all(16.0),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        enabledBorder: buildBorder(Colors.grey[600]!),
        errorBorder: buildBorder(_secondary),
        focusedErrorBorder: buildBorder(_secondary),
        focusedBorder: buildBorder(_primary),
        disabledBorder: buildBorder(Colors.grey[400]!),
        suffixStyle: buildTextStyle(Colors.black),
        counterStyle: buildTextStyle(Colors.grey, size: 12.0),
        floatingLabelStyle: buildTextStyle(Colors.black),
        errorStyle: buildTextStyle(_secondary, size: 12.0),
        helperStyle: buildTextStyle(Colors.black, size: 12.0),
        hintStyle: buildTextStyle(Colors.grey),
        labelStyle: buildTextStyle(Colors.black),
        prefixStyle: buildTextStyle(Colors.black),
        fillColor: Colors.white,
        filled: true,
        isDense: false,
      ),
      textTheme: GoogleFonts.latoTextTheme(MainTextTheme.lightTextTheme),
      dialogBackgroundColor: Colors.white,
      dialogTheme: DialogTheme(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
