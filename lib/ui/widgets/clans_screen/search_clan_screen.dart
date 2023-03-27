import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:more_useful_clash_of_clans/core/constants/locale_key.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../bloc/widgets/search_clan/search_clan_bloc.dart';
import '../../../bloc/widgets/search_clan/search_clan_event.dart';
import '../../../bloc/widgets/search_clan/search_clan_state.dart';
import '../bottom_loader.dart';

class SearchClanScreen extends StatefulWidget {
  const SearchClanScreen({super.key});

  @override
  State<SearchClanScreen> createState() => _SearchClanScreenState();
}

class _SearchClanScreenState extends State<SearchClanScreen> {
  late SearchClanBloc _searchClanBloc;

  late final TextEditingController _clanNameFilterController;
  RangeValues _members = const RangeValues(2, 50);
  double _minClanLevel = 2.0;

  @override
  void initState() {
    super.initState();
    _searchClanBloc = context.read<SearchClanBloc>();
    _clanNameFilterController = TextEditingController()
      ..addListener(() {
        _performSearch();
      });
  }

  @override
  void dispose() {
    _clanNameFilterController.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void _performSearch() {
    _searchClanBloc.add(
      TextChanged(
        clanName: _clanNameFilterController.text,
        minMembers: _members.start.round(),
        maxMembers: _members.end.round(),
        minClanLevel: _minClanLevel.round(),
      ),
    );
  }

  void _onClearTapped() {
    _clanNameFilterController.text = '';
    _searchClanBloc.add(
      TextChanged(
        clanName: _clanNameFilterController.text,
        minMembers: _members.start.round(),
        maxMembers: _members.end.round(),
        minClanLevel: _minClanLevel.round(),
      ),
    );
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
                        Text(tr(LocaleKey.members)),
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
                        Text(tr(LocaleKey.minimumLevel)),
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
            hintText: tr(LocaleKey.search),
            //suffixIcon: GestureDetector(
            //  onTap: _onClearTapped,
            //  child: const Icon(Icons.clear),
            //),
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
      body: BlocBuilder<SearchClanBloc, SearchClanState>(
        builder: (context, state) {
          if (state is SearchStateLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is SearchStateError) {
            return Center(child: Text(tr('search_failed_message')));
          }
          if (state is SearchStateSuccess) {
            if (state.items.isEmpty) {
              return Center(child: Text(tr('search_no_result_message')));
            }
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return index >= state.items.length
                    ? const BottomLoader()
                    : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: SizedBox(
                          height: 50,
                          child: Row(
                            children: [
                              if (!(state.items[index].badgeUrls?.small
                                      ?.isEmptyOrNull ??
                                  true))
                                Image.network(
                                  state.items[index].badgeUrls?.small ?? '',
                                  fit: BoxFit.cover,
                                ),
                              Text(
                                  '${state.items[index].tag} ${state.items[index].name} ${state.items[index].type}'),
                              const Spacer(flex: 1),
                              Text('${state.items[index].members}/50'),
                              const Spacer(flex: 1),
                              Text(
                                '${state.items[index].clanPoints}',
                                textAlign: TextAlign.right,
                              ),
                            ],
                          ),
                        ),
                      );
              },
              itemCount: state.items.length,
              //controller: _scrollController,
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.search, size: 50.0),
              const Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
              Center(
                child: Text(
                  tr(LocaleKey.searchClan),
                  style: const TextStyle(fontSize: 20.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 75.0),
                child: Center(
                  child: Text(
                    tr(LocaleKey.searchClanMessage),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
