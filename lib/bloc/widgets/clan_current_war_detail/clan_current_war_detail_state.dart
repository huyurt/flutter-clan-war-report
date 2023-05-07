import 'package:equatable/equatable.dart';

import '../../../models/coc/clans_current_war_state_model.dart';

abstract class ClanCurrentWarDetailState extends Equatable {
  const ClanCurrentWarDetailState();

  @override
  List<Object?> get props => [];
}

class ClanCurrentWarDetailStateEmpty extends ClanCurrentWarDetailState {}

class ClanCurrentWarDetailStateLoading extends ClanCurrentWarDetailState {}

class ClanCurrentWarDetailStateSuccess extends ClanCurrentWarDetailState {
  const ClanCurrentWarDetailStateSuccess({required this.clanCurrentWarDetail});

  final ClansCurrentWarStateModel clanCurrentWarDetail;

  @override
  List<Object?> get props => [clanCurrentWarDetail];

  @override
  String toString() =>
      'ClanCurrentWarDetailStateSuccess { clanCurrentWarDetail: $clanCurrentWarDetail }';
}

class ClanCurrentWarDetailStateError extends ClanCurrentWarDetailState {
  const ClanCurrentWarDetailStateError(this.error);

  final String error;

  @override
  List<Object?> get props => [error];
}
