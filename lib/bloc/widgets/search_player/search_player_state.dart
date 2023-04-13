import 'package:equatable/equatable.dart';

import '../../../models/api/player_detail_response_model.dart';

abstract class SearchPlayerState extends Equatable {
  const SearchPlayerState();

  @override
  List<Object?> get props => [];
}

class SearchStateEmpty extends SearchPlayerState {}

class SearchStateLoading extends SearchPlayerState {}

class SearchStateSuccess extends SearchPlayerState {
  const SearchStateSuccess({required this.items});

  final List<PlayerDetailResponseModel> items;

  @override
  List<Object?> get props => [items];

  @override
  String toString() => 'SearchStateSuccess { items: ${items.length} }';
}

class SearchStateError extends SearchPlayerState {
  const SearchStateError(this.error);

  final String error;

  @override
  List<Object?> get props => [error];
}
