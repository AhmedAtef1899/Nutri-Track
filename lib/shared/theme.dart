
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constants.dart';


// ThemeData themeDark = ThemeData(
//     scaffoldBackgroundColor: HexColor('333739'),
//     cardColor: HexColor('333739'),
//     fontFamily: 'Gelion',
//     appBarTheme:  AppBarTheme(
//         titleSpacing: 20,
//         iconTheme: const IconThemeData(
//             color: Colors.white
//         ),
//         elevation: 0.0,
//         backgroundColor: HexColor('333739'),
//         systemOverlayStyle:  SystemUiOverlayStyle(
//           statusBarBrightness: Brightness.dark,
//           statusBarIconBrightness: Brightness.light,
//           statusBarColor: HexColor('333739'),
//         ),
//         titleTextStyle: const TextStyle(
//             fontSize: 20,
//             color: Colors.white,
//             fontWeight: FontWeight.bold
//         )
//     ),
//     bottomNavigationBarTheme:  BottomNavigationBarThemeData(
//       type: BottomNavigationBarType.fixed,
//       elevation: 20,
//       unselectedItemColor: Colors.white,
//       backgroundColor: HexColor('333739'),
//     ),
//     textTheme: const TextTheme(
//       bodyLarge: TextStyle(
//         color: Colors.white,
//         fontWeight: FontWeight.w600,
//         fontSize: 19,
//       ),
//       bodyMedium: TextStyle(
//         color: Colors.white,
//         fontWeight: FontWeight.w600,
//         fontSize: 16,
//       ),
//       titleLarge: TextStyle(
//         color: Colors.white,
//         fontWeight: FontWeight.w700,
//         fontSize: 20,
//       ),
//       titleMedium: TextStyle(
//         color: Colors.white,
//         fontWeight: FontWeight.w700,
//         fontSize: 18,
//       ),
//
//     )
// );

ThemeData themeLight = ThemeData(
  fontFamily: 'Gelion',
  textTheme: TextTheme(
    titleLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: defaultColor
    ),
    titleMedium: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 24,
        color: defaultColor
    ),
    titleSmall: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 18,
        color: Colors.deepOrange
    ),
    bodyMedium: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    labelMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: defaultColor,
        decoration: TextDecoration.underline,
        decorationColor: defaultColor
    ),
    displayLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Colors.black,
        decoration: TextDecoration.underline,
        decorationColor: Colors.black,
      fontStyle: FontStyle.italic
    ),
  ),
  scaffoldBackgroundColor: Colors.grey[100],
  appBarTheme:   AppBarTheme(
    titleSpacing: 20,
    backgroundColor: Colors.grey[100],
    elevation: 0.0,
    iconTheme: const IconThemeData(
        color: Colors.black
    ),
    systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.grey[100],
        statusBarIconBrightness: Brightness.dark
    ),
    titleTextStyle: const TextStyle(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.bold
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white
  ),
);
