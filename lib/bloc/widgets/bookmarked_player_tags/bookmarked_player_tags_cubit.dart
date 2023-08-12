import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:clan_war_report/utils/helpers/cache_helper.dart';

import '../../../repositories/bookmarked_player_tags/bookmarked_player_tags_repository.dart';

part 'bookmarked_player_tags_state.dart';

class BookmarkedPlayerTagsCubit extends Cubit<BookmarkedPlayerTagsState> {
  BookmarkedPlayerTagsCubit({required this.bookmarkedPlayerTagsRepository})
      : super(BookmarkedPlayerTagsState(
            CacheHelper.getCachedBookmarkedPlayerTags()));

  final BookmarkedPlayerTagsRepository bookmarkedPlayerTagsRepository;

  Future<void> changeBookmarkedPlayerTags(String playerTag) async {
    final playerTags = await bookmarkedPlayerTagsRepository
        .changeBookmarkedPlayerTags(playerTag);
    emit(BookmarkedPlayerTagsState(playerTags));
  }

  Future<void> onReorder(String playerTag, int newIndex) async {
    await bookmarkedPlayerTagsRepository.reorder(playerTag, newIndex);

    final playerTags = bookmarkedPlayerTagsRepository.getPlayerTags();
    emit(BookmarkedPlayerTagsState(playerTags));
  }
}
