class LeagueResultModel {
  LeagueResultModel({
    required this.promoted,
    required this.demoted,
  });

  final int promoted;
  final int demoted;

  LeagueResultModel copyWith({
    int? promoted,
    int? demoted,
  }) =>
      LeagueResultModel(
        promoted: promoted ?? this.promoted,
        demoted: demoted ?? this.demoted,
      );
}
