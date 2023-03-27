import 'package:equatable/equatable.dart';

abstract class SearchClanEvent extends Equatable {
  const SearchClanEvent();
}

class TextChanged extends SearchClanEvent {
  const TextChanged({required this.clanName, required this.minClanLevel, required this.maxMembers, required this.minMembers});

  final String clanName;
  final int minMembers;
  final int maxMembers;
  final int minClanLevel;

  @override
  List<Object> get props => [clanName, minMembers, maxMembers, minClanLevel];

  @override
  String toString() => 'TextChanged { clanName: $clanName }';
}
