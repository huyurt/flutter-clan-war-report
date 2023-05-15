import 'package:equatable/equatable.dart';
import 'package:more_useful_clash_of_clans/utils/enums/process_type_enum.dart';

import '../bookmarked_player_tags/bookmarked_player_tags_cubit.dart';

abstract class BookmarkedPlayersEvent extends Equatable {}

abstract class BookmarkedPlayersBaseEvent extends BookmarkedPlayersEvent {
  @override
  List<Object?> get props => [];
}

class GetBookmarkedPlayerDetail extends BookmarkedPlayersBaseEvent {
  GetBookmarkedPlayerDetail({
    required this.process,
    required this.playerTagList,
  });

  final ProcessType process;
  final List<String> playerTagList;

  @override
  List<Object?> get props => [process, playerTagList];
}

class ReorderBookmarkedPlayerDetail extends BookmarkedPlayersBaseEvent {
  ReorderBookmarkedPlayerDetail({
    required this.oldIndex,
    required this.newIndex,
    required this.bookmarkedPlayerTagsCubit,
  });

  final int oldIndex;
  final int newIndex;
  final BookmarkedPlayerTagsCubit bookmarkedPlayerTagsCubit;

  @override
  List<Object?> get props => [oldIndex, newIndex];
}
