import 'package:equatable/equatable.dart';

import '../../../models/api/response/clan_detail_response_model.dart';
import '../../../utils/enums/bloc_status_enum.dart';

class BookmarkedClansState extends Equatable {
  final BlocStatusEnum status;
  final List<ClanDetailResponseModel?> items;

  const BookmarkedClansState._({
    this.status = BlocStatusEnum.loading,
    this.items = const <ClanDetailResponseModel>[],
  });

  const BookmarkedClansState.init() : this._(status: BlocStatusEnum.init);

  const BookmarkedClansState.loading(
    List<ClanDetailResponseModel?> items,
  ) : this._(status: BlocStatusEnum.loading, items: items);

  const BookmarkedClansState.success(
    List<ClanDetailResponseModel?> items,
  ) : this._(status: BlocStatusEnum.success, items: items);

  const BookmarkedClansState.failure() : this._(status: BlocStatusEnum.failure);

  @override
  List<Object> get props => [status, items];
}
