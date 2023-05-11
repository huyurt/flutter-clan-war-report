import 'package:equatable/equatable.dart';

abstract class BookmarkedClansEvent extends Equatable {
}

abstract class BookmarkedClansBaseEvent extends BookmarkedClansEvent {
  BookmarkedClansBaseEvent({required this.clanTagList});

  final List<String> clanTagList;

  @override
  List<Object?> get props => [clanTagList];
}

class GetBookmarkedClanDetail extends BookmarkedClansBaseEvent {
  GetBookmarkedClanDetail({required super.clanTagList});

  @override
  String toString() => 'FetchList { clanTagList: $clanTagList }';
}

class RefreshBookmarkedClanDetail extends BookmarkedClansBaseEvent {
  RefreshBookmarkedClanDetail({required super.clanTagList});

  @override
  String toString() => 'RefreshList { clanTagList: $clanTagList }';
}
