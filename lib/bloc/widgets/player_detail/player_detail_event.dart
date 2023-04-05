import 'package:equatable/equatable.dart';

abstract class PlayerDetailEvent extends Equatable {
}

abstract class PlayerDetailBaseEvent extends PlayerDetailEvent {
  PlayerDetailBaseEvent({this.playerTag});

  final String? playerTag;

  @override
  List<Object?> get props => [playerTag];
}

class ClearFilter extends PlayerDetailEvent {
  @override
  List<Object?> get props => [];
}

class GetPlayerDetail extends PlayerDetailBaseEvent {
  GetPlayerDetail({required super.playerTag});

  @override
  String toString() => 'TextChanged { playerTag: $playerTag }';
}
