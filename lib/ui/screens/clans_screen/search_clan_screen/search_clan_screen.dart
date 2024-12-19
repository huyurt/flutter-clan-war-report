import 'package:country_flags/country_flags.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:clan_war_report/utils/constants/locale_key.dart';
import 'package:clan_war_report/utils/enums/bloc_status_enum.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../bloc/widgets/bookmarked_clan_tags/bookmarked_clan_tags_cubit.dart';
import '../../../../bloc/widgets/search_clan/search_clan_bloc.dart';
import '../../../../bloc/widgets/search_clan/search_clan_event.dart';
import '../../../../bloc/widgets/search_clan/search_clan_state.dart';
import '../../../../models/api/response/location_response_model.dart';
import '../../../../repositories/search_clan/search_clan_filter_cache.dart';
import '../../../../utils/constants/app_constants.dart';
import '../../../../models/api/request/search_clans_request_model.dart';
import '../../../../utils/helpers/location_helper.dart';
import '../../../../utils/injection.dart';
import '../../../widgets/bottom_loader.dart';
import '../../../widgets/app_widgets/rank_image.dart';
import 'clan_detail_screen.dart';

class SearchClanScreen extends StatefulWidget {
  const SearchClanScreen({super.key});

  @override
  State<SearchClanScreen> createState() => _SearchClanScreenState();
}

class _SearchClanScreenState extends State<SearchClanScreen> {
  late SearchClanBloc _searchClanBloc;

  final locations = LocationHelper.getAll(true);

  final _listController = ScrollController();
  String? _after = '';

  final TextEditingController _clanFilterController = TextEditingController();
  late LocationItem _location;
  late RangeValues _members;
  late double _minClanLevel;
  String? _prevClanFilter;
  bool _filterChanged = false;
  bool _isDefaultFilter = true;

  @override
  void initState() {
    super.initState();
    _searchClanBloc = context.read<SearchClanBloc>();
    _searchClanBloc.add(ClearFilter());

    _listController.addListener(_onScroll);
    _clanFilterController.addListener(() {
      if (_prevClanFilter != _clanFilterController.text) {
        _prevClanFilter = _clanFilterController.text;
        _performSearch(false);
      }
    });

    final cachedSearchFilter = locator.get<SearchClanFilterCache>();
    _location = locations
        .firstWhere((l) => l.id == cachedSearchFilter.get().locationId);
    _members = cachedSearchFilter.getMembers();
    _minClanLevel = cachedSearchFilter.get().minClanLevel.toDouble();
  }

  @override
  void dispose() {
    _clanFilterController.dispose();
    _listController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void _onScroll() {
    if (_isBottom) {
      _searchClanBloc.add(
        NextPageFetched(
          searchTerm: SearchClansRequestModel(
            clanName: _clanFilterController.text,
            locationId: _location.id,
            minMembers: _members.start.round(),
            maxMembers: _members.end.round(),
            minClanLevel: _minClanLevel.round(),
            after: _after,
          ),
        ),
      );
    }
  }

  bool get _isBottom {
    if (!_listController.hasClients) return false;
    final maxScroll = _listController.position.maxScrollExtent;
    final currentScroll = _listController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _performSearch(bool isFilter) {
    final searchFilter = SearchClansRequestModel(
      clanName: _clanFilterController.text,
      locationId: _location.id,
      minMembers: _members.start.round(),
      maxMembers: _members.end.round(),
      minClanLevel: _minClanLevel.round(),
    );
    locator.get<SearchClanFilterCache>().set(searchFilter);
    setState(() {
      _isDefaultFilter = searchFilter.isDefault;
    });
    if (isFilter) {
      if (_filterChanged) {
        _searchClanBloc.add(
          FilterChanged(
            searchTerm: searchFilter,
          ),
        );
        _filterChanged = false;
      }
    } else {
      _searchClanBloc.add(
        TextChanged(
          searchTerm: searchFilter,
        ),
      );
    }
  }

  void showLocationFilter(BuildContext aContext, StateSetter setState) {
    showModalBottomSheet(
      context: aContext,
      backgroundColor: aContext.primaryColor,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 0.7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 12.0),
                child: Text(
                  tr(LocaleKey.location),
                  style: const TextStyle(fontSize: 18.0),
                ),
              ),
              Expanded(
                child: ListView(
                  children: locations.map(
                    (location) {
                      return Card(
                        margin: EdgeInsets.zero,
                        elevation: 0.0,
                        color: _location.id == location.id
                            ? Colors.black12
                            : Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0.0),
                        ),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              if (_location.id != location.id) {
                                _filterChanged = true;
                              }
                              _location = location;
                            });
                            Navigator.pop(aContext);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 18.0, horizontal: 12.0),
                            child: Row(
                              children: [
                                location.isCountry
                                    ? CountryFlag.fromCountryCode(
                                        location.countryCode ?? '',
                                        height: 16.0,
                                        width: 24.0,
                                        shape: RoundedRectangle(4.0),
                                      )
                                    : (location.id == -1
                                        ? const SizedBox(width: 24.0)
                                        : const Icon(
                                            Icons.public,
                                            size: 24.0,
                                            color: Colors.blue,
                                          )),
                                Text(location.name).paddingLeft(8.0),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),
              ),
            ],
          ),
        );
      },
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
                    child: Text(tr(LocaleKey.location)),
                  ),
                  Card(
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 8.0),
                    elevation: 0.0,
                    color: Colors.black12,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: InkWell(
                      onTap: () {
                        showLocationFilter(context, setState);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 18.0, horizontal: 18.0),
                        child: Row(
                          children: [
                            _location.isCountry
                                ? CountryFlag.fromCountryCode(
                                    _location.countryCode ?? '',
                                    height: 16.0,
                                    width: 24.0,
                                    shape: RoundedRectangle(4.0),
                                  )
                                : (_location.id == -1
                                    ? Container()
                                    : const Icon(
                                        Icons.public,
                                        size: 24.0,
                                        color: Colors.blue,
                                      )),
                            Text(_location.name).paddingLeft(8.0),
                          ],
                        ),
                      ),
                    ),
                  ),
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
                      min: AppConstants.minMembersFilter,
                      max: AppConstants.maxMembersFilter,
                      divisions: AppConstants.maxMembersFilter.round(),
                      onChanged: (RangeValues values) {
                        setState(() {
                          _filterChanged = true;
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
                      min: AppConstants.minClanLevelFilter,
                      max: AppConstants.maxClanLevelFilter,
                      divisions: AppConstants.maxClanLevelFilter.round(),
                      value: _minClanLevel.toDouble(),
                      onChanged: (value) {
                        setState(() {
                          _filterChanged = true;
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
    ).whenComplete(() {
      _performSearch(true);
    });
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
          ),
          controller: _clanFilterController,
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Ionicons.filter),
                onPressed: () {
                  showFilter(context);
                },
              ),
              Visibility(
                visible: !_isDefaultFilter,
                child: Positioned(
                  top: 12,
                  right: 8,
                  child: Container(
                    height: 8.0,
                    width: 8.0,
                    decoration: BoxDecoration(
                      color: Colors.pink,
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: BlocBuilder<SearchClanBloc, SearchClanState>(
        builder: (context, state) {
          switch (state.status) {
            case BlocStatusEnum.failure:
              return Center(child: Text(tr('search_failed_message')));
            case BlocStatusEnum.loading:
              return const Center(child: CircularProgressIndicator());
            case BlocStatusEnum.success:
              _after = state.after;
              if (state.items.isEmpty) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.search_off, size: 50.0),
                    const Padding(padding: EdgeInsets.symmetric(vertical: 5.0)),
                    Center(
                      child: Text(
                        tr(LocaleKey.noClanFound),
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
              }
              return ListView.builder(
                controller: _listController,
                itemCount: state.after.isEmptyOrNull
                    ? state.items.length
                    : state.items.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index >= state.items.length) {
                    return const BottomLoader();
                  }
                  final clan = state.items[index];
                  final location = clan.location;
                  return Card(
                    margin: EdgeInsets.zero,
                    elevation: 0.0,
                    color: context
                            .watch<BookmarkedClanTagsCubit>()
                            .state
                            .clanTags
                            .contains(clan.tag)
                        ? AppConstants.attackerClanBackgroundColor
                        : Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                    ),
                    child: InkWell(
                      onTap: () {
                        ClanDetailScreen(
                          viewWarButton: true,
                          clanTag: clan.tag,
                        ).launch(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 5.0),
                        child: SizedBox(
                          height: 70,
                          child: Row(
                            children: [
                              RankImage(
                                imageUrl: clan.badgeUrls?.large,
                                height: 50,
                                width: 50,
                              ),
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        clan.name,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: const TextStyle(
                                            height: 1.2, fontSize: 14.0),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Text(clan.tag),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 100,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(tr(LocaleKey.members)),
                                    Card(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5.0, horizontal: 12.0),
                                        child: Text(
                                            '${clan.members.toString().padLeft(2, '0')}/50'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 80,
                                height: 50,
                                child: Card(
                                  margin: EdgeInsets.zero,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        if (location != null ||
                                            (clan.warLeague?.id ?? 0) >
                                                AppConstants.warLeagueUnranked)
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              (location?.isCountry ?? false)
                                                  ? CountryFlag.fromCountryCode(
                                                      location?.countryCode ??
                                                          '',
                                                      height: 16.0,
                                                      width: 24.0,
                                                      shape: RoundedRectangle(4.0),
                                                    )
                                                  : const Icon(
                                                      Icons.public,
                                                      size: 18,
                                                      color: Colors.blue,
                                                    ),
                                              if ((clan.warLeague?.id ?? 0) >
                                                  AppConstants
                                                      .warLeagueUnranked)
                                                Image.asset(
                                                  '${AppConstants.clanWarLeaguesImagePath}${clan.warLeague?.id}.png',
                                                  height: 18,
                                                  fit: BoxFit.cover,
                                                ),
                                            ],
                                          ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: clan.labels
                                                  ?.map((label) =>
                                                      FadeInImage.assetNetwork(
                                                        width: 22,
                                                        image: label.iconUrls
                                                                ?.medium ??
                                                            AppConstants
                                                                .placeholderImage,
                                                        placeholder: AppConstants
                                                            .placeholderImage,
                                                        fit: BoxFit.cover,
                                                      ))
                                                  .toList() ??
                                              [],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            default:
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search, size: 64.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Text(
                      tr(LocaleKey.searchClan),
                      style: const TextStyle(fontSize: 18.0),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        tr(LocaleKey.searchClanMessage),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              );
          }
        },
      ),
    );
  }
}
