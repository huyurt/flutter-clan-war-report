import 'package:equatable/equatable.dart';

abstract class ClanCurrentWarDetailEvent extends Equatable {}

abstract class ClanCurrentWarDetailBaseEvent extends ClanCurrentWarDetailEvent {
  ClanCurrentWarDetailBaseEvent({required this.clanTag, this.warTag});

  final String clanTag;
  final String? warTag;

  @override
  List<Object?> get props => [clanTag, warTag];
}

class ClearFilter extends ClanCurrentWarDetailEvent {
  @override
  List<Object?> get props => [];
}

class GetClanCurrentWarDetail extends ClanCurrentWarDetailBaseEvent {
  GetClanCurrentWarDetail({required super.clanTag, super.warTag});

  @override
  String toString() => 'FetchDetail { clanTag: $clanTag, warTag: $warTag }';
}
