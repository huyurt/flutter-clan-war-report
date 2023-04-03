import 'package:equatable/equatable.dart';

abstract class ClanDetailEvent extends Equatable {
}

abstract class ClanDetailBaseEvent extends ClanDetailEvent {
  ClanDetailBaseEvent({this.clanTag});

  final String? clanTag;

  @override
  List<Object?> get props => [clanTag];
}

class ClearFilter extends ClanDetailEvent {
  @override
  List<Object?> get props => [];
}

class GetClanDetail extends ClanDetailBaseEvent {
  GetClanDetail({required super.clanTag});

  @override
  String toString() => 'TextChanged { clanTag: $clanTag }';
}
