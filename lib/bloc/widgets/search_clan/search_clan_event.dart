import 'package:equatable/equatable.dart';

import '../../../models/api/request/search_clans_request_model.dart';

abstract class SearchClanEvent extends Equatable {
}

abstract class SearchClanBaseEvent extends SearchClanEvent {
  SearchClanBaseEvent({required this.searchTerm});

  final SearchClansRequestModel searchTerm;

  @override
  List<Object> get props => [searchTerm];
}

class ClearFilter extends SearchClanEvent {
  @override
  List<Object?> get props => [];
}

class TextChanged extends SearchClanBaseEvent {
  TextChanged({required super.searchTerm});
}

class FilterChanged extends SearchClanBaseEvent {
  FilterChanged({required super.searchTerm});
}

class NextPageFetched extends SearchClanBaseEvent {
  NextPageFetched({required super.searchTerm});
}
