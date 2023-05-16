import 'package:equatable/equatable.dart';

import '../../../models/coc/clans_current_war_state_model.dart';
import '../../../utils/enums/bloc_status_enum.dart';

class ClanCurrentWarDetailState extends Equatable {
  final String? errorMessage;
  final BlocStatusEnum status;
  final ClansCurrentWarStateModel? item;

  const ClanCurrentWarDetailState._({
    this.errorMessage,
    this.status = BlocStatusEnum.loading,
    this.item,
  });

  const ClanCurrentWarDetailState.init() : this._(status: BlocStatusEnum.init);

  const ClanCurrentWarDetailState.loading()
      : this._(status: BlocStatusEnum.loading);

  const ClanCurrentWarDetailState.success(
    ClansCurrentWarStateModel item,
  ) : this._(status: BlocStatusEnum.success, item: item);

  const ClanCurrentWarDetailState.failure(
    String? errorMessage,
  ) : this._(errorMessage: errorMessage, status: BlocStatusEnum.failure);

  @override
  List<Object?> get props => [status, item];
}
