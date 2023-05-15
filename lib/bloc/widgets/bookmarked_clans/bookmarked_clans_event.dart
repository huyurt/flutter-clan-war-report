import 'package:equatable/equatable.dart';

import '../../../utils/enums/process_type_enum.dart';
import '../bookmarked_clan_tags/bookmarked_clan_tags_cubit.dart';

abstract class BookmarkedClansEvent extends Equatable {}

abstract class BookmarkedClansBaseEvent extends BookmarkedClansEvent {
  @override
  List<Object?> get props => [];
}

class GetBookmarkedClanDetail extends BookmarkedClansBaseEvent {
  GetBookmarkedClanDetail({
    required this.process,
    required this.clanTagList,
  });

  final ProcessType process;
  final List<String> clanTagList;

  @override
  List<Object?> get props => [process, clanTagList];
}

class ReorderBookmarkedClanDetail extends BookmarkedClansBaseEvent {
  ReorderBookmarkedClanDetail({
    required this.oldIndex,
    required this.newIndex,
    required this.bookmarkedClanTagsCubit,
  });

  final int oldIndex;
  final int newIndex;
  final BookmarkedClanTagsCubit bookmarkedClanTagsCubit;

  @override
  List<Object?> get props => [oldIndex, newIndex];
}
