import 'package:bloc/bloc.dart';

import '../../../repositories/bookmarked_player_tags/bookmarked_player_tags_repository.dart';
import '../../../repositories/bookmarked_players/bookmarked_players_repository.dart';
import 'bookmarked_players_event.dart';
import 'bookmarked_players_state.dart';

class BookmarkedPlayersBloc
    extends Bloc<BookmarkedPlayersEvent, BookmarkedPlayersState> {
  BookmarkedPlayersBloc({
    required this.bookmarkedPlayersRepository,
    required this.bookmarkedPlayerTagsRepository,
  }) : super(const BookmarkedPlayersState.init()) {
    on<GetBookmarkedPlayerDetail>(_onGetBookmarkedPlayers);
    on<RefreshBookmarkedPlayerDetail>(_onRefreshBookmarkedPlayers);
    on<ReorderBookmarkedPlayerDetail>(_onReorderBookmarkedClans);
  }

  final BookmarkedPlayersRepository bookmarkedPlayersRepository;
  final BookmarkedPlayerTagsRepository bookmarkedPlayerTagsRepository;

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

    for (final playerTag in event.playerTagList) {
      try {
        await bookmarkedPlayersRepository.fetchPlayerDetail(playerTag);
      } catch (e) {
        emit(const BookmarkedPlayersState.failure());
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
    RefreshBookmarkedPlayerDetail event,
    Emitter<BookmarkedPlayersState> emit,
  ) async {
    bookmarkedPlayersRepository.cleanRemovedPlayerTags(event.playerTagList);

    for (final playerTag in event.playerTagList) {
      try {
        await bookmarkedPlayersRepository.fetchPlayerDetail(playerTag);
      } catch (e) {
        emit(const BookmarkedPlayersState.failure());
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
    final newIndex =
        event.newIndex > event.oldIndex ? (event.newIndex - 1) : event.newIndex;
    final item = state.items[event.oldIndex];
    if (item != null) {
      bookmarkedPlayersRepository.reorder(item, newIndex);
      await event.bookmarkedPlayerTagsCubit.onReorder(item.tag, newIndex);
    }

    emit(BookmarkedPlayersState.success(
      bookmarkedPlayersRepository.getPlayerDetails(),
    ));
  }
}
