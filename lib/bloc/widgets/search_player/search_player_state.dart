import 'package:equatable/equatable.dart';

import '../../../models/api/response/player_detail_response_model.dart';
import '../../../utils/enums/bloc_status_enum.dart';

class SearchPlayerState extends Equatable {
  final String? errorMessage;
  final BlocStatusEnum status;
  final List<PlayerDetailResponseModel> items;

  const SearchPlayerState._({
    this.errorMessage,
    this.status = BlocStatusEnum.loading,
    this.items = const <PlayerDetailResponseModel>[],
  });

  const SearchPlayerState.init() : this._(status: BlocStatusEnum.init);

  const SearchPlayerState.loading() : this._(status: BlocStatusEnum.loading);

  const SearchPlayerState.success(
    List<PlayerDetailResponseModel> items,
  ) : this._(status: BlocStatusEnum.success, items: items);

  const SearchPlayerState.failure(
    String? errorMessage,
  ) : this._(errorMessage: errorMessage, status: BlocStatusEnum.failure);

  @override
  List<Object> get props => [status, items];
}
