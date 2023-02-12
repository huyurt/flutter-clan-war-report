import 'package:flutter/material.dart';
import 'package:more_useful_clash_of_clans/model/AppModel.dart';
import 'package:more_useful_clash_of_clans/view/AppScreenListing.dart';

Map<String, WidgetBuilder> routes() {
  return <String, WidgetBuilder>{
    AppScreenListing.tag: (context) => AppScreenListing(ProTheme()),

  };
}
