import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class AppBottomFloatingActionButton extends StatelessWidget {
  const AppBottomFloatingActionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      label: const Text('Ara'),
      icon: const Icon(Icons.search),
      onPressed: () {
        toast('...Ekleniyor');
      },
    );
  }
}
