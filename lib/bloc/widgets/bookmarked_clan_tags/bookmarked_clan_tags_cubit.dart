import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:more_useful_clash_of_clans/utils/helpers/cache_helper.dart';

import '../../../repositories/bookmarked_clan_tags/bookmarked_clan_tags_repository.dart';

part 'bookmarked_clan_tags_state.dart';

class BookmarkedClanTagsCubit extends Cubit<BookmarkedClanTagsState> {
  BookmarkedClanTagsCubit({required this.bookmarkedClanTagsRepository})
      : super(
            BookmarkedClanTagsState(CacheHelper.getCachedBookmarkedClanTags()));

  final BookmarkedClanTagsRepository bookmarkedClanTagsRepository;

  Future<void> changeBookmarkedClanTags(String clanTag) async {
    final clanTags =
        await bookmarkedClanTagsRepository.changeBookmarkedClanTags(clanTag);
    emit(BookmarkedClanTagsState(clanTags));
  }
}
