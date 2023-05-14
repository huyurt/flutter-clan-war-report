import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../services/coc_api/coc_api_clans.dart';
import 'clan_detail_event.dart';
import 'clan_detail_state.dart';

EventTransformer<Event> throttleDroppable<Event>(Duration duration) {
  return (events, mapper) =>
      droppable<Event>().call(events.throttle(duration), mapper);
}

class ClanDetailBloc extends Bloc<ClanDetailEvent, ClanDetailState> {
  ClanDetailBloc() : super(const ClanDetailState.init()) {
    on<ClearFilter>(_onClearFilter,
        transformer: throttleDroppable(const Duration(milliseconds: 0)));
    on<GetClanDetail>(_onGetClanDetail,
        transformer: throttleDroppable(const Duration(milliseconds: 1000)));
  }

  Future<void> _onClearFilter(
    ClearFilter event,
    Emitter<ClanDetailState> emit,
  ) async {
    return emit(const ClanDetailState.init());
  }

  Future<void> _onGetClanDetail(
    GetClanDetail event,
    Emitter<ClanDetailState> emit,
  ) async {
    if (event.clanTag.isEmptyOrNull) {
      return emit(const ClanDetailState.failure());
    }

    emit(const ClanDetailState.loading());

    try {
      final result = await CocApiClans.getClanDetail(event.clanTag!);
      emit(ClanDetailState.success(result));
    } catch (error) {
      emit(const ClanDetailState.failure());
    }
  }
}
