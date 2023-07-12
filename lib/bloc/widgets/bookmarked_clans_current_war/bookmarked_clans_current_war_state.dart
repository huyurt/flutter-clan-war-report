import 'package:equatable/equatable.dart';

import '../../../models/coc/clans_current_war_state_model.dart';
import '../../../utils/enums/bloc_status_enum.dart';

class BookmarkedClansCurrentWarState extends Equatable {
  final bool isTimeout;
  final String? errorMessage;
  final BlocStatusEnum status;
  final List<ClansCurrentWarStateModel?> items;

  const BookmarkedClansCurrentWarState._({
    this.isTimeout = false,
    this.errorMessage,
    this.status = BlocStatusEnum.loading,
    this.items = const <ClansCurrentWarStateModel>[],
  });

  const BookmarkedClansCurrentWarState.init()
      : this._(status: BlocStatusEnum.init);

  const BookmarkedClansCurrentWarState.loading(
    List<ClansCurrentWarStateModel?> items,
  ) : this._(status: BlocStatusEnum.loading, items: items);

  const BookmarkedClansCurrentWarState.success(
    List<ClansCurrentWarStateModel?> items,
  ) : this._(status: BlocStatusEnum.success, items: items);

  const BookmarkedClansCurrentWarState.failure(
    bool isTimeout,
    String? errorMessage,
  ) : this._(isTimeout: isTimeout, errorMessage: errorMessage, status: BlocStatusEnum.failure);

  @override
  List<Object> get props => [status, items];
}
