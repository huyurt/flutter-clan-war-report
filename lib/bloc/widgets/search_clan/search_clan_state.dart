import 'package:equatable/equatable.dart';

import '../../../models/api/response/search_clans_response_model.dart';
import '../../../utils/enums/bloc_status_enum.dart';

class SearchClanState extends Equatable {
  final String? errorMessage;
  final BlocStatusEnum status;
  final String? after;
  final List<SearchClanItem> items;

  const SearchClanState._({
    this.errorMessage,
    this.status = BlocStatusEnum.loading,
    this.after,
    this.items = const <SearchClanItem>[],
  });

  const SearchClanState.init() : this._(status: BlocStatusEnum.init);

  const SearchClanState.loading() : this._(status: BlocStatusEnum.loading);

  const SearchClanState.success(
    String? after,
    List<SearchClanItem> items,
  ) : this._(status: BlocStatusEnum.success, after: after, items: items);

  const SearchClanState.failure(
    String? errorMessage,
  ) : this._(errorMessage: errorMessage, status: BlocStatusEnum.failure);

  @override
  List<Object?> get props => [status, after, items];
}
