import 'package:bloc/bloc.dart';

import '../../../repositories/bookmarked_players/bookmarked_players_repository.dart';
import '../../../services/coc/coc_api_players.dart';
import 'bookmarked_players_event.dart';
import 'bookmarked_players_state.dart';

class BookmarkedPlayersBloc
    extends Bloc<BookmarkedPlayersEvent, BookmarkedPlayersState> {
  BookmarkedPlayersBloc({
    required this.bookmarkedPlayersRepository,
  }) : super(BookmarkedPlayersStateEmpty()) {
    on<GetBookmarkedPlayerDetail>(_onGetBookmarkedPlayers);
    on<RefreshBookmarkedPlayerDetail>(_onRefreshBookmarkedPlayers);
  }

  final BookmarkedPlayersRepository bookmarkedPlayersRepository;

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
      return emit(BookmarkedPlayersStateSuccess(
        fetchingCompleted: true,
        playerDetailList: bookmarkedPlayersRepository.getPlayerDetails(),
      ));
    }

    for (final playerTag in event.playerTagList) {
      try {
        await _fetchPlayerDetail(playerTag);
      } catch (e) {
        emit(const BookmarkedPlayersStateError('something went wrong'));
      }
      emit(BookmarkedPlayersStateSuccess(
        fetchingCompleted: false,
        playerDetailList: bookmarkedPlayersRepository.getPlayerDetails(),
      ));
    }

    emit(BookmarkedPlayersStateSuccess(
      fetchingCompleted: true,
      playerDetailList: bookmarkedPlayersRepository.getPlayerDetails(),
    ));
  }

  Future<void> _onRefreshBookmarkedPlayers(
    RefreshBookmarkedPlayerDetail event,
    Emitter<BookmarkedPlayersState> emit,
  ) async {
    bookmarkedPlayersRepository.cleanRemovedPlayerTags(event.playerTagList);

    emit(BookmarkedPlayersStateSuccess(
      fetchingCompleted: false,
      playerDetailList: bookmarkedPlayersRepository.getPlayerDetails(),
    ));

    for (final playerTag in event.playerTagList) {
      try {
        await _fetchPlayerDetail(playerTag);
      } catch (e) {
        emit(const BookmarkedPlayersStateError('something went wrong'));
      }
      emit(BookmarkedPlayersStateSuccess(
        fetchingCompleted: false,
        playerDetailList: bookmarkedPlayersRepository.getPlayerDetails(),
      ));
    }

    emit(BookmarkedPlayersStateSuccess(
      fetchingCompleted: true,
      playerDetailList: bookmarkedPlayersRepository.getPlayerDetails(),
    ));
  }

  Future _fetchPlayerDetail(String playerTag) async {
    bookmarkedPlayersRepository.addOrUpdateBookmarkedPlayers(playerTag, null);

    final playerDetail = await CocApiPlayers.getPlayerDetail(playerTag);
    bookmarkedPlayersRepository.addOrUpdateBookmarkedPlayers(
        playerTag, playerDetail);
  }
}
