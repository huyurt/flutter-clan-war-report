import 'package:flutter/material.dart';
import 'package:more_useful_clash_of_clans/view/MainScreen.dart';

Map<String, WidgetBuilder> routes() {
  return <String, WidgetBuilder>{
    MainScreen.tag: (context) => const MainScreen(),
  };
}
