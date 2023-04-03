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

  SearchClansRequestModel copyWith({
    String? clanName,
    int? minMembers,
    int? maxMembers,
    int? minClanLevel,
    String? after,
    String? before,
  }) =>
      SearchClansRequestModel(
        clanName: clanName ?? this.clanName,
        minMembers: minMembers ?? this.minMembers,
        maxMembers: maxMembers ?? this.maxMembers,
        minClanLevel: minClanLevel ?? this.minClanLevel,
        after: after ?? this.after,
        before: before ?? this.before,
      );

  @override
  List<Object?> get props =>
      [clanName, minMembers, maxMembers, minClanLevel, after];
}
