import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../repositories/search_clan/search_clan_repository.dart';
import '../../../models/api/search_clans_request_model.dart';
import 'search_clan_event.dart';
import 'search_clan_state.dart';

EventTransformer<Event> debounce<Event>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

EventTransformer<Event> throttleDroppable<Event>(Duration duration) {
  return (events, mapper) =>
      droppable<Event>().call(events.throttle(duration), mapper);
}

class SearchClanBloc extends Bloc<SearchClanEvent, SearchClanState> {
  SearchClanBloc({required this.searchClanRepository})
      : super(SearchStateEmpty()) {
    on<ClearFilter>(_onClearFilter,
        transformer: throttleDroppable(const Duration(milliseconds: 0)));
    on<TextChanged>(_onTextChanged,
        transformer: debounce(const Duration(milliseconds: 1000)));
    on<FilterChanged>(_onFilterChanged,
        transformer: debounce(const Duration(milliseconds: 0)));
    on<NextPageFetched>(_onNextPageFetched,
        transformer: throttleDroppable(const Duration(milliseconds: 100)));
  }

  // TODO: copyWith

  final SearchClanRepository searchClanRepository;

  Future<void> _onClearFilter(
    ClearFilter event,
    Emitter<SearchClanState> emit,
  ) async {
    return emit(SearchStateEmpty());
  }

  Future<void> _onTextChanged(
    TextChanged event,
    Emitter<SearchClanState> emit,
  ) async {
    await _performFilter(event.searchTerm, false, emit);
  }

  Future<void> _onFilterChanged(
    FilterChanged event,
    Emitter<SearchClanState> emit,
  ) async {
    await _performFilter(event.searchTerm, false, emit);
  }

  Future<void> _onNextPageFetched(
    NextPageFetched event,
    Emitter<SearchClanState> emit,
  ) async {
    if (event.searchTerm.after.isEmptyOrNull) {
      return;
    }
    await _performFilter(event.searchTerm, true, emit);
  }

  Future<void> _performFilter(
    SearchClansRequestModel searchTerm,
    bool isNextPageRequest,
    Emitter<SearchClanState> emit,
  ) async {
    if (searchTerm.clanName.isEmptyOrNull || searchTerm.clanName.length < 3) {
      return emit(SearchStateEmpty());
    }

    if (!isNextPageRequest) {
      emit(SearchStateLoading());
    }

    try {
      final result =
          await searchClanRepository.searchClans(isNextPageRequest, searchTerm);
      emit(SearchStateSuccess(after: result.after, items: result.items));
    } catch (error) {
      emit(const SearchStateError('something went wrong'));
    }
  }
}
