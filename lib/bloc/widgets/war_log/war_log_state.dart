import 'package:equatable/equatable.dart';

import '../../../models/api/response/war_log_response_model.dart';
import '../../../utils/enums/bloc_status_enum.dart';

class WarLogState extends Equatable {
  final String? errorMessage;
  final BlocStatusEnum status;
  final List<WarLogItem> items;

  const WarLogState._({
    this.errorMessage,
    this.status = BlocStatusEnum.loading,
    this.items = const <WarLogItem>[],
  });

  const WarLogState.init() : this._(status: BlocStatusEnum.init);

  const WarLogState.loading() : this._(status: BlocStatusEnum.loading);

  const WarLogState.success(
    List<WarLogItem> items,
  ) : this._(status: BlocStatusEnum.success, items: items);

  const WarLogState.failure(
    String? errorMessage,
  ) : this._(errorMessage: errorMessage, status: BlocStatusEnum.failure);

  @override
  List<Object?> get props => [status, items];
}
