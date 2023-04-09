part of 'bookmarked_clan_tags_cubit.dart';

class BookmarkedClanTagsState extends Equatable {
  final List<String> clanTags;

  const BookmarkedClanTagsState(this.clanTags);

  @override
  List<Object> get props => [clanTags];
}
