import 'package:bloc/bloc.dart';

import '../../../repositories/bookmarked_clans/bookmarked_clans_repository.dart';
import '../../../services/coc/coc_api_clans.dart';
import 'bookmarked_clans_event.dart';
import 'bookmarked_clans_state.dart';

class BookmarkedClansBloc
    extends Bloc<BookmarkedClansEvent, BookmarkedClansState> {
  BookmarkedClansBloc({required this.bookmarkedClansRepository})
      : super(BookmarkedClansStateEmpty()) {
    on<GetBookmarkedClanDetail>(_onGetBookmarkedClans);
  }

  final BookmarkedClansRepository bookmarkedClansRepository;

  Future<void> _onGetBookmarkedClans(
    GetBookmarkedClanDetail event,
    Emitter<BookmarkedClansState> emit,
  ) async {
    emit(BookmarkedClansStateLoading());

    final clanTags = bookmarkedClansRepository.getClanTags();
    final removedClanTags = clanTags
        .where((element) => !event.clanTagList.contains(element))
        .toList();
    for (String clanTag in removedClanTags) {
      bookmarkedClansRepository.removeBookmarkedClans(clanTag);
    }
    emit(BookmarkedClansStateSuccess(
      clanDetailList: bookmarkedClansRepository.getClanDetails(),
    ));

    for (String clanTag in event.clanTagList) {
      try {
        if (!bookmarkedClansRepository.contains(clanTag)) {
          final clanDetail = await CocApiClans.getClanDetail(clanTag);
          bookmarkedClansRepository.addOrUpdateBookmarkedClans(
              clanTag, clanDetail);
        }
      } catch (e) {
        emit(const BookmarkedClansStateError('something went wrong'));
      }
      emit(BookmarkedClansStateSuccess(
        clanDetailList: bookmarkedClansRepository.getClanDetails(),
      ));
    }

    //emit(BookmarkedClansStateCompleted());
  }
}
