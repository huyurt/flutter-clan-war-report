import 'package:equatable/equatable.dart';

import '../../../models/api/search_clans_request_model.dart';

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

  @override
  String toString() => 'TextChanged { clanName: ${searchTerm.clanName} }';
}

class FilterChanged extends SearchClanBaseEvent {
  FilterChanged({required super.searchTerm});

  @override
  String toString() =>
      'FilterChanged { minMembers: ${searchTerm.minMembers}, maxMembers: ${searchTerm.maxMembers}, minClanLevel: ${searchTerm.minClanLevel} }';
}

class NextPageFetched extends SearchClanBaseEvent {
  NextPageFetched({required super.searchTerm});

  @override
  String toString() => 'NextPageFetched { after: ${searchTerm.after} }';
}
