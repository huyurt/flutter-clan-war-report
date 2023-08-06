import 'package:clan_war_report/models/api/response/clan_detail_response_model.dart';

import '../api/response/war_log_response_model.dart';

class WarLogsModel {
  WarLogsModel({
    required this.clan,
    required this.warLogs,
  });

  final ClanDetailResponseModel clan;
  final List<WarLogItem> warLogs;

  WarLogsModel copyWith({
    ClanDetailResponseModel? clan,
    List<WarLogItem>? warLogs,
  }) =>
      WarLogsModel(
        clan: clan ?? this.clan,
        warLogs: warLogs ?? this.warLogs,
      );
}
