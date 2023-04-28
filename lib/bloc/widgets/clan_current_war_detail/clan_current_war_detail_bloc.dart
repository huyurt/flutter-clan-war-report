import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../models/api/clan_war_and_war_type_response_model.dart';
import '../../../services/coc/coc_api_clans.dart';
import '../../../utils/enums/war_state_enum.dart';
import 'clan_current_war_detail_event.dart';
import 'clan_current_war_detail_state.dart';

EventTransformer<Event> throttleDroppable<Event>(Duration duration) {
  return (events, mapper) =>
      droppable<Event>().call(events.throttle(duration), mapper);
}

class ClanCurrentWarDetailBloc
    extends Bloc<ClanCurrentWarDetailEvent, ClanCurrentWarDetailState> {
  ClanCurrentWarDetailBloc() : super(ClanCurrentWarDetailStateEmpty()) {
    on<GetClanCurrentWarDetail>(_onGetClanCurrentWarDetail,
        transformer: throttleDroppable(const Duration(milliseconds: 0)));
  }

  Future<void> _onGetClanCurrentWarDetail(
    GetClanCurrentWarDetail event,
    Emitter<ClanCurrentWarDetailState> emit,
  ) async {
    if (event.clanTag.isEmptyOrNull) {
      return emit(ClanCurrentWarDetailStateEmpty());
    }

    emit(ClanCurrentWarDetailStateLoading());

    try {
      ClanWarAndWarTypeResponseModel? clanCurrentWar;
      try {
        if (event.warTag.isEmptyOrNull) {
          clanCurrentWar = await CocApiClans.getClanCurrentWar(event.clanTag);
        } else {
          clanCurrentWar = await CocApiClans.getClanLeagueGroupWar(
              event.clanTag, event.warTag!);
        }
      } catch (e) {}

      if (clanCurrentWar == null ||
          clanCurrentWar.clanWarResponseModel.state ==
              WarStateEnum.notInWar.name) {
        final clanLeague = await CocApiClans.getClanLeagueGroup(event.clanTag);
        final lastRound = clanLeague.rounds
            ?.lastWhere((element) => element.warTags?.isNotEmpty ?? false);
        if (lastRound?.warTags?.isNotEmpty ?? false) {
          for (String warTag in (lastRound?.warTags ?? <String>[])) {
            clanCurrentWar =
                await CocApiClans.getClanLeagueGroupWar(event.clanTag, warTag);
            if (clanCurrentWar.clanWarResponseModel.clan.tag == event.clanTag ||
                clanCurrentWar.clanWarResponseModel.opponent.tag ==
                    event.clanTag) {
              break;
            }
          }
        }
      }

      if (clanCurrentWar == null) {
        emit(ClanCurrentWarDetailStateEmpty());
      } else {
        emit(ClanCurrentWarDetailStateSuccess(
            clanCurrentWarDetail: clanCurrentWar));
      }
    } catch (error) {
      emit(const ClanCurrentWarDetailStateError('something went wrong'));
    }
  }
}
