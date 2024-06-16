import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:clan_war_report/utils/themes/app_font_family.dart';

class AppThemes {
  AppThemes._();

  static final ThemeData lightTheme = ThemeData(
    //androidOverscrollIndicator: AndroidOverscrollIndicator.stretch,
    fontFamily: AppFontFamily.clashLight,
    colorScheme: ColorScheme(
      primary: Color(0xffffc107),
      primaryContainer: Color(0xffffa000),
      secondary: Color(0xffffc107),
      secondaryContainer: Color(0xffffa000),
      surface: Color(0xffffffff),
      background: Color(0xffffe082),
      error: Color(0xffd32f2f),
      onPrimary: Color(0xff000000),
      onSecondary: Color(0xff000000),
      onSurface: Color(0xff000000),
      onBackground: Color(0xff000000),
      onError: Color(0xffffffff),
      brightness: Brightness.light,
    ),
    primarySwatch: MaterialColor(Colors.amber.value, const <int, Color>{
      50: Colors.amber,
      100: Colors.amber,
      200: Colors.amber,
      300: Colors.amber,
      400: Colors.amber,
      500: Colors.amber,
      600: Colors.amber,
      700: Colors.amber,
      800: Colors.amber,
      900: Colors.amber,
    }),
    brightness: Brightness.light,
    primaryColor: Color(0xffffffff),
    primaryColorLight: Color(0xffe6e6e6),
    primaryColorDark: Color(0xff4d4d4d),
    canvasColor: Color(0xfffafafa),
    scaffoldBackgroundColor: Color(0xfffafafa),
    bottomAppBarTheme: BottomAppBarTheme(
      color: Color(0xffffffff),
    ),
    cardColor: Color(0xffffffff),
    dividerColor: Color(0x1f000000),
    highlightColor: Color(0x66bcbcbc),
    splashColor: Color(0x66c8c8c8),
    //selectedRowColor: Color(0xfff5f5f5),
    unselectedWidgetColor: Color(0x8a000000),
    disabledColor: Color(0x61000000),
    toggleButtonsTheme: ToggleButtonsThemeData(
      color: Color(0xffffc107),
    ),
    secondaryHeaderColor: Color(0xfff2f2f2),
    dialogBackgroundColor: Color(0xffffffff),
    indicatorColor: Color(0xffffc107),
    hintColor: Color(0x8a000000),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Color(0xffffc107),
      selectionColor: Color(0xffffe082),
      selectionHandleColor: Color(0xffffd54f),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Color(0xffffc107),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: Color(0xffffc107),
    ),
    buttonTheme: ButtonThemeData(
      textTheme: ButtonTextTheme.normal,
      minWidth: 88,
      height: 36,
      padding: EdgeInsets.only(top: 0, bottom: 0, left: 16, right: 16),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Color(0xff000000),
          width: 0,
          style: BorderStyle.none,
        ),
        borderRadius: BorderRadius.all(Radius.circular(2.0)),
      ),
      alignedDropdown: false,
      buttonColor: Color(0xffe0e0e0),
      disabledColor: Color(0x61000000),
      highlightColor: Color(0x29000000),
      splashColor: Color(0x1f000000),
      focusColor: Color(0x1f000000),
      hoverColor: Color(0x0a000000),
      colorScheme: ColorScheme(
        primary: Color(0xffffc107),
        primaryContainer: Color(0xffffa000),
        secondary: Color(0xffffc107),
        secondaryContainer: Color(0xffffa000),
        surface: Color(0xffffffff),
        background: Color(0xffffe082),
        error: Color(0xffd32f2f),
        onPrimary: Color(0xff000000),
        onSecondary: Color(0xff000000),
        onSurface: Color(0xff000000),
        onBackground: Color(0xff000000),
        onError: Color(0xffffffff),
        brightness: Brightness.light,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0.0,
      titleTextStyle: TextStyle(
        fontFamily: AppFontFamily.clashLight,
        fontSize: 16.0,
        color: Color(0xff000000),
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        systemStatusBarContrastEnforced: false,
        statusBarIconBrightness: Brightness.dark,
      ),
    ),
    popupMenuTheme: PopupMenuThemeData(
      textStyle: TextStyle(
        fontFamily: AppFontFamily.clashLight,
        fontSize: 12.0,
        color: Color(0xdd000000),
      ),
    ),
    iconTheme: IconThemeData(
      color: Color(0xdd000000),
      opacity: 1,
      size: 24,
    ),
    primaryIconTheme: IconThemeData(
      color: Color(0xff000000),
      opacity: 1,
      size: 24,
    ),
    tabBarTheme: TabBarTheme(
      indicatorSize: TabBarIndicatorSize.tab,
      labelColor: Color(0xdd000000),
      unselectedLabelColor: Color(0xb2000000),
    ),
    textTheme: TextTheme(
      bodySmall: TextStyle(fontSize: 10.0),
      bodyMedium: TextStyle(fontSize: 12.0),
      bodyLarge: TextStyle(fontSize: 14.0),
    ),
    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Color(0xff000000),
          width: 0,
          style: BorderStyle.none,
        ),
        borderRadius: BorderRadius.all(Radius.circular(0.0)),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      unselectedIconTheme: IconThemeData(
        size: 20.0,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: 10.0,
      ),
      selectedItemColor: Colors.black,
      selectedIconTheme: IconThemeData(
        color: Colors.black,
        size: 20.0,
      ),
      selectedLabelStyle: TextStyle(
        fontSize: 10.0,
      ),
    ),
    expansionTileTheme: ExpansionTileThemeData(
      textColor: Colors.black,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    //androidOverscrollIndicator: AndroidOverscrollIndicator.stretch,
    fontFamily: AppFontFamily.clashLight,
    colorScheme: ColorScheme(
      primary: Color(0xffffc107),
      primaryContainer: Color(0xffffa000),
      secondary: Color(0xffffc107),
      secondaryContainer: Color(0xffffa000),
      surface: Color(0xff424242),
      background: Color(0xff616161),
      error: Color(0xffd32f2f),
      onPrimary: Color(0xff000000),
      onSecondary: Color(0xff000000),
      onSurface: Color(0xffffffff),
      onBackground: Color(0xff000000),
      onError: Color(0xff000000),
      brightness: Brightness.dark,
    ),
    primarySwatch: MaterialColor(Colors.black.value, const <int, Color>{
      50: Colors.black,
      100: Colors.black,
      200: Colors.black,
      300: Colors.black,
      400: Colors.black,
      500: Colors.black,
      600: Colors.black,
      700: Colors.black,
      800: Colors.black,
      900: Colors.black,
    }),
    brightness: Brightness.dark,
    primaryColor: Color(0xff212121),
    primaryColorLight: Color(0xff9e9e9e),
    primaryColorDark: Color(0xff000000),
    canvasColor: Color(0xff303030),
    scaffoldBackgroundColor: Color(0xff303030),
    bottomAppBarTheme: BottomAppBarTheme(
      color: Color(0xff424242),
    ),
    cardColor: Color(0xff424242),
    dividerColor: Color(0x1fffffff),
    highlightColor: Color(0x40cccccc),
    splashColor: Color(0x40cccccc),
    //selectedRowColor: Color(0xfff5f5f5),
    unselectedWidgetColor: Color(0xb3ffffff),
    disabledColor: Color(0x62ffffff),
    toggleButtonsTheme: ToggleButtonsThemeData(
      color: Color(0xffffc107),
    ),
    secondaryHeaderColor: Color(0xff616161),
    dialogBackgroundColor: Color(0xff424242),
    indicatorColor: Color(0xffffc107),
    hintColor: Color(0x80ffffff),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Color(0xffffc107),
      selectionColor: Color(0xffffe082),
      selectionHandleColor: Color(0xffffd54f),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: Color(0xffffc107),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.0)),
      ),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: Color(0xffffc107),
    ),
    buttonTheme: ButtonThemeData(
      textTheme: ButtonTextTheme.normal,
      minWidth: 88,
      height: 36,
      padding: EdgeInsets.only(top: 0, bottom: 0, left: 16, right: 16),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Color(0xff000000),
          width: 0,
          style: BorderStyle.none,
        ),
        borderRadius: BorderRadius.all(Radius.circular(2.0)),
      ),
      alignedDropdown: false,
      buttonColor: Color(0xffcccc00),
      disabledColor: Color(0x61ffffff),
      highlightColor: Color(0x29ffffff),
      splashColor: Color(0x1fffffff),
      focusColor: Color(0x1fffffff),
      hoverColor: Color(0x0affffff),
      colorScheme: ColorScheme(
        primary: Color(0xffffc107),
        primaryContainer: Color(0xffffa000),
        secondary: Color(0xffffc107),
        secondaryContainer: Color(0xffffa000),
        surface: Color(0xff424242),
        background: Color(0xff616161),
        error: Color(0xffd32f2f),
        onPrimary: Color(0xff000000),
        onSecondary: Color(0xff000000),
        onSurface: Color(0xffffffff),
        onBackground: Color(0xff000000),
        onError: Color(0xff000000),
        brightness: Brightness.dark,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0.0,
      titleTextStyle: TextStyle(
        fontFamily: AppFontFamily.clashLight,
        fontSize: 16.0,
      ),
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
        systemStatusBarContrastEnforced: false,
        statusBarIconBrightness: Brightness.light,
      ),
    ),
    popupMenuTheme: PopupMenuThemeData(
      textStyle: TextStyle(
        fontFamily: AppFontFamily.clashLight,
        fontSize: 12.0,
      ),
    ),
    iconTheme: IconThemeData(
      color: Color(0xffffc107),
      opacity: 1,
      size: 24,
    ),
    primaryIconTheme: IconThemeData(
      color: Color(0xffffffff),
      opacity: 1,
      size: 24,
    ),
    tabBarTheme: TabBarTheme(
      indicatorSize: TabBarIndicatorSize.tab,
      labelColor: Color(0xffffffff),
      unselectedLabelColor: Color(0xb2ffffff),
    ),
    textTheme: TextTheme(
      bodySmall: TextStyle(fontSize: 10.0),
      bodyMedium: TextStyle(fontSize: 12.0),
      bodyLarge: TextStyle(fontSize: 14.0),
    ),
    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Color(0xff000000),
          width: 0,
          style: BorderStyle.none,
        ),
        borderRadius: BorderRadius.all(Radius.circular(0.0)),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      unselectedIconTheme: IconThemeData(
        size: 20.0,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: 10.0,
      ),
      selectedItemColor: Colors.white,
      selectedIconTheme: IconThemeData(
        color: Colors.black,
        size: 20.0,
      ),
      selectedLabelStyle: TextStyle(
        fontSize: 10.0,
      ),
    ),
    expansionTileTheme: ExpansionTileThemeData(
      textColor: Colors.white,
    ),
  );
}
