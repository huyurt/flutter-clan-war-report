import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../repositories/war_log/war_log_repository.dart';
import '../../../utils/constants/locale_key.dart';
import 'war_log_event.dart';
import 'war_log_state.dart';

EventTransformer<Event> throttleDroppable<Event>(Duration duration) {
  return (events, mapper) =>
      droppable<Event>().call(events.throttle(duration), mapper);
}

class WarLogBloc extends Bloc<WarLogEvent, WarLogState> {
  WarLogBloc({required this.warLogRepository})
      : super(const WarLogState.init()) {
    on<GetWarLog>(_onGetWarLog,
        transformer: throttleDroppable(const Duration(milliseconds: 0)));
  }

  final WarLogRepository warLogRepository;

  Future<void> _onGetWarLog(
    GetWarLog event,
    Emitter<WarLogState> emit,
  ) async {
    try {
      final result = await warLogRepository.getWarLog(event.clanTag);
      emit(WarLogState.success(result.items));
    } catch (error) {
      if (error is DioError) {
        emit(WarLogState.failure(error.message));
      } else {
        emit(WarLogState.failure(tr(LocaleKey.cocApiErrorMessage)));
      }
    }
  }
}
