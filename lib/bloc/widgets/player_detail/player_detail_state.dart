import 'package:equatable/equatable.dart';

import '../../../models/api/response/player_detail_response_model.dart';
import '../../../utils/enums/bloc_status_enum.dart';

class PlayerDetailState extends Equatable {
  final BlocStatusEnum status;
  final PlayerDetailResponseModel? item;

  const PlayerDetailState._({
    this.status = BlocStatusEnum.loading,
    this.item,
  });

  const PlayerDetailState.init() : this._(status: BlocStatusEnum.init);

  const PlayerDetailState.loading() : this._(status: BlocStatusEnum.loading);

  const PlayerDetailState.success(
    PlayerDetailResponseModel item,
  ) : this._(status: BlocStatusEnum.success, item: item);

  const PlayerDetailState.failure() : this._(status: BlocStatusEnum.failure);

  @override
  List<Object?> get props => [status, item];
}
