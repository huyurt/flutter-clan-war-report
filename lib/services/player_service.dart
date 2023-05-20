import '../models/api/response/player_detail_response_model.dart';
import 'coc_api/coc_api_players.dart';

class PlayerService {
  static Future<PlayerDetailResponseModel> getPlayerDetail(
      String playerTag) async {
    return CocApiPlayers.getPlayerDetail(playerTag);
  }
}
