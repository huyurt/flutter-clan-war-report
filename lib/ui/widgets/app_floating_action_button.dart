import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class AppFloatingActionButton extends StatelessWidget {
  const AppFloatingActionButton({super.key});

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
