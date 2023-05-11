import 'package:bloc/bloc.dart';

import '../../../repositories/bookmarked_clans/bookmarked_clans_repository.dart';
import '../../../services/coc/coc_api_clans.dart';
import 'bookmarked_clans_event.dart';
import 'bookmarked_clans_state.dart';

class BookmarkedClansBloc
    extends Bloc<BookmarkedClansEvent, BookmarkedClansState> {
  BookmarkedClansBloc({
    required this.bookmarkedClansRepository,
  }) : super(BookmarkedClansStateEmpty()) {
    on<GetBookmarkedClanDetail>(_onGetBookmarkedClans);
    on<RefreshBookmarkedClanDetail>(_onRefreshBookmarkedClans);
  }

  final BookmarkedClansRepository bookmarkedClansRepository;

  Future<void> _onGetBookmarkedClans(
    GetBookmarkedClanDetail event,
    Emitter<BookmarkedClansState> emit,
  ) async {
    bookmarkedClansRepository.cleanRemovedClanTags(event.clanTagList);
    final fetchedClanTags = bookmarkedClansRepository.getClanTags();
    final newClanTags =
        event.clanTagList.where((c) => !fetchedClanTags.contains(c)).toList();

    if (newClanTags.isEmpty) {
      return emit(BookmarkedClansStateSuccess(
        fetchingCompleted: true,
        clanDetailList: bookmarkedClansRepository.getClanDetails(),
      ));
    }

    for (final clanTag in newClanTags) {
      try {
        await _fetchClanDetail(clanTag);
      } catch (e) {
        emit(const BookmarkedClansStateError('something went wrong'));
      }
      emit(BookmarkedClansStateSuccess(
        fetchingCompleted: false,
        clanDetailList: bookmarkedClansRepository.getClanDetails(),
      ));
    }

    emit(BookmarkedClansStateSuccess(
      fetchingCompleted: true,
      clanDetailList: bookmarkedClansRepository.getClanDetails(),
    ));
  }

  Future<void> _onRefreshBookmarkedClans(
    RefreshBookmarkedClanDetail event,
    Emitter<BookmarkedClansState> emit,
  ) async {
    bookmarkedClansRepository.cleanRemovedClanTags(event.clanTagList);

    emit(BookmarkedClansStateSuccess(
      fetchingCompleted: false,
      clanDetailList: bookmarkedClansRepository.getClanDetails(),
    ));

    for (final clanTag in event.clanTagList) {
      try {
        await _fetchClanDetail(clanTag);
      } catch (e) {
        emit(const BookmarkedClansStateError('something went wrong'));
      }
      emit(BookmarkedClansStateSuccess(
        fetchingCompleted: false,
        clanDetailList: bookmarkedClansRepository.getClanDetails(),
      ));
    }

    emit(BookmarkedClansStateSuccess(
      fetchingCompleted: true,
      clanDetailList: bookmarkedClansRepository.getClanDetails(),
    ));
  }

  Future _fetchClanDetail(String clanTag) async {
    bookmarkedClansRepository.addOrUpdateBookmarkedClans(clanTag, null);

    final clanDetail = await CocApiClans.getClanDetail(clanTag);
    bookmarkedClansRepository.addOrUpdateBookmarkedClans(clanTag, clanDetail);
  }
}
