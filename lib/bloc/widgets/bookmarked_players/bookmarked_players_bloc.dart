import 'package:bloc/bloc.dart';

import '../../../repositories/bookmarked_players/bookmarked_players_repository.dart';
import '../../../services/coc/coc_api_players.dart';
import 'bookmarked_players_event.dart';
import 'bookmarked_players_state.dart';

class BookmarkedPlayersBloc
    extends Bloc<BookmarkedPlayersEvent, BookmarkedPlayersState> {
  BookmarkedPlayersBloc({required this.bookmarkedPlayersRepository})
      : super(BookmarkedPlayersStateEmpty()) {
    on<GetBookmarkedPlayerDetail>(_onGetBookmarkedPlayers);
  }

  final BookmarkedPlayersRepository bookmarkedPlayersRepository;

  Future<void> _onGetBookmarkedPlayers(
    GetBookmarkedPlayerDetail event,
    Emitter<BookmarkedPlayersState> emit,
  ) async {
    emit(BookmarkedPlayersStateLoading());

    final playerTags = bookmarkedPlayersRepository.getPlayerTags();
    final removedPlayerTags = playerTags
        .where((element) => !event.playerTagList.contains(element))
        .toList();
    for (String playerTag in removedPlayerTags) {
      bookmarkedPlayersRepository.removeBookmarkedPlayers(playerTag);
    }
    emit(BookmarkedPlayersStateSuccess(
      playerDetailList: bookmarkedPlayersRepository.getPlayerDetails(),
    ));

    for (String playerTag in event.playerTagList) {
      try {
        if (!bookmarkedPlayersRepository.contains(playerTag)) {
          final playerDetail = await CocApiPlayers.getPlayerDetail(playerTag);
          bookmarkedPlayersRepository.addOrUpdateBookmarkedPlayers(
              playerTag, playerDetail);
        }
      } catch (e) {
        emit(const BookmarkedPlayersStateError('something went wrong'));
      }
      emit(BookmarkedPlayersStateSuccess(
        playerDetailList: bookmarkedPlayersRepository.getPlayerDetails(),
      ));
    }

    //emit(BookmarkedPlayersStateCompleted());
  }
}
