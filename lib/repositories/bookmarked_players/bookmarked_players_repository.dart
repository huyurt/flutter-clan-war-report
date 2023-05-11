import '../../models/api/response/player_detail_response_model.dart';
import 'bookmarked_players_cache.dart';

class BookmarkedPlayersRepository {
  const BookmarkedPlayersRepository({required this.cache});

  final BookmarkedPlayersCache cache;

  List<String> getPlayerTags() => cache.getKeys();

  List<PlayerDetailResponseModel?> getPlayerDetails() {
    final playerDetails = cache.getValues();
    return List.of(playerDetails);
  }

  bool contains(String playerTag) {
    return cache.contains(playerTag);
  }

  void addOrUpdateBookmarkedPlayers(
      String playerTag, PlayerDetailResponseModel? playerDetail) {
    cache.addOrUpdate(playerTag, playerDetail);
  }

  void removeBookmarkedPlayers(String playerTag) => cache.remove(playerTag);

  void changeBookmarkedPlayers(
      String playerTag, PlayerDetailResponseModel playerDetail) {
    if (cache.contains(playerTag)) {
      cache.remove(playerTag);
    } else {
      cache.addOrUpdate(playerTag, playerDetail);
    }
  }

  void cleanRemovedPlayerTags(List<String> newPlayerTagList) {
    final removedPlayerTags = getPlayerTags()
        .where((element) => !newPlayerTagList.contains(element))
        .toList();
    for (final playerTag in removedPlayerTags) {
      removeBookmarkedPlayers(playerTag);
    }
  }
}
