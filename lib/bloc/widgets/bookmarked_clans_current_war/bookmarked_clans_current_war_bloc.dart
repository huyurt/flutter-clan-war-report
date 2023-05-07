import 'package:async/async.dart';
import 'package:bloc/bloc.dart';
import 'package:more_useful_clash_of_clans/utils/enums/war_state_enum.dart';

import '../../../models/coc/clans_current_war_state_model.dart';
import '../../../repositories/bookmarked_clans_current_war/bookmarked_clans_current_war_repository.dart';
import '../../../services/coc/coc_api_clans.dart';
import 'bookmarked_clans_current_war_event.dart';
import 'bookmarked_clans_current_war_state.dart';

class BookmarkedClansCurrentWarBloc extends Bloc<BookmarkedClansCurrentWarEvent,
    BookmarkedClansCurrentWarState> {
  BookmarkedClansCurrentWarBloc({
    required this.bookmarkedClansCurrentWarRepository,
  }) : super(BookmarkedClansCurrentWarStateEmpty()) {
    on<GetBookmarkedClansCurrentWar>(_onGetBookmarkedClansCurrentWar);
  }

  final BookmarkedClansCurrentWarRepository bookmarkedClansCurrentWarRepository;

  Future<void> _onGetBookmarkedClansCurrentWar(
    GetBookmarkedClansCurrentWar event,
    Emitter<BookmarkedClansCurrentWarState> emit,
  ) async {
    emit(BookmarkedClansCurrentWarStateLoading());

    bookmarkedClansCurrentWarRepository.cleanRemovedClanTags(event.clanTagList);
    emit(BookmarkedClansCurrentWarStateSuccess(
      clansCurrentWar: bookmarkedClansCurrentWarRepository.getClansCurrentWar(),
    ));

    for (final clanTag in event.clanTagList) {
      try {
        ClansCurrentWarStateModel? clanCurrentWar;

        // Fetch current clan war
        try {
          clanCurrentWar = await CocApiClans.getClanCurrentWar(clanTag);
        } catch (e) {}

        if (clanCurrentWar == null ||
            clanCurrentWar.war.state == WarStateEnum.notInWar.name) {
          // Fetch clan league wars
          final lastClanLeague = await CocApiClans.getClanLeagueGroup(clanTag);

          int notStartedRoundIndex = lastClanLeague.rounds
              .indexWhere((r) => r.warTags?.contains('#0') ?? false);
          int lastRoundIndex = notStartedRoundIndex > 0
              ? (notStartedRoundIndex - 1)
              : (lastClanLeague.rounds.length - 1);

          if (lastRoundIndex == 0) {
            final round = lastClanLeague.rounds[lastRoundIndex];
            final warTag = round.warTags?.first;
            if (warTag != null) {
              clanCurrentWar = await getClanCurrentLeagueWar(clanTag, [warTag]);
              bookmarkedClansCurrentWarRepository
                  .addOrUpdateBookmarkedClansCurrentWar(
                clanTag,
                clanCurrentWar,
              );
            }
          } else {
            final round1 = lastClanLeague.rounds[lastRoundIndex - 1];
            clanCurrentWar = await getClanCurrentLeagueWar(
                clanTag, (round1.warTags ?? <String>[]));
            if (clanCurrentWar.war.state == WarStateEnum.warEnded.name) {
              final round2 = lastClanLeague.rounds[lastRoundIndex];
              clanCurrentWar = await getClanCurrentLeagueWar(
                  clanTag, (round2.warTags ?? <String>[]));
            }
            bookmarkedClansCurrentWarRepository
                .addOrUpdateBookmarkedClansCurrentWar(
              clanTag,
              clanCurrentWar,
            );
          }
        } else {
          bookmarkedClansCurrentWarRepository
              .addOrUpdateBookmarkedClansCurrentWar(
            clanTag,
            clanCurrentWar,
          );
        }
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

  Future<ClansCurrentWarStateModel> getClanCurrentLeagueWar(
      String clanTag, List<String> warTags) async {
    final clanLeagueWars = <ClansCurrentWarStateModel>[];
    final futureGroup = FutureGroup();
    for (final warTag in warTags) {
      futureGroup.add(CocApiClans.getClanLeagueGroupWar(clanTag, warTag));
    }
    futureGroup.close();

    final allResponse = await futureGroup.future;
    for (final response in allResponse) {
      clanLeagueWars.add(response);
    }
    return clanLeagueWars.firstWhere(
        (e) => e.war.clan.tag == clanTag || e.war.opponent.tag == clanTag);
  }
}
