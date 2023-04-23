import 'package:equatable/equatable.dart';

import '../../../models/api/clan_war_response_model.dart';
import '../../../utils/enums/war_type_enum.dart';

abstract class ClanCurrentWarDetailState extends Equatable {
  const ClanCurrentWarDetailState();

  @override
  List<Object?> get props => [];
}

class ClanCurrentWarDetailStateEmpty extends ClanCurrentWarDetailState {}

class ClanCurrentWarDetailStateLoading extends ClanCurrentWarDetailState {}

class ClanCurrentWarDetailStateSuccess extends ClanCurrentWarDetailState {
  const ClanCurrentWarDetailStateSuccess(
      {required this.warType, required this.clanCurrentWarDetail});

  final WarTypeEnum warType;
  final ClanWarResponseModel clanCurrentWarDetail;

  @override
  List<Object?> get props => [warType, clanCurrentWarDetail];

  @override
  String toString() =>
      'ClanCurrentWarDetailStateSuccess { warType: $warType, clanCurrentWarDetail: $clanCurrentWarDetail }';
}

class ClanCurrentWarDetailStateError extends ClanCurrentWarDetailState {
  const ClanCurrentWarDetailStateError(this.error);

  final String error;

  @override
  List<Object?> get props => [error];
}
