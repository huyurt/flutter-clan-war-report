import 'package:akar_icons_flutter/akar_icons_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:more_useful_clash_of_clans/utils/constants/locale_key.dart';

import '../../../bloc/widgets/bookmarked_clan_tags/bookmarked_clan_tags_cubit.dart';
import '../../../bloc/widgets/bookmarked_clans_current_war/bookmarked_clans_current_war_bloc.dart';
import '../../../bloc/widgets/bookmarked_clans_current_war/bookmarked_clans_current_war_event.dart';
import '../../../bloc/widgets/bookmarked_clans_current_war/bookmarked_clans_current_war_state.dart';
import '../../../utils/enums/bloc_status_enum.dart';
import '../../../utils/enums/process_type_enum.dart';
import '../../widgets/bottom_progression_indicator.dart';
import '../../widgets/app_widgets/war_info_card.dart';
import '../../widgets/api_error_widget.dart';

class ClansCurrentWarScreen extends StatefulWidget {
  const ClansCurrentWarScreen({super.key});

  @override
  State<ClansCurrentWarScreen> createState() => _ClansCurrentWarScreenState();
}

class _ClansCurrentWarScreenState extends State<ClansCurrentWarScreen> {
  late BookmarkedClansCurrentWarBloc _bookmarkedClansCurrentWarBloc;

  @override
  void initState() {
    super.initState();
    _bookmarkedClansCurrentWarBloc =
        context.read<BookmarkedClansCurrentWarBloc>();
  }

  @override
  void didChangeDependencies() {
    _bookmarkedClansCurrentWarBloc.add(
      GetBookmarkedClansCurrentWar(
        process: ProcessType.list,
        clanTagList: context.watch<BookmarkedClanTagsCubit>().state.clanTags,
      ),
    );
    super.didChangeDependencies();
  }

  Future<void> _refreshList() async {
    _bookmarkedClansCurrentWarBloc.add(
      GetBookmarkedClansCurrentWar(
        process: ProcessType.refresh,
        clanTagList: context.read<BookmarkedClanTagsCubit>().state.clanTags,
      ),
    );
  }

  Widget _emptyList() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(AkarIcons.double_sword, size: 64.0),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Text(
            tr(LocaleKey.noClansInWar),
            style: const TextStyle(fontSize: 18.0),
          ),
        ),
        Text(
          tr(LocaleKey.noClansInWarMessage),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: BlocBuilder<BookmarkedClansCurrentWarBloc,
          BookmarkedClansCurrentWarState>(
        builder: (context, state) {
          switch (state.status) {
            case BlocStatusEnum.failure:
              return ApiErrorWidget(
                onRefresh: _refreshList,
                isTimeout: state.isTimeout,
                errorMessage: state.errorMessage,
              );
            case BlocStatusEnum.loading:
            case BlocStatusEnum.success:
              if (state.status == BlocStatusEnum.loading &&
                  (state.items.isEmpty || !state.items.any((e) => e != null))) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.items.isEmpty || !state.items.any((e) => e != null)) {
                return _emptyList();
              }
              return Column(
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      color: Colors.amber,
                      onRefresh: _refreshList,
                      child: ListView.builder(
                        key: PageStorageKey(widget.key),
                        itemCount: state.items.length,
                        itemBuilder: (BuildContext context, int index) {
                          final clanCurrentWarData = state.items[index];
                          final clanTag = clanCurrentWarData?.clanTag;
                          final clanCurrentWar = clanCurrentWarData?.war;

                          return WarInfoCard(
                            clanTag: clanTag ?? '',
                            warTag: clanCurrentWarData?.warTag ?? '',
                            warType: clanCurrentWarData?.warType,
                            war: clanCurrentWar,
                          );
                        },
                      ),
                    ),
                  ),
                  if (state.status == BlocStatusEnum.loading) ...[
                    const BottomProgressionIndicator(),
                  ],
                ],
              );
            default:
              return _emptyList();
          }
        },
      ),
    );
  }
}
