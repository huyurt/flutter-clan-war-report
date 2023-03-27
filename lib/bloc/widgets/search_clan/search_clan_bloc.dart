import 'package:bloc/bloc.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../models/api/search_clans_request_model.dart';
import '../../../services/coc/coc_api_clans.dart';
import 'search_clan_event.dart';
import 'search_clan_state.dart';

const _duration = Duration(milliseconds: 1000);

EventTransformer<Event> debounce<Event>(Duration duration) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

class SearchClanBloc extends Bloc<SearchClanEvent, SearchClanState> {
  SearchClanBloc()
      : super(SearchStateEmpty()) {
    on<TextChanged>(_onTextChanged, transformer: debounce(_duration));
  }

  Future<void> _onTextChanged(
    TextChanged event,
    Emitter<SearchClanState> emit,
  ) async {
    final clanName = event.clanName;
    final minMembers = event.minMembers;
    final maxMembers = event.maxMembers;
    final minClanLevel = event.minClanLevel;

    if (clanName.isEmpty) return emit(SearchStateEmpty());

    emit(SearchStateLoading());

    try {
      SearchClansRequestModel searchTerm = SearchClansRequestModel(
        clanName: clanName,
        minMembers: minMembers,
        maxMembers: maxMembers,
        minClanLevel: minClanLevel,
        //after: response?.paging.cursors.after
      );
      final results = await CocApiClans.searchClans(searchTerm);
      emit(SearchStateSuccess(results.items));
    } catch (error) {
      /*
      emit(
        error is SearchResultError
            ? SearchStateError(error.message)
            : const SearchStateError('something went wrong'),
      );
       */
    }
  }
}
