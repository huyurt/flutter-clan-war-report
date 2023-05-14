import 'package:bloc/bloc.dart';

import '../../../repositories/bookmarked_clans_current_war/bookmarked_clans_current_war_repository.dart';
import 'bookmarked_clans_current_war_event.dart';
import 'bookmarked_clans_current_war_state.dart';

class BookmarkedClansCurrentWarBloc extends Bloc<BookmarkedClansCurrentWarEvent,
    BookmarkedClansCurrentWarState> {
  BookmarkedClansCurrentWarBloc({
    required this.bookmarkedClansCurrentWarRepository,
  }) : super(const BookmarkedClansCurrentWarState.init()) {
    on<GetBookmarkedClansCurrentWar>(_onGetBookmarkedClansCurrentWar);
    on<RefreshBookmarkedClansCurrentWar>(_onRefreshBookmarkedClansCurrentWar);
  }

  final BookmarkedClansCurrentWarRepository bookmarkedClansCurrentWarRepository;

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
    RefreshBookmarkedClansCurrentWar event,
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
