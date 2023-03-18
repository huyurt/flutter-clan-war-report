class SearchClansRequestModel {
  SearchClansRequestModel({
    required this.clanName,
    required this.minMembers,
    required this.maxMembers,
    required this.minClanLevel,
    this.after,
    this.before,
  });

  final String clanName;
  final int minMembers;
  final int maxMembers;
  final int minClanLevel;
  final String? after;
  final String? before;
}
