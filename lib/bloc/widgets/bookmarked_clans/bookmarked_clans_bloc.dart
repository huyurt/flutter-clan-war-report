import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:more_useful_clash_of_clans/utils/constants/locale_key.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../repositories/bookmarked_clan_tags/bookmarked_clan_tags_repository.dart';
import '../../../repositories/bookmarked_clans/bookmarked_clans_repository.dart';
import '../../../utils/enums/process_type_enum.dart';
import 'bookmarked_clans_event.dart';
import 'bookmarked_clans_state.dart';

EventTransformer<Event> throttleDroppable<Event>(Duration duration) {
  return (events, mapper) =>
      droppable<Event>().call(events.throttle(duration), mapper);
}

class BookmarkedClansBloc
    extends Bloc<BookmarkedClansEvent, BookmarkedClansState> {
  BookmarkedClansBloc({
    required this.bookmarkedClansRepository,
    required this.bookmarkedClanTagsRepository,
  }) : super(const BookmarkedClansState.init()) {
    on<GetBookmarkedClanDetail>(_emitter,
        transformer: throttleDroppable(const Duration(milliseconds: 0)));
    on<ReorderBookmarkedClanDetail>(_onReorderBookmarkedClans);
  }

  final BookmarkedClansRepository bookmarkedClansRepository;
  final BookmarkedClanTagsRepository bookmarkedClanTagsRepository;

  Future<void> _emitter(
    GetBookmarkedClanDetail event,
    Emitter<BookmarkedClansState> emit,
  ) async {
    switch (event.process) {
      case ProcessType.list:
        return _onGetBookmarkedClans(event, emit);
      case ProcessType.refresh:
        return _onRefreshBookmarkedClans(event, emit);
    }
  }

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

    emit(BookmarkedClansState.loading(
      bookmarkedClansRepository.getClanDetails(),
    ));

    for (final clanTag in newClanTags) {
      try {
        await bookmarkedClansRepository.fetchClanDetail(clanTag);
      } catch (error) {
        if (error is DioError) {
          emit(BookmarkedClansState.failure(error.message));
        } else {
          emit(BookmarkedClansState.failure(tr(LocaleKey.cocApiErrorMessage)));
        }
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
    GetBookmarkedClanDetail event,
    Emitter<BookmarkedClansState> emit,
  ) async {
    bookmarkedClansRepository.cleanRemovedClanTags(event.clanTagList);

    emit(BookmarkedClansState.loading(
      bookmarkedClansRepository.getClanDetails(),
    ));

    for (final clanTag in event.clanTagList) {
      try {
        await bookmarkedClansRepository.fetchClanDetail(clanTag);
      } catch (error) {
        if (error is DioError) {
          emit(BookmarkedClansState.failure(error.message));
        } else {
          emit(BookmarkedClansState.failure(tr(LocaleKey.cocApiErrorMessage)));
        }
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
