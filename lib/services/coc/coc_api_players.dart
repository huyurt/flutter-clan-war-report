import '../../models/api/player_detail_response_model.dart';
import 'coc_api_connector.dart';

class CocApiPlayers {
  static Future<PlayerDetailResponseModel> getPlayerDetail(
      String playerTag) async {
    final response = await CocApiConnector.dio.get(
      '/players/${Uri.encodeComponent(playerTag)}',
    );
    PlayerDetailResponseModel result =
        PlayerDetailResponseModel.fromMap(response.data);
    return result;
  }
}
