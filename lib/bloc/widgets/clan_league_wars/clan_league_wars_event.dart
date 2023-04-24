import 'package:equatable/equatable.dart';

abstract class ClanCurrentWarDetailEvent extends Equatable {}

abstract class ClanLeagueWarsBaseEvent extends ClanCurrentWarDetailEvent {
  ClanLeagueWarsBaseEvent({required this.clanTag});

  final String clanTag;

  @override
  List<Object?> get props => [clanTag];
}

class ClearFilter extends ClanCurrentWarDetailEvent {
  @override
  List<Object?> get props => [];
}

class GetClanLeagueWars extends ClanLeagueWarsBaseEvent {
  GetClanLeagueWars({required super.clanTag});

  @override
  String toString() => 'TextChanged { clanTag: $clanTag }';
}
