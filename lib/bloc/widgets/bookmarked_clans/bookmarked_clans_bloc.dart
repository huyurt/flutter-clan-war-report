import 'package:bloc/bloc.dart';

import '../../../repositories/bookmarked_clan_tags/bookmarked_clan_tags_repository.dart';
import '../../../repositories/bookmarked_clans/bookmarked_clans_repository.dart';
import 'bookmarked_clans_event.dart';
import 'bookmarked_clans_state.dart';

class BookmarkedClansBloc
    extends Bloc<BookmarkedClansEvent, BookmarkedClansState> {
  BookmarkedClansBloc({
    required this.bookmarkedClansRepository,
    required this.bookmarkedClanTagsRepository,
  }) : super(const BookmarkedClansState.init()) {
    on<GetBookmarkedClanDetail>(_onGetBookmarkedClans);
    on<RefreshBookmarkedClanDetail>(_onRefreshBookmarkedClans);
    on<ReorderBookmarkedClanDetail>(_onReorderBookmarkedClans);
  }

  final BookmarkedClansRepository bookmarkedClansRepository;
  final BookmarkedClanTagsRepository bookmarkedClanTagsRepository;

  Future<void> _onGetBookmarkedClans(
    GetBookmarkedClanDetail event,
    Emitter<BookmarkedClansState> emit,
  ) async {
    bookmarkedClansRepository.cleanRemovedClanTags(event.clanTagList);
    final fetchedClanTags = bookmarkedClansRepository.getClanTags();
    final newClanTags =
        event.clanTagList.where((c) => !fetchedClanTags.contains(c)).toList();

    if (newClanTags.isEmpty) {
      return emit(BookmarkedClansState.success(
        bookmarkedClansRepository.getClanDetails(),
      ));
    }

    for (final clanTag in newClanTags) {
      try {
        await bookmarkedClansRepository.fetchClanDetail(clanTag);
      } catch (e) {
        emit(const BookmarkedClansState.failure());
      }
      emit(BookmarkedClansState.loading(
        bookmarkedClansRepository.getClanDetails(),
      ));
    }

    emit(BookmarkedClansState.success(
      bookmarkedClansRepository.getClanDetails(),
    ));
  }

  Future<void> _onRefreshBookmarkedClans(
    RefreshBookmarkedClanDetail event,
    Emitter<BookmarkedClansState> emit,
  ) async {
    bookmarkedClansRepository.cleanRemovedClanTags(event.clanTagList);

    for (final clanTag in event.clanTagList) {
      try {
        await bookmarkedClansRepository.fetchClanDetail(clanTag);
      } catch (e) {
        emit(const BookmarkedClansState.failure());
      }
      emit(BookmarkedClansState.loading(
        bookmarkedClansRepository.getClanDetails(),
      ));
    }

    emit(BookmarkedClansState.success(
      bookmarkedClansRepository.getClanDetails(),
    ));
  }

  Future<void> _onReorderBookmarkedClans(
    ReorderBookmarkedClanDetail event,
    Emitter<BookmarkedClansState> emit,
  ) async {
    final newIndex =
        event.newIndex > event.oldIndex ? (event.newIndex - 1) : event.newIndex;
    final item = state.items[event.oldIndex];
    if (item != null) {
      bookmarkedClansRepository.reorder(item, newIndex);
      await event.bookmarkedClanTagsCubit.onReorder(item.tag, newIndex);
    }

    emit(BookmarkedClansState.success(
      bookmarkedClansRepository.getClanDetails(),
    ));
  }
}
