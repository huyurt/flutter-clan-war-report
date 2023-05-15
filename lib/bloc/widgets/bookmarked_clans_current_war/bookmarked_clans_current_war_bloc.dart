import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../repositories/bookmarked_clans_current_war/bookmarked_clans_current_war_repository.dart';
import '../../../utils/enums/process_type_enum.dart';
import 'bookmarked_clans_current_war_event.dart';
import 'bookmarked_clans_current_war_state.dart';

EventTransformer<Event> throttleDroppable<Event>(Duration duration) {
  return (events, mapper) =>
      droppable<Event>().call(events.throttle(duration), mapper);
}

class BookmarkedClansCurrentWarBloc extends Bloc<BookmarkedClansCurrentWarEvent,
    BookmarkedClansCurrentWarState> {
  BookmarkedClansCurrentWarBloc({
    required this.bookmarkedClansCurrentWarRepository,
  }) : super(const BookmarkedClansCurrentWarState.init()) {
    on<GetBookmarkedClansCurrentWar>(_emitter,
        transformer: throttleDroppable(const Duration(milliseconds: 0)));
  }

  final BookmarkedClansCurrentWarRepository bookmarkedClansCurrentWarRepository;

  Future<void> _emitter(
    GetBookmarkedClansCurrentWar event,
    Emitter<BookmarkedClansCurrentWarState> emit,
  ) async {
    switch (event.process) {
      case ProcessType.list:
        return _onGetBookmarkedClansCurrentWar(event, emit);
      case ProcessType.refresh:
        return _onRefreshBookmarkedClansCurrentWar(event, emit);
    }
  }

  Future<void> _onGetBookmarkedClansCurrentWar(
    GetBookmarkedClansCurrentWar event,
    Emitter<BookmarkedClansCurrentWarState> emit,
  ) async {
    bookmarkedClansCurrentWarRepository.cleanRemovedClanTags(event.clanTagList);
    final fetchedClanTags = bookmarkedClansCurrentWarRepository.getClanTags();
    final newClanTags =
        event.clanTagList.where((c) => !fetchedClanTags.contains(c)).toList();

    if (newClanTags.isEmpty) {
      return emit(BookmarkedClansCurrentWarState.success(
        bookmarkedClansCurrentWarRepository.getClansCurrentWar(),
      ));
    }

    for (final clanTag in newClanTags) {
      try {
        await bookmarkedClansCurrentWarRepository.fetchClanCurrentWar(clanTag);
      } catch (e) {
        emit(const BookmarkedClansCurrentWarState.failure());
      }
      emit(BookmarkedClansCurrentWarState.loading(
        bookmarkedClansCurrentWarRepository.getClansCurrentWar(),
      ));
    }

    emit(BookmarkedClansCurrentWarState.success(
      bookmarkedClansCurrentWarRepository.getClansCurrentWar(),
    ));
  }

  Future<void> _onRefreshBookmarkedClansCurrentWar(
    GetBookmarkedClansCurrentWar event,
    Emitter<BookmarkedClansCurrentWarState> emit,
  ) async {
    bookmarkedClansCurrentWarRepository.cleanRemovedClanTags(event.clanTagList);

    for (final clanTag in event.clanTagList) {
      try {
        await bookmarkedClansCurrentWarRepository.fetchClanCurrentWar(clanTag);
      } catch (e) {
        emit(const BookmarkedClansCurrentWarState.failure());
      }
      emit(BookmarkedClansCurrentWarState.loading(
        bookmarkedClansCurrentWarRepository.getClansCurrentWar(),
      ));
    }

    emit(BookmarkedClansCurrentWarState.success(
      bookmarkedClansCurrentWarRepository.getClansCurrentWar(),
    ));
  }
}
