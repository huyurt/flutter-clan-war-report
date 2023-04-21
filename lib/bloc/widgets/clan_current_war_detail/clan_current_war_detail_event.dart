import 'package:equatable/equatable.dart';

abstract class ClanCurrentWarDetailEvent extends Equatable {
}

abstract class ClanCurrentWarDetailBaseEvent extends ClanCurrentWarDetailEvent {
  ClanCurrentWarDetailBaseEvent({required this.clanTag});

  final String clanTag;

  @override
  List<Object?> get props => [clanTag];
}

class ClearFilter extends ClanCurrentWarDetailEvent {
  @override
  List<Object?> get props => [];
}

class GetClanCurrentWarDetail extends ClanCurrentWarDetailBaseEvent {
  GetClanCurrentWarDetail({required super.clanTag});

  @override
  String toString() => 'TextChanged { clanTag: $clanTag }';
}
