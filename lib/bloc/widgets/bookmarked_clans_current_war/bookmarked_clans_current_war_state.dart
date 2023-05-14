import 'package:equatable/equatable.dart';

import '../../../models/coc/clans_current_war_state_model.dart';
import '../../../utils/enums/bloc_status_enum.dart';

class BookmarkedClansCurrentWarState extends Equatable {
  final BlocStatusEnum status;
  final List<ClansCurrentWarStateModel?> items;

  const BookmarkedClansCurrentWarState._({
    this.status = BlocStatusEnum.loading,
    this.items = const <ClansCurrentWarStateModel>[],
  });

  const BookmarkedClansCurrentWarState.init() : this._(status: BlocStatusEnum.init);

  const BookmarkedClansCurrentWarState.loading(
    List<ClansCurrentWarStateModel?> items,
  ) : this._(status: BlocStatusEnum.loading, items: items);

  const BookmarkedClansCurrentWarState.success(
    List<ClansCurrentWarStateModel?> items,
  ) : this._(status: BlocStatusEnum.success, items: items);

  const BookmarkedClansCurrentWarState.failure()
      : this._(status: BlocStatusEnum.failure);

  @override
  List<Object> get props => [status, items];
}
