import 'package:equatable/equatable.dart';

import '../../../models/api/response/player_detail_response_model.dart';
import '../../../utils/enums/bloc_status_enum.dart';

class BookmarkedPlayersState extends Equatable {
  final String? errorMessage;
  final BlocStatusEnum status;
  final List<PlayerDetailResponseModel?> items;

  const BookmarkedPlayersState._({
    this.errorMessage,
    this.status = BlocStatusEnum.loading,
    this.items = const <PlayerDetailResponseModel>[],
  });

  const BookmarkedPlayersState.init() : this._(status: BlocStatusEnum.init);

  const BookmarkedPlayersState.loading(
    List<PlayerDetailResponseModel?> items,
  ) : this._(status: BlocStatusEnum.loading, items: items);

  const BookmarkedPlayersState.success(
    List<PlayerDetailResponseModel?> items,
  ) : this._(status: BlocStatusEnum.success, items: items);

  const BookmarkedPlayersState.failure(
    String? errorMessage,
  ) : this._(errorMessage: errorMessage, status: BlocStatusEnum.failure);

  @override
  List<Object> get props => [status, items];
}
