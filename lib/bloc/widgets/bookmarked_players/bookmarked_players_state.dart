import 'package:equatable/equatable.dart';

import '../../../models/api/response/player_detail_response_model.dart';

abstract class BookmarkedPlayersState extends Equatable {
  const BookmarkedPlayersState();

  @override
  List<Object?> get props => [];
}

class BookmarkedPlayersStateEmpty extends BookmarkedPlayersState {}

class BookmarkedPlayersStateLoading extends BookmarkedPlayersState {}

class BookmarkedPlayersStateCompleted extends BookmarkedPlayersState {}

class BookmarkedPlayersStateSuccess extends BookmarkedPlayersState {
  const BookmarkedPlayersStateSuccess({required this.playerDetailList});

  final List<PlayerDetailResponseModel> playerDetailList;

  @override
  List<Object?> get props => [playerDetailList];

  @override
  String toString() =>
      'BookmarkedPlayersStateSuccess { playerDetailList: $playerDetailList }';
}

class BookmarkedPlayersStateError extends BookmarkedPlayersState {
  const BookmarkedPlayersStateError(this.error);

  final String error;

  @override
  List<Object?> get props => [error];
}
