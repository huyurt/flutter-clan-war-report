import 'package:flutter/material.dart';

abstract class LocaleState {}

class LocaleInitState extends LocaleState {}

class ChangeLocaleState extends LocaleState {
  final Locale locale;

  ChangeLocaleState({required this.locale});
}
