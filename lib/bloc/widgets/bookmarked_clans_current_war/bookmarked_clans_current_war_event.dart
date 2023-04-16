import 'package:equatable/equatable.dart';

abstract class BookmarkedClansCurrentWarEvent extends Equatable {}

abstract class BookmarkedClansCurrentWarBaseEvent
    extends BookmarkedClansCurrentWarEvent {
  BookmarkedClansCurrentWarBaseEvent({required this.clanTagList});

  final List<String> clanTagList;

  @override
  List<Object?> get props => [clanTagList];
}

class GetBookmarkedClansCurrentWar extends BookmarkedClansCurrentWarBaseEvent {
  GetBookmarkedClansCurrentWar({required super.clanTagList});

  @override
  String toString() => 'TextChanged { clanTagList: $clanTagList }';
}
