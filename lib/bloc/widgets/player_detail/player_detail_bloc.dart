import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../services/coc/coc_api_players.dart';
import 'player_detail_event.dart';
import 'player_detail_state.dart';

EventTransformer<Event> throttleDroppable<Event>(Duration duration) {
  return (events, mapper) =>
      droppable<Event>().call(events.throttle(duration), mapper);
}

class PlayerDetailBloc extends Bloc<PlayerDetailEvent, PlayerDetailState> {
  PlayerDetailBloc() : super(PlayerDetailStateEmpty()) {
    on<ClearFilter>(_onClearFilter,
        transformer: throttleDroppable(const Duration(milliseconds: 0)));
    on<GetPlayerDetail>(_onGetPlayerDetail,
        transformer: throttleDroppable(const Duration(milliseconds: 1000)));
  }

  Future<void> _onClearFilter(
    ClearFilter event,
    Emitter<PlayerDetailState> emit,
  ) async {
    return emit(PlayerDetailStateEmpty());
  }

  Future<void> _onGetPlayerDetail(
    GetPlayerDetail event,
    Emitter<PlayerDetailState> emit,
  ) async {
    if (event.playerTag.isEmptyOrNull) {
      return emit(PlayerDetailStateEmpty());
    }

    emit(PlayerDetailStateLoading());

    try {
      final result = await CocApiPlayers.getPlayerDetail(event.playerTag!);
      emit(PlayerDetailStateSuccess(playerDetail: result));
    } catch (error) {
      emit(const PlayerDetailStateError('something went wrong'));
    }
  }
}
