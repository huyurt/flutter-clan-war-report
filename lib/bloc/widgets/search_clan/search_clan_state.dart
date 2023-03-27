import 'package:equatable/equatable.dart';

import '../../../models/api/search_clans_response_model.dart';

abstract class SearchClanState extends Equatable {
  const SearchClanState();

  @override
  List<Object> get props => [];
}

class SearchStateEmpty extends SearchClanState {}

class SearchStateLoading extends SearchClanState {}

class SearchStateSuccess extends SearchClanState {
  const SearchStateSuccess(this.items);

  final List<SearchedClanItem> items;

  @override
  List<Object> get props => [items];

  @override
  String toString() => 'SearchStateSuccess { items: ${items.length} }';
}

class SearchStateError extends SearchClanState {
  const SearchStateError(this.error);

  final String error;

  @override
  List<Object> get props => [error];
}
