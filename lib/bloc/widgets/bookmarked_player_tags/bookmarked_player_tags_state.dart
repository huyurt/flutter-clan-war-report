part of 'bookmarked_player_tags_cubit.dart';

class BookmarkedPlayerTagsState extends Equatable {
  final List<String> playerTags;

  const BookmarkedPlayerTagsState(this.playerTags);

  @override
  List<Object> get props => [playerTags];
}
