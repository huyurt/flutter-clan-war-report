import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dio/dio.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../models/api/response/player_detail_response_model.dart';
import '../../../repositories/search_player/search_player_repository.dart';
import 'search_player_event.dart';
import 'search_player_state.dart';

EventTransformer<Event> debounce<Event>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

EventTransformer<Event> throttleDroppable<Event>(Duration duration) {
  return (events, mapper) =>
      droppable<Event>().call(events.throttle(duration), mapper);
}

class SearchPlayerBloc extends Bloc<SearchPlayerEvent, SearchPlayerState> {
  SearchPlayerBloc({required this.searchPlayerRepository})
      : super(const SearchPlayerState.init()) {
    on<ClearFilter>(_onClearFilter,
        transformer: throttleDroppable(const Duration(milliseconds: 0)));
    on<TextChanged>(_onTextChanged,
        transformer: debounce(const Duration(milliseconds: 1000)));
  }

  // TODO: copyWith

  final SearchPlayerRepository searchPlayerRepository;

  Future<void> _onClearFilter(
    ClearFilter event,
    Emitter<SearchPlayerState> emit,
  ) async {
    return emit(const SearchPlayerState.init());
  }

  Future<void> _onTextChanged(
    TextChanged event,
    Emitter<SearchPlayerState> emit,
  ) async {
    await _performFilter(event.searchTerm, emit);
  }

  Future<void> _performFilter(
    String? searchTerm,
    Emitter<SearchPlayerState> emit,
  ) async {
    if ((searchTerm?.isEmptyOrNull ?? true) || (searchTerm?.length ?? 0) < 3) {
      return emit(const SearchPlayerState.init());
    }

    try {
      final result = await searchPlayerRepository.searchPlayers(searchTerm!);
      emit(SearchPlayerState.success(result.items));
    } catch (error) {
      if (error is DioError) {
        if (error.response?.statusCode == HttpStatus.notFound) {
          return emit(
              const SearchPlayerState.success(<PlayerDetailResponseModel>[]));
        }
      }
      emit(const SearchPlayerState.failure());
    }
  }
}
