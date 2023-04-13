import 'package:equatable/equatable.dart';

abstract class BookmarkedPlayersEvent extends Equatable {}

abstract class BookmarkedPlayersBaseEvent extends BookmarkedPlayersEvent {
  BookmarkedPlayersBaseEvent({required this.playerTagList});

  final List<String> playerTagList;

  @override
  List<Object?> get props => [playerTagList];
}

class GetBookmarkedPlayerDetail extends BookmarkedPlayersBaseEvent {
  GetBookmarkedPlayerDetail({required super.playerTagList});

  @override
  String toString() => 'TextChanged { playerTagList: $playerTagList }';
}
