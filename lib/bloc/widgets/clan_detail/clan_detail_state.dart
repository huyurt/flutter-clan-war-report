import 'package:equatable/equatable.dart';

import '../../../models/api/response/clan_detail_response_model.dart';
import '../../../utils/enums/bloc_status_enum.dart';

class ClanDetailState extends Equatable {
  final BlocStatusEnum status;
  final ClanDetailResponseModel? item;

  const ClanDetailState._({
    this.status = BlocStatusEnum.loading,
    this.item,
  });

  const ClanDetailState.init() : this._(status: BlocStatusEnum.init);

  const ClanDetailState.loading() : this._(status: BlocStatusEnum.loading);

  const ClanDetailState.success(
    ClanDetailResponseModel item,
  ) : this._(status: BlocStatusEnum.success, item: item);

  const ClanDetailState.failure() : this._(status: BlocStatusEnum.failure);

  @override
  List<Object?> get props => [status, item];
}
