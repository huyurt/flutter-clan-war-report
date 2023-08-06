import 'dart:async';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants/app_constants.dart';
import '../../../utils/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeIn(
              animate: true,
              duration: const Duration(milliseconds: 250),
              child: Image.asset(
                AppConstants.appIconImage,
                height: 128.0,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }

  startTimer() {
    var duration = const Duration(milliseconds: 300);
    return Timer(duration, redirect);
  }

  redirect() {
    Navigator.of(context).pushReplacementNamed(Routes.home);
  }
}
