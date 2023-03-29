import 'package:equatable/equatable.dart';

class SearchClansRequestModel extends Equatable {
  const SearchClansRequestModel({
    required this.clanName,
    this.minMembers,
    this.maxMembers,
    this.minClanLevel,
    this.after,
    this.before,
  });

  final String clanName;
  final int? minMembers;
  final int? maxMembers;
  final int? minClanLevel;
  final String? after;
  final String? before;

  @override
  List<Object?> get props =>
      [clanName, minMembers, maxMembers, minClanLevel, after];
}
