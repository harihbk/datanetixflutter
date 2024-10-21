import 'package:flutter/material.dart';

@immutable
class MainColors extends ThemeExtension<MainColors> {
  final Color? button;
  final Color? altButton;
  final Color? appBarButton;
  final Color? altText;
  final Color? textLight;
  final Color? textMedium;
  final Color? textColor;
  final Color? textLink;
  final Color? dialogErrorEmojiBackground;
  final Color? dialogInfoEmojiBackground;
  final Color? chatMe;
  final Color? chatOther;
  final Color? tabBar;
  final Color? tabBarActive;
  final Color? tabBarInactive;
  final Color? tabBarText;
  final Color? tabBarTextActive;
  final Color? tabBarBorder;
  final Color? notificationRead;
  final Color? notificationUnRead;
  final Color? filterPill;

  const MainColors({
    required this.button,
    required this.altButton,
    required this.appBarButton,
    required this.altText,
    required this.textLight,
    required this.textMedium,
    required this.textColor,
    required this.textLink,
    required this.dialogErrorEmojiBackground,
    required this.dialogInfoEmojiBackground,
    required this.chatMe,
    required this.chatOther,
    required this.tabBar,
    required this.tabBarActive,
    required this.tabBarInactive,
    required this.tabBarText,
    required this.tabBarTextActive,
    required this.tabBarBorder,
    required this.notificationRead,
    required this.notificationUnRead,
    required this.filterPill,
  });

  @override
  MainColors copyWith({
    Color? button,
    Color? altButton,
    Color? appBarButton,
    Color? altText,
    Color? textLight,
    Color? textMedium,
    Color? textColor,
    Color? textLink,
    Color? dialogErrorEmojiBackground,
    Color? dialogInfoEmojiBackground,
    Color? chatMe,
    Color? chatOther,
    Color? tabBar,
    Color? tabBarActive,
    Color? tabBarInactive,
    Color? tabBarText,
    Color? tabBarTextActive,
    Color? tabBarBorder,
    Color? notificationRead,
    Color? notificationUnRead,
    Color? filterPill,
  }) {
    return MainColors(
      button: button ?? this.button,
      altButton: altButton ?? this.altButton,
      appBarButton: appBarButton ?? this.appBarButton,
      altText: altText ?? this.altText,
      textLight: textLight ?? this.textLight,
      textMedium: textMedium ?? this.textMedium,
      textColor: textColor ?? this.textColor,
      textLink: textLink ?? this.textLink,
      dialogErrorEmojiBackground:
          dialogErrorEmojiBackground ?? this.dialogErrorEmojiBackground,
      dialogInfoEmojiBackground:
          dialogInfoEmojiBackground ?? this.dialogInfoEmojiBackground,
      chatMe: chatMe ?? this.chatMe,
      chatOther: chatOther ?? this.chatOther,
      tabBar: tabBar ?? this.tabBar,
      tabBarActive: tabBarActive ?? this.tabBarActive,
      tabBarInactive: tabBarInactive ?? this.tabBarInactive,
      tabBarText: tabBarText ?? this.tabBarText,
      tabBarTextActive: tabBarTextActive ?? this.tabBarTextActive,
      tabBarBorder: tabBarBorder ?? this.tabBarBorder,
      notificationRead: notificationRead ?? this.notificationRead,
      notificationUnRead: notificationUnRead ?? this.notificationUnRead,
      filterPill: filterPill ?? this.filterPill,
    );
  }

  @override
  MainColors lerp(ThemeExtension<MainColors>? other, double t) {
    if (other is! MainColors) {
      return this;
    }
    return MainColors(
      button: Color.lerp(button, other.button, t),
      altButton: Color.lerp(altButton, other.altButton, t),
      appBarButton: Color.lerp(appBarButton, other.appBarButton, t),
      altText: Color.lerp(altText, other.altText, t),
      textLight: Color.lerp(textLight, other.textLight, t),
      textMedium: Color.lerp(textMedium, other.textMedium, t),
      textColor: Color.lerp(textColor, other.textColor, t),
      textLink: Color.lerp(textLink, other.textLink, t),
      dialogErrorEmojiBackground: Color.lerp(
          dialogErrorEmojiBackground, other.dialogErrorEmojiBackground, t),
      dialogInfoEmojiBackground: Color.lerp(
          dialogInfoEmojiBackground, other.dialogInfoEmojiBackground, t),
      chatMe: Color.lerp(chatMe, other.chatMe, t),
      chatOther: Color.lerp(chatOther, other.chatOther, t),
      tabBar: Color.lerp(tabBar, other.tabBar, t),
      tabBarActive: Color.lerp(tabBarActive, other.tabBarActive, t),
      tabBarInactive: Color.lerp(tabBarInactive, other.tabBarInactive, t),
      tabBarText: Color.lerp(tabBarText, other.tabBarText, t),
      tabBarTextActive: Color.lerp(tabBarTextActive, other.tabBarTextActive, t),
      tabBarBorder: Color.lerp(tabBarBorder, other.tabBarBorder, t),
      notificationRead: Color.lerp(notificationRead, other.notificationRead, t),
      notificationUnRead:
          Color.lerp(notificationUnRead, other.notificationUnRead, t),
      filterPill: Color.lerp(filterPill, other.filterPill, t),
    );
  }
}
