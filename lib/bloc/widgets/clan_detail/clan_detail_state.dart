import 'package:equatable/equatable.dart';

import '../../../models/api/response/clan_detail_response_model.dart';

abstract class ClanDetailState extends Equatable {
  const ClanDetailState();

  @override
  List<Object?> get props => [];
}

class ClanDetailStateEmpty extends ClanDetailState {}

class ClanDetailStateLoading extends ClanDetailState {}

class ClanDetailStateSuccess extends ClanDetailState {
  const ClanDetailStateSuccess({required this.clanDetail});

  final ClanDetailResponseModel clanDetail;

  @override
  List<Object?> get props => [clanDetail];

  @override
  String toString() =>
      'ClanDetailStateSuccess { clanDetail: $clanDetail }';
}

class ClanDetailStateError extends ClanDetailState {
  const ClanDetailStateError(this.error);

  final String error;

  @override
  List<Object?> get props => [error];
}
