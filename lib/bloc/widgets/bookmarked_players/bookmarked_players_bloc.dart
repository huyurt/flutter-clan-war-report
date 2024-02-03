import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../repositories/bookmarked_player_tags/bookmarked_player_tags_repository.dart';
import '../../../repositories/bookmarked_players/bookmarked_players_repository.dart';
import '../../../utils/constants/locale_key.dart';
import '../../../utils/enums/process_type_enum.dart';
import 'bookmarked_players_event.dart';
import 'bookmarked_players_state.dart';

EventTransformer<Event> throttleDroppable<Event>(Duration duration) {
  return (events, mapper) =>
      droppable<Event>().call(events.throttle(duration), mapper);
}

class BookmarkedPlayersBloc
    extends Bloc<BookmarkedPlayersEvent, BookmarkedPlayersState> {
  BookmarkedPlayersBloc({
    required this.bookmarkedPlayersRepository,
    required this.bookmarkedPlayerTagsRepository,
  }) : super(const BookmarkedPlayersState.init()) {
    on<GetBookmarkedPlayerDetail>(_emitter,
        transformer: throttleDroppable(const Duration(milliseconds: 0)));
    on<ReorderBookmarkedPlayerDetail>(_onReorderBookmarkedClans);
  }

  final BookmarkedPlayersRepository bookmarkedPlayersRepository;
  final BookmarkedPlayerTagsRepository bookmarkedPlayerTagsRepository;

  Future<void> _emitter(
    GetBookmarkedPlayerDetail event,
    Emitter<BookmarkedPlayersState> emit,
  ) async {
    switch (event.process) {
      case ProcessType.list:
        return _onGetBookmarkedPlayers(event, emit);
      case ProcessType.refresh:
        return _onRefreshBookmarkedPlayers(event, emit);
    }
  }

  Future<void> _onGetBookmarkedPlayers(
    GetBookmarkedPlayerDetail event,
    Emitter<BookmarkedPlayersState> emit,
  ) async {
    bookmarkedPlayersRepository.cleanRemovedPlayerTags(event.playerTagList);
    final fetchedPlayerTags = bookmarkedPlayersRepository.getPlayerTags();
    final newPlayerTags = event.playerTagList
        .where((c) => !fetchedPlayerTags.contains(c))
        .toList();

    if (newPlayerTags.isEmpty) {
      return emit(BookmarkedPlayersState.success(
        bookmarkedPlayersRepository.getPlayerDetails(),
      ));
    }

    emit(BookmarkedPlayersState.loading(
      bookmarkedPlayersRepository.getPlayerDetails(),
    ));

    for (final playerTag in event.playerTagList) {
      try {
        await bookmarkedPlayersRepository.fetchPlayerDetail(playerTag);
      } catch (error) {
        if (error is DioException) {
          if (!await InternetConnectionChecker().hasConnection) {
            return emit(BookmarkedPlayersState.failure(error.message));
          }
          emit(BookmarkedPlayersState.failure(error.message));
        } else {
          emit(BookmarkedPlayersState.failure(tr(LocaleKey.cocApiErrorMessage)));
        }
      }
      emit(BookmarkedPlayersState.loading(
        bookmarkedPlayersRepository.getPlayerDetails(),
      ));
    }

    emit(BookmarkedPlayersState.success(
      bookmarkedPlayersRepository.getPlayerDetails(),
    ));
  }

  Future<void> _onRefreshBookmarkedPlayers(
    GetBookmarkedPlayerDetail event,
    Emitter<BookmarkedPlayersState> emit,
  ) async {
    bookmarkedPlayersRepository.cleanRemovedPlayerTags(event.playerTagList);

    emit(BookmarkedPlayersState.loading(
      bookmarkedPlayersRepository.getPlayerDetails(),
    ));

    for (final playerTag in event.playerTagList) {
      try {
        await bookmarkedPlayersRepository.fetchPlayerDetail(playerTag);
      } catch (error) {
        if (error is DioException) {
          if (!await InternetConnectionChecker().hasConnection) {
            return emit(BookmarkedPlayersState.failure(error.message));
          }
          emit(BookmarkedPlayersState.failure(error.message));
        } else {
          emit(BookmarkedPlayersState.failure(tr(LocaleKey.cocApiErrorMessage)));
        }
      }
      emit(BookmarkedPlayersState.loading(
        bookmarkedPlayersRepository.getPlayerDetails(),
      ));
    }

    emit(BookmarkedPlayersState.success(
      bookmarkedPlayersRepository.getPlayerDetails(),
    ));
  }

  Future<void> _onReorderBookmarkedClans(
    ReorderBookmarkedPlayerDetail event,
    Emitter<BookmarkedPlayersState> emit,
  ) async {
    final newIndex = event.newIndex > event.oldIndex ? (event.newIndex - 1) : event.newIndex;
    final item = state.items[event.oldIndex];
    if (item != null) {
      bookmarkedPlayersRepository.reorder(item, newIndex);
      await event.bookmarkedPlayerTagsCubit.onReorder(item.tag ?? '', newIndex);
    }

    emit(BookmarkedPlayersState.success(
      bookmarkedPlayersRepository.getPlayerDetails(),
    ));
  }
}
