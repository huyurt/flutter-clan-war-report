import 'package:equatable/equatable.dart';

import '../../../models/api/response/clan_detail_response_model.dart';

abstract class BookmarkedClansState extends Equatable {
  const BookmarkedClansState();

  @override
  List<Object?> get props => [];
}

class BookmarkedClansStateEmpty extends BookmarkedClansState {}

class BookmarkedClansStateLoading extends BookmarkedClansState {}

class BookmarkedClansStateSuccess extends BookmarkedClansState {
  const BookmarkedClansStateSuccess({
    required this.fetchingCompleted,
    required this.clanDetailList,
  });

  final bool fetchingCompleted;
  final List<ClanDetailResponseModel?> clanDetailList;

  @override
  List<Object?> get props => [fetchingCompleted, clanDetailList];

  @override
  String toString() =>
      'BookmarkedClansStateSuccess { fetchingCompleted: $fetchingCompleted, clanDetailList: $clanDetailList }';
}

class BookmarkedClansStateError extends BookmarkedClansState {
  const BookmarkedClansStateError(this.error);

  final String error;

  @override
  List<Object?> get props => [error];
}
