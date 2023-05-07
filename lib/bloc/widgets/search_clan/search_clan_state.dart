import 'package:equatable/equatable.dart';

import '../../../models/api/response/search_clans_response_model.dart';

abstract class SearchClanState extends Equatable {
  const SearchClanState();

  @override
  List<Object?> get props => [];
}

class SearchStateEmpty extends SearchClanState {}

class SearchStateLoading extends SearchClanState {}

class SearchStateSuccess extends SearchClanState {
  const SearchStateSuccess({this.after, required this.items});

  final String? after;
  final List<SearchClanItem> items;

  @override
  List<Object?> get props => [after, items];

  @override
  String toString() =>
      'SearchStateSuccess { after: $after, items: ${items.length} }';
}

class SearchStateError extends SearchClanState {
  const SearchStateError(this.error);

  final String error;

  @override
  List<Object?> get props => [error];
}
