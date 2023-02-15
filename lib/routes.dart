import 'package:flutter/material.dart';
import 'package:more_useful_clash_of_clans/view/HomeScreen.dart';

Map<String, WidgetBuilder> routes() {
  return <String, WidgetBuilder>{
    HomeScreen.tag: (context) => const HomeScreen(),
  };
}
