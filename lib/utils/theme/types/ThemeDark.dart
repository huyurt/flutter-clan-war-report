import 'package:flutter/material.dart';

import '../AppTheme.dart';

class ThemeDark extends AppTheme {
  static ThemeDark? _instance;

  static ThemeDark get instance {
    _instance ??= ThemeDark._init();
    return _instance!;
  }

  ThemeDark._init();

  @override
  ThemeData? get theme => ThemeData(
        primarySwatch: MaterialColor(4280361249, {
          50: Color(0xfff2f2f2),
          100: Color(0xffe6e6e6),
          200: Color(0xffcccccc),
          300: Color(0xffb3b3b3),
          400: Color(0xff999999),
          500: Color(0xff808080),
          600: Color(0xff666666),
          700: Color(0xff4d4d4d),
          800: Color(0xff333333),
          900: Color(0xff191919),
        }),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xff333333),
          titleTextStyle: TextStyle(
            color: Color(0xffffffff),
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        brightness: Brightness.dark,
        primaryColor: Color(0xff212121),
        primaryColorBrightness: Brightness.dark,
        primaryColorLight: Color(0xff9e9e9e),
        primaryColorDark: Color(0xff000000),
        accentColor: Color(0xff4285f4),
        accentColorBrightness: Brightness.light,
        canvasColor: Color(0xff303030),
        scaffoldBackgroundColor: Color(0xff303030),
        bottomAppBarColor: Color(0xff424242),
        cardColor: Color(0xff424242),
        dividerColor: Color(0x1fffffff),
        highlightColor: Color(0x40cccccc),
        splashColor: Color(0x40cccccc),
        selectedRowColor: Color(0xfff5f5f5),
        unselectedWidgetColor: Color(0xb3ffffff),
        disabledColor: Color(0x62ffffff),
        buttonColor: Color(0xff666666),
        toggleableActiveColor: Color(0xff4285f4),
        secondaryHeaderColor: Color(0xff616161),
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: Color(0xff4285f4),
          cursorColor: Color(0xff0556e8),
          selectionHandleColor: Color(0xff2c72ed),
        ),
        backgroundColor: Color(0xff616161),
        dialogBackgroundColor: Color(0xff424242),
        indicatorColor: Color(0xff4285f4),
        hintColor: Color(0x80ffffff),
        errorColor: Color(0xffd32f2f),
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
            borderRadius: BorderRadius.all(
              Radius.circular(2.0),
            ),
          ),
          alignedDropdown: false,
          buttonColor: Color(0xff666666),
          disabledColor: Color(0x61ffffff),
          highlightColor: Color(0x29ffffff),
          splashColor: Color(0x1fffffff),
          focusColor: Color(0x1fffffff),
          hoverColor: Color(0x0affffff),
          colorScheme: ColorScheme(
            primary: Color(0xffffffff),
            primaryVariant: Color(0xff000000),
            secondary: Color(0xff4285f4),
            secondaryVariant: Color(0xff2c72ed),
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
        textTheme: TextTheme(
          caption: TextStyle(
            color: Color(0xb3ffffff),
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
          button: TextStyle(
            color: Color(0xffffffff),
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
          overline: TextStyle(
            color: Color(0xffffffff),
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
        ),
        primaryTextTheme: TextTheme(
          caption: TextStyle(
            color: Color(0xb3ffffff),
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
          button: TextStyle(
            color: Color(0xffffffff),
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
          overline: TextStyle(
            color: Color(0xffffffff),
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
        ),
        accentTextTheme: TextTheme(
          caption: TextStyle(
            color: Color(0x8a000000),
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
          button: TextStyle(
            color: Color(0xdd000000),
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
          overline: TextStyle(
            color: Color(0xff000000),
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(
            color: Color(0xffffffff),
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
          helperStyle: TextStyle(
            color: Color(0xffffffff),
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
          hintStyle: TextStyle(
            color: Color(0xffffffff),
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
          errorStyle: TextStyle(
            color: Color(0xffffffff),
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
          isDense: false,
          contentPadding:
              EdgeInsets.only(top: 12, bottom: 12, left: 0, right: 0),
          isCollapsed: false,
          prefixStyle: TextStyle(
            color: Color(0xffffffff),
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
          suffixStyle: TextStyle(
            color: Color(0xffffffff),
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
          counterStyle: TextStyle(
            color: Color(0xffffffff),
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
          filled: false,
          fillColor: Color(0x00000000),
          errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xff000000),
              width: 1,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(4.0),
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xff000000),
              width: 1,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(4.0),
            ),
          ),
          focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xff000000),
              width: 1,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(4.0),
            ),
          ),
          disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xff000000),
              width: 1,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(4.0),
            ),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xff000000),
              width: 1,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(4.0),
            ),
          ),
          border: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color(0xff000000),
              width: 1,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(4.0),
            ),
          ),
        ),
        iconTheme: IconThemeData(
          color: Color(0xffffffff),
          opacity: 1,
          size: 24,
        ),
        primaryIconTheme: IconThemeData(
          color: Color(0xffffffff),
          opacity: 1,
          size: 24,
        ),
        accentIconTheme: IconThemeData(
          color: Color(0xff000000),
          opacity: 1,
          size: 24,
        ),
        sliderTheme: SliderThemeData(
          valueIndicatorTextStyle: TextStyle(
            color: Color(0xdd000000),
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
        ),
        tabBarTheme: TabBarTheme(
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: Color(0xffffffff),
          unselectedLabelColor: Color(0xb2ffffff),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: Color(0x1fffffff),
          brightness: Brightness.dark,
          deleteIconColor: Color(0xdeffffff),
          disabledColor: Color(0x0cffffff),
          labelPadding: EdgeInsets.only(top: 0, bottom: 0, left: 8, right: 8),
          labelStyle: TextStyle(
            color: Color(0xdeffffff),
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
          padding: EdgeInsets.only(top: 4, bottom: 4, left: 4, right: 4),
          secondaryLabelStyle: TextStyle(
            color: Color(0x3dffffff),
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
          ),
          secondarySelectedColor: Color(0x3d212121),
          selectedColor: Color(0x3dffffff),
          shape: StadiumBorder(
            side: BorderSide(
              color: Color(0xff000000),
              width: 0,
              style: BorderStyle.none,
            ),
          ),
        ),
        dialogTheme: DialogTheme(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Color(0xff000000),
              width: 0,
              style: BorderStyle.none,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(0.0),
            ),
          ),
        ),
      );
}
