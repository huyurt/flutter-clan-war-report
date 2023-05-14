import 'package:equatable/equatable.dart';

abstract class SearchPlayerEvent extends Equatable {}

abstract class SearchPlayerBaseEvent extends SearchPlayerEvent {
  SearchPlayerBaseEvent({required this.searchTerm});

  final String searchTerm;

  @override
  List<Object> get props => [searchTerm];
}

class ClearFilter extends SearchPlayerEvent {
  @override
  List<Object?> get props => [];
}

class TextChanged extends SearchPlayerBaseEvent {
  TextChanged({required super.searchTerm});
}
