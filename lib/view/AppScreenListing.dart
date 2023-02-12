import 'package:flutter/material.dart';
import 'package:more_useful_clash_of_clans/view/ThemeList.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:more_useful_clash_of_clans/model/AppModel.dart';
import 'package:more_useful_clash_of_clans/utils/AppColors.dart';
import 'package:more_useful_clash_of_clans/utils/AppImages.dart';
import 'package:more_useful_clash_of_clans/utils/AppWidget.dart';

class AppScreenListing extends StatefulWidget {
  static String tag = "/ProKitScreenListing";
  final ProTheme? proTheme;

  AppScreenListing(this.proTheme);

  @override
  ProKitScreenListingState createState() => ProKitScreenListingState();
}

class ProKitScreenListingState extends State<AppScreenListing> {
  var selectedTab = 0;
  List<ProTheme> list = [];

  //BannerAd? myBanner;

  @override
  void initState() {
    super.initState();
    if (widget.proTheme!.sub_kits != null) {
      list.addAll(widget.proTheme!.sub_kits!);
    }

    afterBuildCreated(() {
      //changeStatusColor(appStore.scaffoldBackground!);
    });
  }

  @override
  void dispose() {
    //myBanner?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(
          context,
          widget.proTheme!.name ?? widget.proTheme!.name!,
          iconColor: Theme.of(context).iconTheme.color,
          //actions: [
          //  Tooltip(
          //    message: 'Dark Mode',
          //    child: Switch(
          //      value: appStore.isDarkModeOn,
          //      activeColor: appColorPrimary,
          //      onChanged: (s) {
          //        appStore.toggleDarkMode(value: s);
          //        setState(() {});
          //      },
          //    ),
          //  ),
          //],
        ),
        body: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.only(bottom: 80),
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(16),
                    child: widget.proTheme!.show_cover! ? Image.asset(app_bg_cover_image, height: context.height() / 4) : null,
                  ),
                  ThemeList(list),
                ],
              ),
            ),
          ],
        ),
      );
  }
}
