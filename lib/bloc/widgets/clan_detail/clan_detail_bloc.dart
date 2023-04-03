import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../services/coc/coc_api_clans.dart';
import 'clan_detail_event.dart';
import 'clan_detail_state.dart';

EventTransformer<Event> throttleDroppable<Event>(Duration duration) {
  return (events, mapper) =>
      droppable<Event>().call(events.throttle(duration), mapper);
}

class ClanDetailBloc extends Bloc<ClanDetailEvent, ClanDetailState> {
  ClanDetailBloc() : super(ClanDetailStateEmpty()) {
    on<ClearFilter>(_onClearFilter,
        transformer: throttleDroppable(const Duration(milliseconds: 0)));
    on<GetClanDetail>(_performFilter,
        transformer: throttleDroppable(const Duration(milliseconds: 1000)));
  }

  Future<void> _onClearFilter(
    ClearFilter event,
    Emitter<ClanDetailState> emit,
  ) async {
    return emit(ClanDetailStateEmpty());
  }

  Future<void> _performFilter(
    GetClanDetail event,
    Emitter<ClanDetailState> emit,
  ) async {
    if (event.clanTag.isEmptyOrNull) {
      return emit(ClanDetailStateEmpty());
    }

    emit(ClanDetailStateLoading());

    try {
      final result = await CocApiClans.getClanDetail(event.clanTag!);
      emit(ClanDetailStateSuccess(clanDetail: result));
    } catch (error) {
      emit(const ClanDetailStateError('something went wrong'));
    }
  }
}
