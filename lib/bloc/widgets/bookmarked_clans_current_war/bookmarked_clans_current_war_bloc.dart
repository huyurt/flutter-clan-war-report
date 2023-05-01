import 'package:bloc/bloc.dart';
import 'package:more_useful_clash_of_clans/utils/enums/war_state_enum.dart';

import '../../../models/api/clan_war_and_war_type_response_model.dart';
import '../../../repositories/bookmarked_clan_tags/bookmarked_clan_tags_repository.dart';
import '../../../repositories/bookmarked_clans_current_war/bookmarked_clans_current_war_repository.dart';
import '../../../services/coc/coc_api_clans.dart';
import 'bookmarked_clans_current_war_event.dart';
import 'bookmarked_clans_current_war_state.dart';

class BookmarkedClansCurrentWarBloc extends Bloc<BookmarkedClansCurrentWarEvent,
    BookmarkedClansCurrentWarState> {
  BookmarkedClansCurrentWarBloc({
    required this.bookmarkedClanTagsRepository,
    required this.bookmarkedClansCurrentWarRepository,
  }) : super(BookmarkedClansCurrentWarStateEmpty()) {
    on<GetBookmarkedClansCurrentWar>(_onGetBookmarkedClansCurrentWar);
  }

  final BookmarkedClanTagsRepository bookmarkedClanTagsRepository;
  final BookmarkedClansCurrentWarRepository bookmarkedClansCurrentWarRepository;

  Future<void> _onGetBookmarkedClansCurrentWar(
    GetBookmarkedClansCurrentWar event,
    Emitter<BookmarkedClansCurrentWarState> emit,
  ) async {
    emit(BookmarkedClansCurrentWarStateLoading());

    final removedClanTags = event.clanTagList
        .where((element) => !event.clanTagList.contains(element))
        .toList();
    for (String clanTag in removedClanTags) {
      bookmarkedClansCurrentWarRepository
          .removeBookmarkedClansCurrentWar(clanTag);
    }
    emit(BookmarkedClansCurrentWarStateSuccess(
      clansCurrentWar: bookmarkedClansCurrentWarRepository.getClansCurrentWar(),
    ));

    for (String clanTag in event.clanTagList) {
      try {
        bool clanFound = false;
        ClanWarAndWarTypeResponseModel? clanCurrentWar;
        try {
          clanCurrentWar = await CocApiClans.getClanCurrentWar(clanTag);
        } catch (e) {}
        if (clanCurrentWar == null ||
            clanCurrentWar.clanWarResponseModel.state ==
                WarStateEnum.notInWar.name) {
          final clanLeague = await CocApiClans.getClanLeagueGroup(clanTag);
          final lastRound = clanLeague.rounds?.lastWhere((element) =>
              (element.warTags?.isNotEmpty ?? false) &&
              (element.warTags?.any((e2) => e2 != '#0') ?? false));
          if (lastRound?.warTags?.isNotEmpty ?? false) {
            for (String warTag in (lastRound?.warTags ?? <String>[])) {
              clanCurrentWar =
                  await CocApiClans.getClanLeagueGroupWar(clanTag, warTag);
              if (clanCurrentWar.clanWarResponseModel.clan.tag == clanTag ||
                  clanCurrentWar.clanWarResponseModel.opponent.tag == clanTag) {
                clanFound = true;
                break;
              }
            }
          }
        } else {
          clanFound = true;
        }
        clanCurrentWar = clanFound ? clanCurrentWar : null;
        bookmarkedClansCurrentWarRepository
            .addOrUpdateBookmarkedClansCurrentWar(clanTag, clanCurrentWar);
      } catch (e) {
        emit(const BookmarkedClansCurrentWarStateError('something went wrong'));
      }
      emit(BookmarkedClansCurrentWarStateSuccess(
        clansCurrentWar:
            bookmarkedClansCurrentWarRepository.getClansCurrentWar(),
      ));
    }

    //emit(BookmarkedClansCurrentWarStateCompleted());
  }
}
