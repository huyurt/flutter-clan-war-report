import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../models/coc/clans_current_war_state_model.dart';
import '../../../services/coc_api/coc_api_clans.dart';
import '../../../utils/constants/locale_key.dart';
import 'clan_current_war_detail_event.dart';
import 'clan_current_war_detail_state.dart';

EventTransformer<Event> throttleDroppable<Event>(Duration duration) {
  return (events, mapper) =>
      droppable<Event>().call(events.throttle(duration), mapper);
}

class ClanCurrentWarDetailBloc
    extends Bloc<ClanCurrentWarDetailEvent, ClanCurrentWarDetailState> {
  ClanCurrentWarDetailBloc() : super(const ClanCurrentWarDetailState.init()) {
    on<GetClanCurrentWarDetail>(_onGetClanCurrentWarDetail,
        transformer: throttleDroppable(const Duration(milliseconds: 0)));
  }

  Future<void> _onGetClanCurrentWarDetail(
    GetClanCurrentWarDetail event,
    Emitter<ClanCurrentWarDetailState> emit,
  ) async {
    if (event.clanTag.isEmptyOrNull) {
      return emit(
          ClanCurrentWarDetailState.failure(tr(LocaleKey.cocApiErrorMessage)));
    }

    emit(const ClanCurrentWarDetailState.loading());

    try {
      ClansCurrentWarStateModel? clanCurrentWar;
      try {
        if (event.warTag.isEmptyOrNull) {
          clanCurrentWar = await CocApiClans.getClanCurrentWar(event.clanTag);
        } else {
          clanCurrentWar = await CocApiClans.getClanLeagueGroupWar(
              event.clanTag, event.warTag!);
        }
      } catch (e) {}

      if (clanCurrentWar == null) {
        emit(ClanCurrentWarDetailState.failure(
            tr(LocaleKey.cocApiErrorMessage)));
      } else {
        emit(ClanCurrentWarDetailState.success(
          clanCurrentWar,
        ));
      }
    } catch (error) {
      if (error is DioError) {
        emit(ClanCurrentWarDetailState.failure(error.message));
      } else {
        emit(ClanCurrentWarDetailState.failure(
            tr(LocaleKey.cocApiErrorMessage)));
      }
    }
  }
}
