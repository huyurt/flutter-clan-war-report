import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:ionicons/ionicons.dart';
import 'package:more_useful_clash_of_clans/utils/constants/localization.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../models/api/search_clans_request_model.dart';
import '../../../models/api/search_clans_response_model.dart';
import '../../../services/coc/coc_api_clans.dart';

class SearchClanScreen extends ConsumerStatefulWidget {
  const SearchClanScreen({super.key});

  @override
  ConsumerState<SearchClanScreen> createState() => _SearchClanScreenState();
}

class _SearchClanScreenState extends ConsumerState<SearchClanScreen> {
  late final TextEditingController _clanNameFilterController;
  final PagingController<String, SearchedClanItem> _pagingController =
      PagingController(firstPageKey: '');
  RangeValues _members = const RangeValues(2, 50);
  double _minClanLevel = 2.0;

  @override
  void initState() {
    super.initState();
    _clanNameFilterController = TextEditingController()
      ..addListener(() {
        _pagingController.refresh();
        performFilter();
      });
    _pagingController.addPageRequestListener((pageKey) {
      performFilter();
    });
  }

  @override
  void dispose() {
    _clanNameFilterController.dispose();
    _pagingController.dispose();
    super.dispose();
  }

  void performFilter() {
    Future.delayed(const Duration(milliseconds: 500), () async {
      if (_clanNameFilterController.text.length > 2) {
        SearchClansRequestModel input = SearchClansRequestModel(
          clanName: _clanNameFilterController.text,
          minMembers: _members.start.round(),
          maxMembers: _members.end.round(),
          minClanLevel: _minClanLevel.round(),
          after: _pagingController.nextPageKey,
        );
        SearchClansResponseModel? clans = await CocApiClans.searchClans(input);

        _pagingController.appendPage(clans?.items as List<SearchedClanItem>,
            clans?.paging.cursors.after);
      } else {
        _pagingController.refresh();
      }
      setState(() {});
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  showFilter(BuildContext aContext) {
    showModalBottomSheet(
      context: aContext,
      backgroundColor: aContext.primaryColor,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 10, top: 15),
                    child: Row(
                      children: [
                        Text(tr(Localization.members)),
                        const Spacer(flex: 1),
                        Text(
                            '${_members.start.round().toString()} - ${_members.end.round().toString()}')
                      ],
                    ),
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.orange[700],
                      inactiveTrackColor: Colors.orange[100],
                      trackShape: const RoundedRectSliderTrackShape(),
                      trackHeight: 4.0,
                      thumbShape:
                          const RoundSliderThumbShape(enabledThumbRadius: 12.0),
                      thumbColor: Colors.orangeAccent,
                      overlayColor: Colors.orange.withAlpha(32),
                      overlayShape:
                          const RoundSliderOverlayShape(overlayRadius: 28.0),
                      tickMarkShape: const RoundSliderTickMarkShape(),
                      activeTickMarkColor: Colors.orange[700],
                      inactiveTickMarkColor: Colors.orange[100],
                      valueIndicatorShape:
                          const PaddleSliderValueIndicatorShape(),
                      valueIndicatorColor: Colors.orangeAccent,
                      valueIndicatorTextStyle: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    child: RangeSlider(
                      values: _members,
                      min: 2,
                      max: 50,
                      divisions: 50,
                      onChanged: (RangeValues values) {
                        setState(() {
                          _members = values;
                        });
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 10, top: 15),
                    child: Row(
                      children: [
                        Text(tr(Localization.minimumLevel)),
                        const Spacer(flex: 1),
                        Text(_minClanLevel.toStringAsFixed(0)),
                      ],
                    ),
                  ),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.orange[700],
                      inactiveTrackColor: Colors.orange[100],
                      trackShape: const RoundedRectSliderTrackShape(),
                      trackHeight: 4.0,
                      thumbShape:
                          const RoundSliderThumbShape(enabledThumbRadius: 10.0),
                      thumbColor: Colors.orangeAccent,
                      overlayColor: Colors.orange.withAlpha(32),
                      overlayShape:
                          const RoundSliderOverlayShape(overlayRadius: 28.0),
                      tickMarkShape: const RoundSliderTickMarkShape(),
                      activeTickMarkColor: Colors.orange[700],
                      inactiveTickMarkColor: Colors.orange[100],
                      valueIndicatorShape:
                          const PaddleSliderValueIndicatorShape(),
                      valueIndicatorColor: Colors.orangeAccent,
                      valueIndicatorTextStyle: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    child: Slider(
                      min: 2,
                      max: 20,
                      divisions: 20,
                      value: _minClanLevel.toDouble(),
                      onChanged: (value) {
                        setState(() {
                          _minClanLevel = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          decoration: InputDecoration(
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            hintText: tr(Localization.search),
          ),
          controller: _clanNameFilterController,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Ionicons.filter,
              color: context.theme.colorScheme.secondary,
            ),
            onPressed: () {
              showFilter(context);
            },
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          (_pagingController.itemList?.length ?? 0) == 0
              ? SliverFillRemaining(
                  hasScrollBody: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.search, size: 50.0),
                      const Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.0)),
                      Center(
                        child: Text(
                          tr(Localization.searchClan),
                          style: const TextStyle(fontSize: 20.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15.0, horizontal: 75.0),
                        child: Center(
                          child: Text(
                            tr(Localization.searchClanMessage),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : PagedSliverList<String, SearchedClanItem>(
                  pagingController: _pagingController,
                  builderDelegate: PagedChildBuilderDelegate<SearchedClanItem>(
                      itemBuilder: (context, item, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: SizedBox(
                        height: 50,
                        child: Row(
                          children: [
                            if (!(item.badgeUrls?.small?.isEmptyOrNull ?? true))
                              Image.network(
                                item.badgeUrls?.small ?? '',
                                fit: BoxFit.cover,
                              ),
                            Text('${item.tag} ${item.name} ${item.type}'),
                            const Spacer(flex: 1),
                            Text('${item.members}/50'),
                            const Spacer(flex: 1),
                            Text(
                              '${item.clanPoints}',
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
        ],
      ),
    );
  }
}
