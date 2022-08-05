import 'package:flutter/material.dart';
import 'package:news_app/shared/styles/colors.dart';

ThemeData lightMode = ThemeData(
  primarySwatch: mainColor,
  fontFamily: 'Kanit',
  appBarTheme: const AppBarTheme(
    color: Colors.white,
    elevation: 0,
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    iconTheme: IconThemeData(color: Colors.black),
  ),
  scaffoldBackgroundColor: Colors.white,
  textTheme: const TextTheme(
      titleMedium: TextStyle(
          fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
      bodyMedium: TextStyle(fontSize: 14, color: Colors.black)),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: mainColor,
      unselectedLabelStyle: const TextStyle(color: Colors.black45),
      type: BottomNavigationBarType.fixed),
);
ThemeData darkMode = ThemeData(
  primarySwatch: mainColor,
  fontFamily: 'Kanit',
  appBarTheme: const AppBarTheme(
    color: Colors.black,
    elevation: 0,
    actionsIconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    iconTheme: IconThemeData(color: Colors.white),
  ),
  scaffoldBackgroundColor: Colors.black,
  textTheme: const TextTheme(
      titleMedium: TextStyle(
          fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      bodyMedium: TextStyle(fontSize: 14, color: Colors.white)),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: mainColor,
      backgroundColor: Colors.black,
      unselectedIconTheme: const IconThemeData(
        color: Colors.grey,
      ),
      unselectedLabelStyle: const TextStyle(color: Colors.white),
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed),
);
