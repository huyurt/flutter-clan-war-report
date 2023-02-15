import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/theme/manager/ThemeManager.dart';

class HomeScreen extends StatefulWidget {
  static String tag = '/HomeScreen';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final items = [
    {
      'title': 'What is Lorem Ipsum?',
      'description':
          'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
      'image': 'https://picsum.photos/200'
    }
  ];

  @override
  void initState() {
    context.read<ThemeManager>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const Padding(
          padding: EdgeInsets.all(12.0),
          child: FlutterLogo(
            style: FlutterLogoStyle.markOnly,
          ),
        ),
        actions: <Widget>[
          Tooltip(
            message: 'Dark Mode',
            child: Switch(
              value: ThemeManager.instance.darkModeOn,
              onChanged: (s) {
                ThemeEnum selectedTheme = s ? ThemeEnum.DARK : ThemeEnum.LIGHT;
                ThemeManager.instance.changeTheme(selectedTheme);
                setState(() {});
              },
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              title: Text(items[index]['title'] ?? ''),
              subtitle: Text(items[index]['description'] ?? ''),
              leading: Image.network(items[index]['image'] ?? ''),
            ),
          );
        },
      ),
    );
  }
}
