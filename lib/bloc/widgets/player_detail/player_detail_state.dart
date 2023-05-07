import 'package:equatable/equatable.dart';

import '../../../models/api/response/player_detail_response_model.dart';

abstract class PlayerDetailState extends Equatable {
  const PlayerDetailState();

  @override
  List<Object?> get props => [];
}

class PlayerDetailStateEmpty extends PlayerDetailState {}

class PlayerDetailStateLoading extends PlayerDetailState {}

class PlayerDetailStateSuccess extends PlayerDetailState {
  const PlayerDetailStateSuccess({required this.playerDetail});

  final PlayerDetailResponseModel playerDetail;

  @override
  List<Object?> get props => [playerDetail];

  @override
  String toString() =>
      'PlayerDetailStateSuccess { playerDetail: $playerDetail }';
}

class PlayerDetailStateError extends PlayerDetailState {
  const PlayerDetailStateError(this.error);

  final String error;

  @override
  List<Object?> get props => [error];
}
